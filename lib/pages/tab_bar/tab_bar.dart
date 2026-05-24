import 'package:app/pages/chat/chat_list.dart';
import 'package:app/pages/service/main/main_service.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/shaxsiy/shaxsiy.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/notification_bell.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';
import 'package:app/widgets/maps/neighborhood_switcher_sheet.dart';
import 'package:app/providers/provider_root/notification_provider.dart';
import 'package:app/service/push_notification_service.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to get local location as fallback (includes districtId)
final localLocationProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final districtIdStr = prefs.getString('userLocation');
  return {
    'region': prefs.getString('localRegionName') ?? '',
    'district': prefs.getString('localDistrictName') ?? '',
    'districtId': districtIdStr != null ? int.tryParse(districtIdStr) : null,
  };
});

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen>
    with TickerProviderStateMixin {
  late int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.initialIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productNotificationProvider);
      ref.read(serviceNotificationProvider);
      ref.read(chatNotificationProvider);
      ref.read(realEstateNotificationProvider);
      ref.read(commentNotificationProvider);
      print('✅ All notification providers initialized');

      ref.read(chatProvider.notifier).initialize();
      print('✅ Chat provider initialized - socket will connect automatically');

      final notificationWebSocketService = ref.read(
        notificationWebSocketServiceProvider,
      );
      PushNotificationService().setNotificationWebSocketService(
        notificationWebSocketService,
      );
      print(
        '✅ Push notification service connected to notification WebSocket service',
      );
    });
  }

  @override
  void didUpdateWidget(TabsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      print(
        '📱 TabsScreen: initialIndex changed from ${oldWidget.initialIndex} to ${widget.initialIndex}',
      );
      setState(() {
        _selectedPageIndex = widget.initialIndex;
      });
    }
  }

  void _selectPage(int index) {
    if (index == _selectedPageIndex) return;
    HapticFeedback.selectionClick();
    setState(() {
      switch (index) {
        case 0:
          ref.invalidate(productsProvider);
          break;
        case 1:
          ref.invalidate(servicesProvider);
          break;
      }
      _selectedPageIndex = index;
    });
  }



  void _syncLocalLocation(
    int? districtId,
    String? region,
    String? district,
    String? countryCode,
  ) async {
    if (districtId == null) return;
    final prefs = await SharedPreferences.getInstance();
    final storedId = prefs.getString('userLocation');
    if (storedId == null || storedId.isEmpty) {
      await prefs.setString('userLocation', districtId.toString());
      await prefs.setString('localRegionName', region ?? '');
      await prefs.setString('localDistrictName', district ?? '');
      if (countryCode != null && countryCode.isNotEmpty) {
        await prefs.setString('localCountryCode', countryCode);
      }
      print(
        '📍 [TabBar] Synced local storage with backend: districtId=$districtId',
      );
      ref.invalidate(localLocationProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer(
      builder: (context, ref, child) {
        final userInfoAsync = ref.watch(
          profileServiceProvider.select((provider) => provider.getUserInfo()),
        );
        final localLocation = ref.watch(localLocationProvider);
        final localRegion =
            localLocation.valueOrNull?['region'] as String? ?? '';
        final localDistrict =
            localLocation.valueOrNull?['district'] as String? ?? '';
        final localDistrictId =
            localLocation.valueOrNull?['districtId'] as int?;
        // Karrot priority: a fresh map pick wins over local prefs / backend
        // profile location for both the products query AND the TabBar's
        // visible location chip.
        final activeNbhd = ref.watch(activeNeighborhoodProvider);

        return FutureBuilder<UserInfo>(
          future: userInfoAsync,
          builder: (context, snapshot) {
            String regionName = '';
            String districtName = '';
            int? districtId;

            if (activeNbhd != null) {
              regionName = activeNbhd.neighborhood.region;
              districtName = activeNbhd.neighborhood.city.isNotEmpty
                  ? activeNbhd.neighborhood.city
                  : activeNbhd.neighborhood.name;
              // No backend district FK for off-grid picks — keep null;
              // products/services list pages prefer activeNeighborhood path
              // when this is the case.
              districtId = null;
              print(
                '📍 [TabBar] Using ACTIVE PICK: ${activeNbhd.neighborhood.displayName}',
              );
            } else if (localDistrictId != null &&
                localRegion.isNotEmpty &&
                localDistrict.isNotEmpty) {
              regionName = localRegion;
              districtName = localDistrict;
              districtId = localDistrictId;
              if (snapshot.hasData) {
                final loc = snapshot.data!.location;
                if (loc.id != localDistrictId) {
                  print(
                    '📍 [TabBar] Using LOCAL (newer): districtId=$localDistrictId (backend cache has stale id=${loc.id})',
                  );
                } else {
                  print(
                    '📍 [TabBar] Location: id=$districtId, region=$regionName, district=$districtName',
                  );
                }
              } else {
                print(
                  '📍 [TabBar] Using LOCAL: districtId=$localDistrictId, region=$localRegion, district=$localDistrict',
                );
              }
            } else if (snapshot.hasData) {
              final loc = snapshot.data!.location;
              regionName = loc.region;
              districtName = loc.district;
              districtId = loc.id;
              print(
                '📍 [TabBar] Using BACKEND: id=${loc.id}, region=${loc.region}, district=${loc.district}',
              );
              _syncLocalLocation(loc.id, loc.region, loc.district, loc.countryCode);
            } else {
              print('📍 [TabBar] Waiting for location data...');
            }

            final pageInfo = _getPageInfo(
              _selectedPageIndex,
              localizations,
              regionName,
              districtName,
              districtId,
            );

            return Scaffold(
              backgroundColor: colorScheme.surface,
              extendBody: false,
              appBar: _buildAppBar(
                context,
                theme,
                colorScheme,
                localizations,
                snapshot,
                regionName,
                districtName,
              ),
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: KeyedSubtree(
                  key: ValueKey(_selectedPageIndex),
                  child: pageInfo.widget,
                ),
              ),
              bottomNavigationBar: _ModernBottomNav(
                selectedIndex: _selectedPageIndex,
                onTap: _selectPage,
                unreadChatCount: ref.watch(totalUnreadCountProvider),
              ),
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
    AsyncSnapshot<UserInfo> snapshot,
    String regionName,
    String districtName,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      leading: _buildLocationChip(context, theme, colorScheme, localizations, snapshot),
      leadingWidth: 140,
      title: Text(
        _getPageInfo(_selectedPageIndex, localizations, '', '', null).title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (_shouldShowSearchFAB())
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _navigateToSearch(regionName, districtName);
            },
            icon: Icon(Icons.search_rounded, size: 24),
          ),
        if (_shouldShowNotification())
          Consumer(
            builder: (context, ref, child) {
              final provider = _getNotificationProvider();
              if (provider == null) return const SizedBox.shrink();
              final state = ref.watch(provider);
              print(
                '🔔 AppBar Consumer: watching provider, unreadCount=${state.unreadCount}',
              );
              return NotificationBell(
                key: ValueKey('notification_bell_$_selectedPageIndex'),
                provider: provider,
                iconColor: null,
              );
            },
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildLocationChip(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
    AsyncSnapshot<UserInfo> snapshot,
  ) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => const NeighborhoodSwitcherSheet(),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              size: 14,
              color: colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Consumer(
                builder: (context, ref, child) {
                  // Karrot priority: a fresh map pick wins over the backend
                  // profile district for the location chip too.
                  final activeNbhd = ref.watch(activeNeighborhoodProvider);
                  final userInfoAsync = ref.watch(
                    profileServiceProvider.select(
                      (provider) => provider.getUserInfo(),
                    ),
                  );
                  return FutureBuilder<UserInfo>(
                    future: userInfoAsync,
                    builder: (context, snapshot) {
                      String label;
                      if (activeNbhd != null) {
                        label = activeNbhd.neighborhood.city.isNotEmpty
                            ? activeNbhd.neighborhood.city
                            : activeNbhd.neighborhood.name;
                      } else if (!snapshot.hasData) {
                        label = '...';
                      } else {
                        label = snapshot.data!.location.district.isNotEmpty
                            ? snapshot.data!.location.district
                            : (localizations?.searchLocation ?? 'Location');
                      }
                      return Text(
                        label.length > 12
                            ? '${label.substring(0, 10)}..'
                            : label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSearch(String regionName, String districtName) {
    if (_selectedPageIndex == 0) {
      context.push('/product/search?region=$regionName&district=$districtName');
    } else if (_selectedPageIndex == 1) {
      context.push('/service/search?region=$regionName&district=$districtName');
    } else if (_selectedPageIndex == 3) {
      context.push('/real-estate/search');
    }
  }

  bool _shouldShowSearchFAB() {
    return _selectedPageIndex == 0 ||
        _selectedPageIndex == 1 ||
        _selectedPageIndex == 3;
  }

  bool _shouldShowNotification() {
    return _selectedPageIndex >= 0 && _selectedPageIndex <= 3;
  }

  StateNotifierProvider<NotificationNotifier, NotificationState>?
  _getNotificationProvider() {
    StateNotifierProvider<NotificationNotifier, NotificationState>? provider;
    switch (_selectedPageIndex) {
      case 0:
        provider = productNotificationProvider;
        break;
      case 1:
        provider = serviceNotificationProvider;
        break;
      case 2:
        provider = chatNotificationProvider;
        break;
      case 3:
        provider = realEstateNotificationProvider;
        break;
      default:
        provider = null;
    }
    print(
      '🔔 AppBar: Selected page index=$_selectedPageIndex, provider=${provider?.hashCode}',
    );
    return provider;
  }

  PageInfo _getPageInfo(
    int index,
    AppLocalizations? localizations,
    String regionName,
    String districtName,
    int? districtId,
  ) {
    switch (index) {
      case 0:
        return PageInfo(
          title: localizations?.productsTitle ?? 'Products',
          widget: NeighborhoodGate(
            child: ProductsList(
              regionName: regionName,
              districtName: districtName,
              districtId: districtId,
            ),
          ),
        );
      case 1:
        return PageInfo(
          title: localizations?.servicesTitle ?? 'Services',
          widget: NeighborhoodGate(
            child: ServiceMain(
              regionName: regionName,
              districtName: districtName,
              districtId: districtId,
            ),
          ),
        );
      case 2:
        return PageInfo(
          title: localizations?.message ?? 'Chat',
          widget: const MessagesList(),
        );
      case 3:
        return PageInfo(
          title: localizations?.realEstate ?? 'Real Estate',
          widget: RealEstateMain(
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        );
      case 4:
        return PageInfo(
          title: localizations?.profile ?? 'Profile',
          widget: const ShaxsiyPage(),
        );
      default:
        return PageInfo(
          title: localizations?.productsTitle ?? 'Products',
          widget: ProductsList(
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        );
    }
  }
}

class PageInfo {
  final String title;
  final Widget widget;
  PageInfo({required this.title, required this.widget});
}

// ─────────────────────────────────────────────────────────────
// Floating Pill Bottom Navigation
// ─────────────────────────────────────────────────────────────

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItemData(this.icon, this.activeIcon, this.label);
}

class _ModernBottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final int unreadChatCount;

  const _ModernBottomNav({
    required this.selectedIndex,
    required this.onTap,
    required this.unreadChatCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    final items = [
      _NavItemData(Icons.storefront_outlined, Icons.storefront, l?.main ?? 'Home'),
      _NavItemData(Icons.handyman_outlined, Icons.handyman, l?.servicesTitle ?? 'Services'),
      _NavItemData(Icons.chat_bubble_outline_rounded, Icons.chat_bubble_rounded, l?.chat ?? 'Chat'),
      _NavItemData(Icons.apartment_outlined, Icons.apartment, l?.realEstate ?? 'Estate'),
      _NavItemData(Icons.person_outline_rounded, Icons.person_rounded, l?.profile ?? 'Profile'),
    ];

    return Container(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: bottomPadding > 0 ? bottomPadding : 10,
          top: 6,
        ),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: isDark
                ? colorScheme.surfaceContainerHigh
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              final isSelected = selectedIndex == i;
              final badgeCount = i == 2 ? unreadChatCount : 0;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: _FloatingNavItem(
                    icon: isSelected ? item.activeIcon : item.icon,
                    label: item.label,
                    isSelected: isSelected,
                    badgeCount: badgeCount,
                    colorScheme: colorScheme,
                    theme: theme,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const _FloatingNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.badgeCount,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon inside pill when selected
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isSelected ? 16 : 0,
              vertical: isSelected ? 6 : 0,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    size: 23,
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3B30),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.brightness == Brightness.dark
                              ? colorScheme.surfaceContainerHigh
                              : colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          // Label
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: (theme.textTheme.labelSmall ?? const TextStyle()).copyWith(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 10,
              height: 1.0,
            ),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Phase-1 Carrot-style gate. Wraps a child with a "Verify your
/// neighborhood" wall when the user has zero verified neighborhoods (or all
/// have expired). Real estate is intentionally NOT wrapped — it stays
/// city-scale. See docs/superpowers/specs/2026-05-10-internationalization-and-maps-design.md.
class NeighborhoodGate extends ConsumerWidget {
  const NeighborhoodGate({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(verifiedNeighborhoodsProvider);
    final allExpired = list.isNotEmpty && list.every((v) => v.isExpired);
    if (list.isEmpty || allExpired) {
      return _NeedsVerificationView(isExpired: allExpired);
    }
    return child;
  }
}

class _NeedsVerificationView extends StatelessWidget {
  const _NeedsVerificationView({required this.isExpired});
  final bool isExpired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_searching,
              size: 64,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              isExpired
                  ? 'Your neighborhood verification expired'
                  : 'Verify your neighborhood',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'We only show products and services from your area. '
              'Real estate browsing is unaffected.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => SafeArea(
                    child: NeighborhoodVerifier(
                      onDone: () => Navigator.of(ctx).pop(),
                    )),
              ),
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
