import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/chat/chat_list.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/service/main/main_service.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/service/main/service_search.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/real_estate/real_estate_search.dart';
import 'package:app/pages/shaxsiy/shaxsiy.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/l10n/app_localizations.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen>
    with TickerProviderStateMixin {
  late int _selectedPageIndex = 0;
  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> _fabAnimation;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.initialIndex;

    _fabAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _borderRadiusAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _borderRadiusAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _borderRadiusAnimationController, curve: Curves.easeInOut),
    );

    _fabAnimationController.forward();
    _borderRadiusAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _borderRadiusAnimationController.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() {
      if (index != _selectedPageIndex) {
        // Add haptic feedback
        HapticFeedback.selectionClick();

        // Only refresh providers when switching to avoid unnecessary reloads
        switch (index) {
          case 0:
            ref.invalidate(productsProvider);
            break;
          case 1:
            ref.invalidate(servicesProvider);
            break;
          case 2:
            // Add real estate provider refresh when you create it
            // ref.invalidate(realEstateProvider);
            break;
          // case 3 is Messages - no need to refresh
          // case 4 is Profile - refreshed when needed
        }
      }
      _selectedPageIndex = index;
    });
  }

  Future<void> _navigateToLocationChange() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomeTown(),
        settings: RouteSettings(name: '/location-change'),
      ),
    );

    if (result == true) {
      ref.invalidate(profileServiceProvider);
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final userInfoAsync = ref.watch(profileServiceProvider.select(
          (provider) => provider.getUserInfo(),
        ));

        return FutureBuilder<UserInfo>(
          future: userInfoAsync,
          builder: (context, snapshot) {
            String regionName = '';
            String districtName = '';

            if (snapshot.hasData && snapshot.data!.location != null) {
              regionName = snapshot.data!.location!.region ?? '';
              districtName = snapshot.data!.location!.district ?? '';
            }

            // Get active page info
            final pageInfo = _getPageInfo(
                _selectedPageIndex, localizations, regionName, districtName);

            return Scaffold(
              backgroundColor: theme.colorScheme.surface,
              appBar: _buildModernAppBar(context, theme, localizations,
                  snapshot, regionName, districtName),
              body: AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(0.1, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey(_selectedPageIndex),
                  child: pageInfo.widget,
                ),
              ),
              bottomNavigationBar:
                  _buildModernBottomNavBar(context, theme, localizations),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
            );
          },
        );
      },
    );
  }

  PreferredSizeWidget _buildModernAppBar(
      BuildContext context,
      ThemeData theme,
      AppLocalizations? localizations,
      AsyncSnapshot<UserInfo> snapshot,
      String regionName,
      String districtName) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
      ),
      leading: _buildLocationSelector(context, theme, localizations, snapshot),
      title: Text(
        _getPageInfo(_selectedPageIndex, localizations, '', '').title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      actions: [
        if (_shouldShowSearchFAB())
          IconButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _navigateToSearch(regionName, districtName);
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 26,
            ),
          ),
        if (_shouldShowNotification())
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 26,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildLocationSelector(
    BuildContext context,
    ThemeData theme,
    AppLocalizations? localizations,
    AsyncSnapshot<UserInfo> snapshot,
  ) {
    return GestureDetector(
      onTap: _navigateToLocationChange,
      child: Container(
        margin: EdgeInsets.only(left: 4, top: 8, bottom: 8),
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.25, // Even smaller - 25% of screen
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Removed location icon to save space
            Flexible(
              child: Consumer(
                builder: (context, ref, child) {
                  final userInfoAsync = ref.watch(profileServiceProvider.select(
                    (provider) => provider.getUserInfo(),
                  ));

                  return FutureBuilder<UserInfo>(
                    future: userInfoAsync,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        );
                      } else if (!snapshot.hasData) {
                        return SizedBox(
                          width: 30,
                          height: 8,
                          child: LinearProgressIndicator(
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                      }

                      final user = snapshot.data!;
                      final district = user.location?.district ??
                          (localizations?.searchLocation ?? 'Loc');

                      // Very short text for small space
                      String displayedText;
                      if (district.length <= 4) {
                        displayedText = district;
                      } else {
                        displayedText = '${district.substring(0, 3)}..';
                      }
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomeTown(),
                            ),
                          );
                        },
                        child: Text(
                          displayedText,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernBottomNavBar(
    BuildContext context,
    ThemeData theme,
    AppLocalizations? localizations,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home,
                  localizations?.main ?? 'Asosiy', theme),
              _buildNavItem(1, Icons.post_add_outlined, Icons.post_add,
                  localizations?.servicesTitle ?? 'Services', theme),
              _buildNavItem(2, Icons.chat_outlined, Icons.chat_bubble,
                  localizations?.chat ?? 'Chat', theme),
              _buildNavItem(3, Icons.apartment_outlined, Icons.apartment,
                  localizations?.realEstate ?? 'Ko\'chmas', theme),
              _buildNavItem(4, Icons.person_outline, Icons.person,
                  localizations?.profile ?? 'Shaxsiy', theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    ThemeData theme,
  ) {
    final isSelected = _selectedPageIndex == index;

    // 🔥 Get unread count for Messages tab (index 2)
    final unreadCount = index == 2 ? ref.watch(totalUnreadCountProvider) : 0;

    return GestureDetector(
      onTap: () => _selectPage(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔥 Add Stack for badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? filledIcon : outlinedIcon,
                    key: ValueKey(isSelected),
                    color: isSelected ? theme.primaryColor : Colors.grey[600],
                    size: 24,
                  ),
                ),
                // 🔥 Badge for unread messages
                if (unreadCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? theme.primaryColor : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToSearch(String regionName, String districtName) {
    if (_selectedPageIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ProductSearch(
                  regionName: regionName,
                  districtName: districtName,
                )),
      );
    } else if (_selectedPageIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => ServiceSearch(
                  regionName: regionName,
                  districtName: districtName,
                )),
      );
    } else if (_selectedPageIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (ctx) => const RealEstateSearch()),
      );
    }
  }

  bool _shouldShowSearchFAB() {
    return _selectedPageIndex == 0 ||
        _selectedPageIndex == 1 ||
        _selectedPageIndex == 2;
  }

  bool _shouldShowNotification() {
    return _selectedPageIndex == 3; // Show on messages/chat page
  }

  PageInfo _getPageInfo(int index, AppLocalizations? localizations,
      String regionName, String districtName) {
    switch (index) {
      case 0:
        return PageInfo(
          title: localizations?.productsTitle ?? 'Products',
          widget:
              ProductsList(regionName: regionName, districtName: districtName),
        );
      case 1:
        return PageInfo(
          title: localizations?.servicesTitle ?? 'Services',
          widget:
              ServiceMain(regionName: regionName, districtName: districtName),
        );
      case 2:
        return PageInfo(
            title: localizations?.message ?? 'Chat', widget: MessagesList());
      case 3:
        return PageInfo(
          title: localizations?.realEstate ?? 'Real Estate',
          widget: RealEstateMain(
              regionName: regionName, districtName: districtName),
        );

      case 4:
        return PageInfo(
          title: localizations?.profile ?? 'Shaxsiy Hisob',
          widget: const ShaxsiyPage(),
        );
      default:
        return PageInfo(
          title: localizations?.productsTitle ?? 'Products',
          widget:
              ProductsList(regionName: regionName, districtName: districtName),
        );
    }
  }
}

