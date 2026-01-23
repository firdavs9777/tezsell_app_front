import 'package:app/constants/constants.dart';
import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/shaxsiy/customer_center/customer_center.dart';
import 'package:app/pages/shaxsiy/favorite_items/favorite_products.dart';
import 'package:app/pages/shaxsiy/favorite_items/favorite_services.dart';
import 'package:app/pages/shaxsiy/inquires/main_inquiries.dart';
import 'package:app/pages/shaxsiy/my-products/my_products.dart';
import 'package:app/pages/shaxsiy/my-services/my_services.dart';
import 'package:app/pages/shaxsiy/main_profile/profile_edit.dart';
import 'package:app/pages/shaxsiy/profile-terms/terms_and_conditions.dart';
import 'package:app/pages/shaxsiy/properties/saved_properties.dart';
import 'package:app/pages/shaxsiy/security/main_security.dart';
import 'package:app/pages/real_estate/agent/become_agent_page.dart';
import 'package:app/pages/real_estate/agent/agent_dashboard_page.dart';
import 'package:app/pages/admin/admin_dashboard.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/providers/provider_root/theme_provider.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/pages/authentication/login.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShaxsiyPage extends ConsumerStatefulWidget {
  const ShaxsiyPage({super.key});

  @override
  _ShaxsiyPageState createState() => _ShaxsiyPageState();
}

