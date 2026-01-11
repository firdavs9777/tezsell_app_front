import 'package:app/service/authentication_service.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/utils/app_logger.dart';
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
      AppLogger.info('User is not logged in, navigating to language selection');
      if (context.mounted) {
        context.go('/language');
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
                      child: Column(
                        children: [
                          // Logo with glow effect
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(isDark ? 0.3 : 0.25),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(70),
                              child: Image.asset(
                                'assets/logo/logo.png',
                                width: 140,
                                height: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 140,
                                    height: 140,
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
                                      size: 64,
                                      color: colorScheme.onPrimary,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),

                          // App Name
                          Text(
                            'Tezsell',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Tagline
                          Text(
                            'Your neighborhood marketplace',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
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
                          'Loading...',
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
