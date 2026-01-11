import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/authentication/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/locale_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Top bar with language selector
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildLanguageSelector(context, ref, currentLocale, colorScheme, isDark),
                  ],
                ),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 1),

                      // Logo section
                      _buildLogo(context, colorScheme),
                      const SizedBox(height: 32),

                      // Welcome text
                      _buildWelcomeText(context, colorScheme),
                      const SizedBox(height: 12),

                      // Subtitle
                      _buildSubtitle(context, colorScheme),

                      const Spacer(flex: 2),

                      // Buttons
                      _buildButtons(context, colorScheme, isDark),
                      const SizedBox(height: 32),

                      // Terms text
                      _buildTermsText(context, colorScheme),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, WidgetRef ref, Locale? currentLocale, ColorScheme colorScheme, bool isDark) {
    final locale = currentLocale ?? const Locale('en');
    final languages = [
      {'code': 'en', 'flag': '🇺🇸', 'name': 'EN'},
      {'code': 'ru', 'flag': '🇷🇺', 'name': 'RU'},
      {'code': 'uz', 'flag': '🇺🇿', 'name': 'UZ'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: PopupMenuButton<String>(
        onSelected: (String languageCode) {
          HapticFeedback.selectionClick();
          ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
        },
        offset: const Offset(0, 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: colorScheme.surface,
        itemBuilder: (BuildContext context) => languages.map((lang) {
          final isSelected = locale.languageCode == lang['code'];
          return PopupMenuItem(
            value: lang['code'] as String,
            child: Row(
              children: [
                Text(lang['flag'] as String, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 12),
                Text(
                  lang['code'] == 'en' ? 'English' : lang['code'] == 'ru' ? 'Русский' : "O'zbekcha",
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Icon(Icons.check, size: 18, color: colorScheme.primary),
                ],
              ],
            ),
          );
        }).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              languages.firstWhere((l) => l['code'] == locale.languageCode, orElse: () => languages[0])['flag'] as String,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 6),
            Text(
              languages.firstWhere((l) => l['code'] == locale.languageCode, orElse: () => languages[0])['name'] as String,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        // Logo with subtle shadow
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.asset(
              'assets/logo/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primary, colorScheme.primary.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.storefront_rounded,
                    size: 56,
                    color: colorScheme.onPrimary,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        // App name
        Text(
          'Tezsell',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeText(BuildContext context, ColorScheme colorScheme) {
    final l = AppLocalizations.of(context);
    return Text(
      l?.home_welcome_title ?? 'Your neighborhood marketplace',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: colorScheme.onSurface,
        height: 1.3,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context, ColorScheme colorScheme) {
    final l = AppLocalizations.of(context);
    return Text(
      l?.home_welcome_subtitle ?? 'Buy and sell with people nearby.\nSafe, simple, and local.',
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colorScheme.onSurfaceVariant,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildButtons(BuildContext context, ColorScheme colorScheme, bool isDark) {
    final l = AppLocalizations.of(context);

    return Column(
      children: [
        // Get Started / Register button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Register()),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Text(
              l?.home_get_started ?? 'Get Started',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Login button
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
              side: BorderSide(color: colorScheme.outline, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              l?.home_sign_in ?? 'I already have an account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText(BuildContext context, ColorScheme colorScheme) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        l?.home_terms_notice ?? 'By continuing, you agree to our Terms of Service and Privacy Policy',
        style: TextStyle(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant.withOpacity(0.7),
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