class _ShaxsiyPageState extends ConsumerState<ShaxsiyPage> {
  late Future<UserInfo> _userInfoFuture;
  int _refreshKey = 0;
  int? _currentUserId;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    {'code': 'uz', 'name': 'Uzbek', 'nativeName': 'O\'zbekcha', 'flag': '🇺🇿'},
  ];

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo();
    _loadCurrentUserId();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final userIdStr = prefs.getString('userId');
      _currentUserId = userIdStr != null ? int.tryParse(userIdStr) : null;
    });
  }

  Future<UserInfo> fetchUserInfo() async {
    return await ref.read(profileServiceProvider).getUserInfo();
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
      _userInfoFuture = fetchUserInfo();
      _refreshKey++;
    });
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  ImageProvider? _getProfileImage(UserInfo user) {
    if (user.profileImage?.image != null &&
        user.profileImage!.image.isNotEmpty) {
      final imageUrl = user.profileImage!.image.startsWith('http://') ||
              user.profileImage!.image.startsWith('https://')
          ? user.profileImage!.image
          : "$baseUrl${user.profileImage!.image}";
      return NetworkImage(imageUrl);
    }
    return null;
  }

  Widget _buildInstagramStyleHeader(
    UserInfo user,
    List<Products> products,
    List<Services> services,
    AppLocalizations? localizations,
    ColorScheme colorScheme,
  ) {
    final totalListings = products.length + services.length;

    // Try to get follow stats from the profile provider
    final profileAsync = _currentUserId != null
        ? ref.watch(userProfileProvider(_currentUserId!))
        : null;

    int followersCount = 0;
    int followingCount = 0;

    if (profileAsync != null) {
      profileAsync.whenData((profile) {
        followersCount = profile.followersCount;
        followingCount = profile.followingCount;
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header Row (Instagram style)
          Row(
            children: [
              // Profile Avatar
              GestureDetector(
                onTap: () {
                  if (_getProfileImage(user) != null) {
                    final imageUrl = user.profileImage!.image.startsWith('http://') ||
                            user.profileImage!.image.startsWith('https://')
                        ? user.profileImage!.image
                        : "$baseUrl${user.profileImage!.image}";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ImageViewer(
                          imageUrl: imageUrl,
                          title: user.username,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary,
                        colorScheme.tertiary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surface,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: _getProfileImage(user),
                      child: _getProfileImage(user) == null
                          ? Text(
                              user.username.isNotEmpty
                                  ? user.username[0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Stats Row
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn(
                      count: totalListings,
                      label: localizations?.profile_listings ?? "E'lonlar",
                      onTap: () => context.push('/profile/my-products'),
                    ),
                    _buildStatColumn(
                      count: followersCount,
                      label: localizations?.profile_followers ?? 'Obunachilar',
                      onTap: () => _showFollowersSheet(),
                    ),
                    _buildStatColumn(
                      count: followingCount,
                      label: localizations?.profile_following ?? 'Obunalar',
                      onTap: () => _showFollowingSheet(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Username and Info
          Text(
            user.username,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          // Location
          if (user.location != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.location!.region}, ${user.location!.district}',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),

          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                final result = await context.push<bool>('/profile/edit');
                if (result == true) {
                  _refreshProfile();
                }
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                localizations?.editProfileModalTitle ?? 'Profilni tahrirlash',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required int count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Text(
              _formatCount(count),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFollowersSheet() {
    if (_currentUserId == null) return;
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _FollowListSheet(
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
      builder: (context) => _FollowListSheet(
        title: localizations?.profile_following ?? 'Obunalar',
        userId: _currentUserId!,
        isFollowers: false,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (iconColor ?? const Color(0xFFFF6F00)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? const Color(0xFFFF6F00),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations? localizations) {
    final currentLocale = ref.read(localeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localizations?.selectLanguage ?? 'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              ...supportedLanguages.map((language) => _buildLanguageOption(
                    language['nativeName']!,
                    language['code']!,
                    language['flag']!,
                    currentLocale?.languageCode == language['code'],
                  )),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(String language, String code, String flag, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(code));
        Navigator.pop(context);
        _showSuccess('Language changed to $language');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: colorScheme.primary) : null,
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations? localizations) {
    final currentTheme = ref.read(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localizations?.select_theme ?? 'Select Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                localizations?.light_theme ?? 'Light',
                Icons.light_mode,
                ThemeMode.light,
                currentTheme == ThemeMode.light,
              ),
              _buildThemeOption(
                localizations?.dark_theme ?? 'Dark',
                Icons.dark_mode,
                ThemeMode.dark,
                currentTheme == ThemeMode.dark,
              ),
              _buildThemeOption(
                localizations?.system_theme ?? 'System Default',
                Icons.settings_brightness,
                ThemeMode.system,
                currentTheme == ThemeMode.system,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(String theme, IconData icon, ThemeMode themeMode, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        ref.read(themeProvider.notifier).setTheme(themeMode);
        Navigator.pop(context);
        _showSuccess('Theme changed to $theme');
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: colorScheme.primary) : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                theme,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageName() {
    final currentLocale = ref.read(localeProvider);
    if (currentLocale == null) return 'English';
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == currentLocale.languageCode,
      orElse: () => supportedLanguages[0],
    );
    return language['nativeName']!;
  }

  String _getCurrentThemeName(AppLocalizations? localizations) {
    final currentTheme = ref.read(themeProvider);
    switch (currentTheme) {
      case ThemeMode.light:
        return localizations?.light_theme ?? 'Light';
      case ThemeMode.dark:
        return localizations?.dark_theme ?? 'Dark';
      case ThemeMode.system:
      default:
        return localizations?.system_theme ?? 'System Default';
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
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
        content: Text(localizations?.logout_all_devices_message ?? 'Are you sure you want to logout?'),
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
        title: Text(
          localizations?.profile ?? 'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
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
              return _buildErrorState(snapshot.error, localizations, colorScheme);
            } else if (!snapshot.hasData) {
              return _buildEmptyState(localizations, colorScheme);
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
                  // Instagram-style Profile Header
                  _buildInstagramStyleHeader(user, products, services, localizations, colorScheme),

                  Divider(color: colorScheme.outlineVariant, height: 1),

                  // My Items Section
                  _buildSectionTitle(localizations?.myProfile ?? 'My Items'),

                  _buildMenuCard(
                    icon: Icons.inventory_2_rounded,
                    title: localizations?.myProductsTitle ?? 'My Products',
                    subtitle: '${products.length} items',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => context.push('/profile/my-products'),
                  ),

                  _buildMenuCard(
                    icon: Icons.room_service_rounded,
                    title: localizations?.myServicesTitle ?? 'My Services',
                    subtitle: '${services.length} services',
                    iconColor: const Color(0xFF2196F3),
                    onTap: () => context.push('/profile/my-services'),
                  ),

                  _buildMenuCard(
                    icon: Icons.favorite_rounded,
                    title: localizations?.favoriteProductsTitle ?? 'Favorite Products',
                    subtitle: '${favoriteItems.likedProducts.length} items',
                    iconColor: const Color(0xFFE91E63),
                    onTap: () => context.push('/profile/favorites/products'),
                  ),

                  _buildMenuCard(
                    icon: Icons.star_rounded,
                    title: localizations?.favoriteServicesTitle ?? 'Favorite Services',
                    subtitle: '${favoriteItems.likedServices.length} services',
                    iconColor: const Color(0xFFFF9800),
                    onTap: () => context.push('/profile/favorites/services'),
                  ),

                  // Saved Properties
                  _buildSavedPropertiesCard(localizations),

                  // Become Agent
                  _buildAgentCard(localizations),

                  // Admin Section
                  _buildAdminSection(user, localizations),

                  // Settings Section
                  _buildSectionTitle(localizations?.settings ?? 'Settings'),

                  _buildMenuCard(
                    icon: Icons.language_rounded,
                    title: localizations?.language ?? 'Language',
                    subtitle: _getCurrentLanguageName(),
                    iconColor: const Color(0xFF2196F3),
                    onTap: () => _showLanguageDialog(context, localizations),
                  ),

                  _buildMenuCard(
                    icon: Icons.palette_rounded,
                    title: localizations?.theme ?? 'Theme',
                    subtitle: _getCurrentThemeName(localizations),
                    iconColor: const Color(0xFF607D8B),
                    onTap: () => _showThemeDialog(context, localizations),
                  ),

                  _buildMenuCard(
                    icon: Icons.my_location_rounded,
                    title: localizations?.location_settings ?? 'Location',
                    subtitle: 'Default area and location services',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomeTown()),
                    ),
                  ),

                  _buildMenuCard(
                    icon: Icons.security_rounded,
                    title: localizations?.security ?? 'Security',
                    subtitle: 'Password, 2FA, and login history',
                    iconColor: const Color(0xFFE91E63),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecuritySettingsPage()),
                    ),
                  ),

                  // Support Section
                  _buildSectionTitle(localizations?.customer_support ?? 'Support'),

                  _buildMenuCard(
                    icon: Icons.headset_mic_rounded,
                    title: localizations?.customer_center ?? 'Customer Center',
                    subtitle: 'Get help and support',
                    iconColor: const Color(0xFF9C27B0),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CustomerCenterPage()),
                    ),
                  ),

                  _buildMenuCard(
                    icon: Icons.help_outline_rounded,
                    title: localizations?.customer_inquiries ?? 'Inquiries',
                    subtitle: 'Ask questions or report issues',
                    iconColor: const Color(0xFF607D8B),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InquiriesPage()),
                    ),
                  ),

                  _buildMenuCard(
                    icon: Icons.article_rounded,
                    title: localizations?.customer_terms ?? 'Terms and Conditions',
                    subtitle: 'Privacy policy and terms',
                    iconColor: const Color(0xFF795548),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
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

  Widget _buildErrorState(Object? error, AppLocalizations? localizations, ColorScheme colorScheme) {
    final errorMessage = error is Exception
        ? error.toString().replaceFirst('Exception: ', '')
        : error.toString();

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
              ),
              const SizedBox(height: 16),
              Text(
                localizations?.failed_to_refresh ?? 'Error loading profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _refreshProfile,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(localizations?.retry ?? 'Retry'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _handleLogout,
                icon: Icon(Icons.logout_rounded, color: colorScheme.error),
                label: Text(localizations?.logout ?? 'Logout', style: TextStyle(color: colorScheme.error)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations? localizations, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No user data available.',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _refreshProfile,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(localizations?.refresh ?? 'Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedPropertiesCard(AppLocalizations? localizations) {
    return Consumer(
      builder: (context, ref, _) {
        final tokenAsync = ref.watch(tokenProvider);

        return tokenAsync.when(
          data: (token) {
            if (token == null) {
              return _buildMenuCard(
                icon: Icons.real_estate_agent_rounded,
                title: localizations?.saved_properties_title ?? 'Saved Properties',
                subtitle: 'Login to view saved properties',
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedProperties()),
                ),
              );
            }

            final savedPropertiesAsync = ref.watch(savedPropertiesNotifierProvider(token));

            return savedPropertiesAsync.when(
              data: (response) => _buildMenuCard(
                icon: Icons.real_estate_agent_rounded,
                title: localizations?.saved_properties_title ?? 'Saved Properties',
                subtitle: '${response.count} items',
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedProperties()),
                ),
              ),
              loading: () => _buildMenuCard(
                icon: Icons.real_estate_agent_rounded,
                title: localizations?.saved_properties_title ?? 'Saved Properties',
                subtitle: 'Loading...',
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedProperties()),
                ),
              ),
              error: (_, __) => _buildMenuCard(
                icon: Icons.real_estate_agent_rounded,
                title: localizations?.saved_properties_title ?? 'Saved Properties',
                subtitle: '0 items',
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedProperties()),
                ),
              ),
            );
          },
          loading: () => _buildMenuCard(
            icon: Icons.real_estate_agent_rounded,
            title: localizations?.saved_properties_title ?? 'Saved Properties',
            subtitle: 'Loading...',
            iconColor: const Color(0xFF4CAF50),
            onTap: () {},
          ),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildAgentCard(AppLocalizations? localizations) {
    return Consumer(
      builder: (context, ref, _) {
        final tokenAsync = ref.watch(tokenProvider);

        return tokenAsync.when(
          data: (token) {
            if (token == null) {
              return _buildMenuCard(
                icon: Icons.badge_rounded,
                title: localizations?.becomeAgent ?? 'Become an Agent',
                subtitle: 'Login to apply',
                iconColor: const Color(0xFF2196F3),
                onTap: () => Navigator.of(context).pushNamed('/login'),
              );
            }

            return FutureBuilder<Map<String, dynamic>>(
              future: ref
                  .read(realEstateServiceProvider)
                  .getAgentStatus(token: token)
                  .catchError((e) => <String, dynamic>{'is_agent': false, 'is_verified': false}),
              builder: (context, snapshot) {
                final isAgent = snapshot.data?['is_agent'] ?? false;
                final isVerified = snapshot.data?['is_verified'] ?? false;

                if (isAgent && isVerified) {
                  return _buildMenuCard(
                    icon: Icons.verified_user_rounded,
                    title: localizations?.general_verified_agent ?? 'Verified Agent',
                    subtitle: localizations?.agentViewProfile ?? 'View your agent profile',
                    iconColor: const Color(0xFF4CAF50),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AgentDashboardPage()),
                    ),
                  );
                } else if (isAgent && !isVerified) {
                  return _buildMenuCard(
                    icon: Icons.pending_rounded,
                    title: localizations?.general_application_under_review ?? 'Application Under Review',
                    subtitle: localizations?.general_check_status ?? 'Check status',
                    iconColor: const Color(0xFFFF9800),
                    onTap: () async {
                      try {
                        final status = await ref.read(realEstateServiceProvider).getAgentApplicationStatus(token: token);
                        if (mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(localizations?.agentApplicationStatus ?? 'Application Status'),
                              content: Text(status['message'] ?? 'Your application is being reviewed.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(localizations?.close ?? 'Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        AppErrorHandler.showError(context, e);
                      }
                    },
                  );
                } else {
                  return _buildMenuCard(
                    icon: Icons.badge_rounded,
                    title: localizations?.becomeAgent ?? 'Become an Agent',
                    subtitle: localizations?.becomeAgentSubtitle ?? 'List properties and help clients',
                    iconColor: const Color(0xFF2196F3),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BecomeAgentPage()),
                    ).then((success) {
                      if (success == true) setState(() {});
                    }),
                  );
                }
              },
            );
          },
          loading: () => _buildMenuCard(
            icon: Icons.badge_rounded,
            title: localizations?.becomeAgent ?? 'Become an Agent',
            subtitle: 'Loading...',
            iconColor: const Color(0xFF2196F3),
            onTap: () {},
          ),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildAdminSection(UserInfo user, AppLocalizations? localizations) {
    final hasAdminAccess = user.hasAdminAccess;

    if (kDebugMode) {
      AppLogger.debug(
          'User admin check: userType=${user.userType}, isStaff=${user.isStaff}, isSuperuser=${user.isSuperuser}, hasAdminAccess=$hasAdminAccess');
    }

    if (hasAdminAccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(localizations?.admin_panel ?? 'Admin Panel'),
          _buildMenuCard(
            icon: Icons.admin_panel_settings,
            title: localizations?.admin_dashboard_title ?? 'Admin Dashboard',
            subtitle: localizations?.admin_dashboard_subtitle ?? 'Real-time overview of your platform',
            iconColor: const Color(0xFF9C27B0),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

// Follow List Bottom Sheet
class _FollowListSheet extends ConsumerWidget {
  final String title;
  final int userId;
  final bool isFollowers;

  const _FollowListSheet({
    required this.title,
    required this.userId,
    required this.isFollowers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = isFollowers
        ? ref.watch(userFollowersProvider(userId))
        : ref.watch(userFollowingProvider(userId));
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Expanded(
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppErrorHandler.getErrorMessage(error),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ),
                data: (response) {
                  final l = AppLocalizations.of(context);
                  if (response.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isFollowers
                                ? (l?.profile_no_followers_yet ?? "Hali obunachilar yo'q")
                                : (l?.profile_no_following_yet ?? "Hali obunalar yo'q"),
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: response.results.length,
                    itemBuilder: (context, index) {
                      final user = response.results[index];
                      return _FollowUserTile(user: user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowUserTile extends ConsumerStatefulWidget {
  final FollowUser user;

  const _FollowUserTile({required this.user});

  @override
  ConsumerState<_FollowUserTile> createState() => _FollowUserTileState();
}

class _FollowUserTileState extends ConsumerState<_FollowUserTile> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final profileService = ref.read(profileServiceProvider);
      if (_isFollowing) {
        await profileService.unfollowUser(userId: widget.user.id);
      } else {
        await profileService.followUser(userId: widget.user.id);
      }
      setState(() => _isFollowing = !_isFollowing);
    } catch (e) {
      if (mounted) AppErrorHandler.showError(context, e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        context.push('/user/${widget.user.id}');
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.primaryContainer,
        child: widget.user.profileImage.image.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImageWidget(
                  imageUrl: widget.user.profileImage.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                widget.user.initials,
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
              ),
      ),
      title: Text(widget.user.username, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: _isLoading
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Builder(
              builder: (context) {
                final l = AppLocalizations.of(context);
                return SizedBox(
                  width: 100,
                  child: _isFollowing
                      ? OutlinedButton(
                          onPressed: _toggleFollow,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                            side: BorderSide(color: colorScheme.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(l?.profile_following_btn ?? 'Obuna', style: const TextStyle(fontSize: 13)),
                        )
                      : FilledButton(
                          onPressed: _toggleFollow,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text(l?.profile_follow ?? "Obuna bo'lish", style: const TextStyle(fontSize: 13)),
                        ),
                );
              },
            ),
    );
  }
}
