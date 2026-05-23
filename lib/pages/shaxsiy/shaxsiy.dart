import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/customer_center/customer_center.dart';
import 'package:app/pages/shaxsiy/inquires/main_inquiries.dart';
import 'package:app/pages/shaxsiy/profile-terms/terms_and_conditions.dart';
import 'package:app/pages/shaxsiy/security/main_security.dart';
import 'package:app/pages/shaxsiy/widgets/profile_follow_list_sheet.dart';
import 'package:app/pages/shaxsiy/widgets/profile_header.dart';
import 'package:app/pages/shaxsiy/widgets/profile_language_dialog.dart';
import 'package:app/pages/shaxsiy/widgets/profile_menu_card.dart';
import 'package:app/pages/shaxsiy/widgets/profile_role_cards.dart';
import 'package:app/pages/shaxsiy/widgets/profile_state_widgets.dart';
import 'package:app/pages/shaxsiy/widgets/profile_theme_dialog.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/neighborhood_verifier.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShaxsiyPage extends ConsumerStatefulWidget {
  const ShaxsiyPage({super.key});

  @override
  ConsumerState<ShaxsiyPage> createState() => _ShaxsiyPageState();
}

class _ShaxsiyPageState extends ConsumerState<ShaxsiyPage> {
  int _refreshKey = 0;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final userIdStr = prefs.getString('userId');
      _currentUserId = userIdStr != null ? int.tryParse(userIdStr) : null;
    });
  }

  Future<List<dynamic>> _fetchAllData() async {
    return Future.wait([
      ref.read(profileServiceProvider).getUserInfo(),
      ref.read(profileServiceProvider).getUserProducts(),
      ref.read(profileServiceProvider).getUserServices(),
      ref.read(profileServiceProvider).getUserFavoriteItems(),
    ]);
  }

  void _refreshProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(profileServiceProvider);
      if (_currentUserId != null) {
        ref.invalidate(userProfileProvider(_currentUserId!));
      }
    });
    setState(() {
      _refreshKey++;
    });
  }

  void _showFollowersSheet() {
    if (_currentUserId == null) return;
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileFollowListSheet(
        title: localizations?.profile_followers ?? 'Obunachilar',
        userId: _currentUserId!,
        isFollowers: true,
      ),
    );
  }

  void _showFollowingSheet() {
    if (_currentUserId == null) return;
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileFollowListSheet(
        title: localizations?.profile_following ?? 'Obunalar',
        userId: _currentUserId!,
        isFollowers: false,
      ),
    );
  }

  Future<void> _handleLogout() async {
    final localizations = AppLocalizations.of(context);
    final authService = ref.read(authenticationServiceProvider);

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations?.logout ?? 'Logout'),
        content: Text(localizations?.logout_all_devices_message ??
            'Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(localizations?.logout ?? 'Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      try {
        await authService.logout();
        if (mounted) {
          context.go('/login');
        }
      } catch (e) {
        if (mounted) {
          AppErrorHandler.showError(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(localizations?.profile ?? 'Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: colorScheme.onSurface),
            tooltip: localizations?.refresh ?? 'Refresh',
            onPressed: _refreshProfile,
          ),
          IconButton(
            icon: Icon(Icons.logout_rounded, color: colorScheme.error),
            tooltip: localizations?.logout ?? 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshProfile();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: FutureBuilder<List<dynamic>>(
          key: ValueKey(_refreshKey),
          future: _fetchAllData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return ProfileErrorState(
                error: snapshot.error,
                localizations: localizations,
                onRetry: _refreshProfile,
                onLogout: _handleLogout,
              );
            } else if (!snapshot.hasData) {
              return ProfileEmptyState(
                localizations: localizations,
                onRefresh: _refreshProfile,
              );
            }

            final user = snapshot.data![0] as UserInfo;
            final products = snapshot.data![1] as List<Products>;
            final services = snapshot.data![2] as List<Services>;
            final favoriteItems = snapshot.data![3] as FavoriteItems;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileHeader(
                    user: user,
                    totalListings: products.length + services.length,
                    currentUserId: _currentUserId,
                    onShowListings: () => context.push('/profile/my-products'),
                    onShowFollowers: _showFollowersSheet,
                    onShowFollowing: _showFollowingSheet,
                    onEditProfile: () async {
                      final result = await context.push<bool>('/profile/edit');
                      if (result == true) {
                        _refreshProfile();
                      }
                    },
                  ),
                  Divider(color: colorScheme.outlineVariant, height: 1),
                  const _MyNeighborhoodsSection(),
                  Divider(color: colorScheme.outlineVariant, height: 1),
                  ProfileSectionTitle(localizations?.myProfile ?? 'My Items'),
                  ProfileMenuCard(
                    icon: Icons.inventory_2_rounded,
                    title: localizations?.myProductsTitle ?? 'My Products',
                    subtitle: '${products.length} items',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => context.push('/profile/my-products'),
                  ),
                  ProfileMenuCard(
                    icon: Icons.room_service_rounded,
                    title: localizations?.myServicesTitle ?? 'My Services',
                    subtitle: '${services.length} services',
                    iconColor: const Color(0xFF2196F3),
                    onTap: () => context.push('/profile/my-services'),
                  ),
                  ProfileMenuCard(
                    icon: Icons.favorite_rounded,
                    title: localizations?.favoriteProductsTitle ??
                        'Favorite Products',
                    subtitle: '${favoriteItems.likedProducts.length} items',
                    iconColor: const Color(0xFFE91E63),
                    onTap: () => context.push('/profile/favorites/products'),
                  ),
                  ProfileMenuCard(
                    icon: Icons.star_rounded,
                    title: localizations?.favoriteServicesTitle ??
                        'Favorite Services',
                    subtitle:
                        '${favoriteItems.likedServices.length} services',
                    iconColor: const Color(0xFFFF9800),
                    onTap: () => context.push('/profile/favorites/services'),
                  ),
                  ProfileSavedPropertiesCard(localizations: localizations),
                  ProfileAgentCard(
                    localizations: localizations,
                    onAgentApplied: () => setState(() {}),
                  ),
                  ProfileAdminSection(
                    user: user,
                    localizations: localizations,
                  ),
                  ProfileSectionTitle(localizations?.settings ?? 'Settings'),
                  ProfileMenuCard(
                    icon: Icons.language_rounded,
                    title: localizations?.language ?? 'Language',
                    subtitle: getCurrentLanguageName(ref),
                    iconColor: const Color(0xFF2196F3),
                    onTap: () => showProfileLanguageDialog(context, ref),
                  ),
                  ProfileMenuCard(
                    icon: Icons.palette_rounded,
                    title: localizations?.theme ?? 'Theme',
                    subtitle: getCurrentThemeName(ref, localizations),
                    iconColor: const Color(0xFF607D8B),
                    onTap: () => showProfileThemeDialog(context, ref),
                  ),
                  ProfileMenuCard(
                    icon: Icons.my_location_rounded,
                    title: localizations?.location_settings ?? 'Location',
                    subtitle: 'Default area and location services',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => context.push('/change-city'),
                  ),
                  ProfileMenuCard(
                    icon: Icons.security_rounded,
                    title: localizations?.security ?? 'Security',
                    subtitle: 'Password, 2FA, and login history',
                    iconColor: const Color(0xFFE91E63),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SecuritySettingsPage()),
                    ),
                  ),
                  ProfileSectionTitle(
                      localizations?.customer_support ?? 'Support'),
                  ProfileMenuCard(
                    icon: Icons.headset_mic_rounded,
                    title: localizations?.customer_center ?? 'Customer Center',
                    subtitle: 'Get help and support',
                    iconColor: const Color(0xFF9C27B0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CustomerCenterPage()),
                    ),
                  ),
                  ProfileMenuCard(
                    icon: Icons.help_outline_rounded,
                    title: localizations?.customer_inquiries ?? 'Inquiries',
                    subtitle: 'Ask questions or report issues',
                    iconColor: const Color(0xFF607D8B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InquiriesPage()),
                    ),
                  ),
                  ProfileMenuCard(
                    icon: Icons.article_rounded,
                    title: localizations?.customer_terms ??
                        'Terms and Conditions',
                    subtitle: 'Privacy policy and terms',
                    iconColor: const Color(0xFF795548),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsAndConditionsPage()),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MyNeighborhoodsSection extends ConsumerWidget {
  const _MyNeighborhoodsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(verifiedNeighborhoodsProvider);
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('My neighborhoods', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            if (list.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('No verified neighborhoods yet.'),
              )
            else
              ...list.map((v) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.place,
                      color: v.isExpired
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                    ),
                    title: Text(v.neighborhood.displayName),
                    subtitle: Text(
                      v.isExpired
                          ? 'Expired — re-verify'
                          : 'Verified ${_formatRelative(v.verifiedAt)}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref
                          .read(verifiedNeighborhoodsProvider.notifier)
                          .remove(v.neighborhood.id),
                    ),
                  )),
            if (list.length < 2)
              TextButton.icon(
                onPressed: () => _openVerifierSheet(context),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: Text(list.isEmpty
                    ? 'Verify a neighborhood'
                    : 'Add a second neighborhood'),
              ),
          ],
        ),
      ),
    );
  }

  void _openVerifierSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const SafeArea(child: NeighborhoodVerifier()),
    );
  }

  String _formatRelative(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays >= 1) return '${diff.inDays}d ago';
    if (diff.inHours >= 1) return '${diff.inHours}h ago';
    return 'just now';
  }
}