class PageInfo {
  final String title;
  final Widget widget;

  PageInfo({required this.title, required this.widget});
}

// Enhanced Property Card Widget for Real Estate
class ModernPropertyCard extends StatelessWidget {
  final Map<String, dynamic> property;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const ModernPropertyCard({
    Key? key,
    required this.property,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(property['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Status badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        property['status'] ?? 'For Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Photo count
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.white, size: 12),
                          SizedBox(width: 4),
                          Text(
                            '${property['photos'] ?? 5}',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onFavorite,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Content section
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property['title'] ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            property['address'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      property['price'] ?? '',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        _buildPropertyDetail(
                            Icons.bed, '${property['beds'] ?? 0}'),
                        SizedBox(width: 16),
                        _buildPropertyDetail(
                            Icons.bathroom, '${property['baths'] ?? 0}'),
                        SizedBox(width: 16),
                        _buildPropertyDetail(
                            Icons.square_foot, property['sqft'] ?? ''),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Handle call action
                            },
                            icon: Icon(Icons.phone, size: 18),
                            label: Text('Qo\'ng\'iroq'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Handle message action
                            },
                            icon: Icon(Icons.message, size: 18),
                            label: Text('Xabar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.primaryColor,
                              side: BorderSide(color: theme.primaryColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyDetail(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
