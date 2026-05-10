import 'package:app/providers/provider_root/locale_provider.dart';
import 'package:app/widgets/branding/tezsell_wordmark.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Show splash screen for at least 2 seconds
    final splashTimer = Future.delayed(const Duration(seconds: 2));

    // Check authentication in parallel
    final authCheck = _checkAuthentication();

    // Wait for both to complete
    await Future.wait([splashTimer, authCheck]);

    if (!mounted) return;

    // Navigate based on authentication status
    final authService = ref.read(authenticationServiceProvider);
    final isLoggedIn = await authService.isLoggedIn();

    if (isLoggedIn) {
      AppLogger.info('User is logged in, navigating to main app');
      if (context.mounted) {
        context.go('/tabs');
      }
    } else {
      // Skip the manual /language picker if the device locale is already one
      // of our 15 supported locales OR the user has previously made a manual
      // override — both cases mean the localeProvider is already correct.
      // The user can still change language later from profile.
      final hasManual =
          await ref.read(localeProvider.notifier).hasManualOverride();
      final detected = ref.read(localeProvider);
      final detectedSupported =
          detected != null && supportedLocaleCodes.contains(detected.languageCode);

      if (context.mounted) {
        if (hasManual || detectedSupported) {
          AppLogger.info(
              'Locale resolved (${detected?.languageCode}) — skipping language picker');
          context.go('/welcome');
        } else {
          AppLogger.info('Locale not auto-resolvable — showing language picker');
          context.go('/language');
        }
      }
    }
  }

  Future<void> _checkAuthentication() async {
    try {
      final authService = ref.read(authenticationServiceProvider);

      final hasAccessToken = await authService.getStoredToken() != null;
      final hasRefreshToken = await authService.getStoredRefreshToken() != null;

      if (hasAccessToken || hasRefreshToken) {
        AppLogger.info('Found stored tokens, verifying/refreshing...');

        final isValid = await authService.verifyToken();

        if (!isValid && hasRefreshToken) {
          AppLogger.info('Access token invalid, attempting refresh...');
          final newToken = await authService.refreshToken();

          if (newToken != null) {
            AppLogger.info('Token refreshed successfully');
            _startTokenRefreshService(authService);
          } else {
            AppLogger.warning('Token refresh failed, user will need to login');
            await authService.logout();
          }
        } else if (isValid) {
          AppLogger.info('Access token is valid');
          if (hasRefreshToken) {
            _startTokenRefreshService(authService);
          }
        }
      } else {
        AppLogger.info('No stored tokens found');
      }
    } catch (e) {
      AppLogger.error('Error checking authentication: $e');
    }
  }

  void _startTokenRefreshService(AuthenticationService authService) {
    try {
      final tokenRefreshService = TokenRefreshService(authService);
      tokenRefreshService.start();
      AppLogger.info('Token refresh service started');
    } catch (e) {
      AppLogger.error('Error starting token refresh service: $e');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [colorScheme.surface, colorScheme.surface]
                : [colorScheme.surface, colorScheme.surfaceVariant.withOpacity(0.3)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated Logo Section
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary
                                  .withValues(alpha: isDark ? 0.25 : 0.18),
                              blurRadius: 60,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: TezSellWordmark(
                          size: TezSellWordmarkSize.large,
                          showTagline: true,
                          tagline:
                              AppLocalizations.of(context)?.home_welcome_title ??
                                  'Your neighborhood marketplace',
                        ),
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Loading indicator
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          AppLocalizations.of(context)?.loading ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }
}
