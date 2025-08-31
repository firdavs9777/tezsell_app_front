import 'package:app/constants/constants.dart';
import 'package:app/pages/shaxsiy/favorite_items/favorite_products.dart';
import 'package:app/pages/shaxsiy/favorite_items/favorite_services.dart';
import 'package:app/pages/shaxsiy/my-products/my_products.dart';
import 'package:app/pages/shaxsiy/my-services/my_services.dart';
import 'package:app/pages/shaxsiy/main_profile/profile_edit.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:app/providers/provider_root/theme_provider.dart'; // Import the proper theme provider
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Remove this from ShaxsiyPage and create a separate file instead
// This is just a placeholder - you need to create the proper theme provider file

class ShaxsiyPage extends ConsumerStatefulWidget {
  const ShaxsiyPage({super.key});

  @override
  _ShaxsiyPageState createState() => _ShaxsiyPageState();
}

class _ShaxsiyPageState extends ConsumerState<ShaxsiyPage> {
  late Future<UserInfo> _userInfoFuture;

  // Define supported languages - matching your LanguageSelectionScreen
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸'},
    {'code': 'ru', 'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    {'code': 'uz', 'name': 'Uzbek', 'nativeName': 'O\'zbekcha', 'flag': '🇺🇿'},
  ];

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo();
  }

  Future<UserInfo> fetchUserInfo() async {
    return await ref.read(profileServiceProvider).getUserInfo();
  }

  void _refreshProfile() {
    setState(() {
      _userInfoFuture = fetchUserInfo();
    });
  }

  ImageProvider? _getProfileImage(UserInfo user) {
    if (user.profileImage?.image != null &&
        user.profileImage!.image.isNotEmpty) {
      final imageUrl = user.profileImage!.image.startsWith('http')
          ? user.profileImage!.image
          : "$baseUrl${user.profileImage!.image}";
      return NetworkImage(imageUrl);
    }
    return null;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildProfileCard(UserInfo user, AppLocalizations? localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
          );
          if (result == true) {
            _refreshProfile();
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF6F00).withOpacity(0.1),
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFFF5F5F5),
                backgroundImage: _getProfileImage(user),
                child: _getProfileImage(user) == null
                    ? const Icon(
                        Icons.person_rounded,
                        color: Color(0xFF9E9E9E),
                        size: 32,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizations?.my_name ?? 'My Profile',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color:
                      (iconColor ?? const Color(0xFFFF6F00)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? const Color(0xFFFF6F00),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Language Dialog with your supported languages
  void _showLanguageDialog(
      BuildContext context, AppLocalizations? localizations) {
    final currentLocale = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localizations?.selectLanguage ?? 'Select Language',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
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

  Widget _buildLanguageOption(
      String language, String code, String flag, bool isSelected) {
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
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Theme Dialog
  void _showThemeDialog(BuildContext context, AppLocalizations? localizations) {
    final currentTheme = ref.read(themeProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                localizations?.select_theme ?? 'Select Theme',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                  localizations?.light_theme ?? 'Light',
                  Icons.light_mode,
                  ThemeMode.light,
                  currentTheme == ThemeMode.light),
              _buildThemeOption(
                  localizations?.dark_theme ?? 'Dark',
                  Icons.dark_mode,
                  ThemeMode.dark,
                  currentTheme == ThemeMode.dark),
              _buildThemeOption(
                  localizations?.system_theme ?? 'System Default',
                  Icons.settings_brightness,
                  ThemeMode.system,
                  currentTheme == ThemeMode.system),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
      String theme, IconData icon, ThemeMode themeMode, bool isSelected) {
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
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary)
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF607D8B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF607D8B),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                theme,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
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
            const Icon(Icons.check_circle_outline,
                color: Colors.white, size: 20),
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          ref.watch(profileServiceProvider).getUserInfo(),
          ref.watch(profileServiceProvider).getUserProducts(),
          ref.watch(profileServiceProvider).getUserServices(),
          ref.watch(profileServiceProvider).getUserFavoriteItems(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6F00)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: Color(0xFFE57373),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No user data available.',
                style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  fontSize: 16,
                ),
              ),
            );
          }

          final user = snapshot.data![0] as UserInfo;
          final products = snapshot.data![1] as List<Products>;
          final services = snapshot.data![2] as List<Services>;
          final favoriteItems = snapshot.data![3] as FavoriteItems;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Profile Section
                _buildSectionTitle(localizations?.about_me ?? 'About Me'),
                _buildProfileCard(user, localizations),

                // My Items Section
                _buildSectionTitle(localizations?.myProfile ?? 'My Items'),

                _buildMenuCard(
                  icon: Icons.inventory_2_rounded,
                  title: localizations?.myProductsTitle ?? 'My Products',
                  subtitle: '${products.length} items',
                  iconColor: const Color(0xFF4CAF50),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyProducts()),
                  ),
                ),

                _buildMenuCard(
                  icon: Icons.room_service_rounded,
                  title: localizations?.myServicesTitle ?? 'My Services',
                  subtitle: '${services.length} services',
                  iconColor: const Color(0xFF2196F3),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyServices()),
                  ),
                ),

                const SizedBox(height: 8),

                _buildMenuCard(
                  icon: Icons.favorite_rounded,
                  title: localizations?.favoriteProductsTitle ??
                      'Favorite Products',
                  subtitle: '${favoriteItems.likedProducts.length} items',
                  iconColor: const Color(0xFFE91E63),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteProducts(
                            products: favoriteItems.likedProducts)),
                  ),
                ),

                _buildMenuCard(
                  icon: Icons.star_rounded,
                  title: localizations?.favoriteServicesTitle ??
                      'Favorite Services',
                  subtitle: '${favoriteItems.likedServices.length} services',
                  iconColor: const Color(0xFFFF9800),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteServices(
                            services: favoriteItems.likedServices)),
                  ),
                ),

                // Settings Section
                _buildSectionTitle(localizations?.settings ?? 'Settings'),

                // Language Settings with current language display
                _buildMenuCard(
                  icon: Icons.language_rounded,
                  title: localizations?.language ?? 'Language',
                  subtitle: _getCurrentLanguageName(),
                  iconColor: const Color(0xFF2196F3),
                  onTap: () {
                    _showLanguageDialog(context, localizations);
                  },
                ),

                // Theme Settings with current theme display
                _buildMenuCard(
                  icon: Icons.palette_rounded,
                  title: localizations?.theme ?? 'Theme',
                  subtitle: _getCurrentThemeName(localizations),
                  iconColor: const Color(0xFF607D8B),
                  onTap: () {
                    _showThemeDialog(context, localizations);
                  },
                ),

                // Other Settings (keeping your existing ones)
                _buildMenuCard(
                  icon: Icons.notifications_rounded,
                  title: localizations?.notifications ?? 'Notifications',
                  subtitle: 'Push, email, and SMS preferences',
                  iconColor: const Color(0xFFFF9800),
                  onTap: () {
                    _showSuccess('Opening notification settings...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.privacy_tip_rounded,
                  title: localizations?.privacy ?? 'Privacy',
                  subtitle: 'Profile visibility and data control',
                  iconColor: const Color(0xFF9C27B0),
                  onTap: () {
                    _showSuccess('Opening privacy settings...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.my_location_rounded,
                  title: localizations?.location_settings ?? 'Location',
                  subtitle: 'Default area and location services',
                  iconColor: const Color(0xFF4CAF50),
                  onTap: () {
                    _showSuccess('Opening location settings...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.security_rounded,
                  title: localizations?.security ?? 'Security',
                  subtitle: 'Password, 2FA, and login history',
                  iconColor: const Color(0xFFE91E63),
                  onTap: () {
                    _showSuccess('Opening security settings...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.storage_rounded,
                  title: localizations?.data_storage ?? 'Data & Storage',
                  subtitle: 'Cache, downloads, and storage usage',
                  iconColor: const Color(0xFF795548),
                  onTap: () {
                    _showSuccess('Opening data & storage settings...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.accessibility_rounded,
                  title: localizations?.accessibility ?? 'Accessibility',
                  subtitle: 'Font size, contrast, and voice settings',
                  iconColor: const Color(0xFF00BCD4),
                  onTap: () {
                    _showSuccess('Opening accessibility settings...');
                  },
                ),

                // Support Section
                _buildSectionTitle(
                    localizations?.customer_support ?? 'Support'),

                _buildMenuCard(
                  icon: Icons.headset_mic_rounded,
                  title: localizations?.customer_center ?? 'Customer Center',
                  subtitle: 'Get help and support',
                  iconColor: const Color(0xFF9C27B0),
                  onTap: () {
                    _showSuccess('Opening customer center...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.help_outline_rounded,
                  title: localizations?.customer_inquiries ?? 'Inquiries',
                  subtitle: 'Ask questions or report issues',
                  iconColor: const Color(0xFF607D8B),
                  onTap: () {
                    _showSuccess('Opening inquiries...');
                  },
                ),

                _buildMenuCard(
                  icon: Icons.article_rounded,
                  title:
                      localizations?.customer_terms ?? 'Terms and Conditions',
                  subtitle: 'Privacy policy and terms',
                  iconColor: const Color(0xFF795548),
                  onTap: () {
                    _showSuccess('Opening terms and conditions...');
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
