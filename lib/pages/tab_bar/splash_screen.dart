import 'package:app/pages/language/language_selection.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
      // User is logged in - go to main app
      AppLogger.info('User is logged in, navigating to main app');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const TabsScreen(),
        ),
      );
    } else {
      // User is not logged in - go to language selection
      AppLogger.info('User is not logged in, navigating to language selection');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LanguageSelectionScreen(),
        ),
      );
    }
  }

  /// Check authentication and refresh token if needed
  Future<void> _checkAuthentication() async {
    try {
      final authService = ref.read(authenticationServiceProvider);
      
      // Check if user has tokens
      final hasAccessToken = await authService.getStoredToken() != null;
      final hasRefreshToken = await authService.getStoredRefreshToken() != null;

      if (hasAccessToken || hasRefreshToken) {
        AppLogger.info('Found stored tokens, verifying/refreshing...');

        // First, try to verify the current access token
        final isValid = await authService.verifyToken();

        if (!isValid && hasRefreshToken) {
          // Access token is invalid, try to refresh
          AppLogger.info('Access token invalid, attempting refresh...');
          final newToken = await authService.refreshToken();
          
          if (newToken != null) {
            AppLogger.info('Token refreshed successfully');
            // Start automatic token refresh service
            _startTokenRefreshService(authService);
          } else {
            AppLogger.warning('Token refresh failed, user will need to login');
            // Clear invalid tokens
            await authService.logout();
          }
        } else if (isValid) {
          AppLogger.info('Access token is valid');
          // Only start token refresh service if refresh token exists
          if (hasRefreshToken) {
            _startTokenRefreshService(authService);
          } else {
            AppLogger.info('No refresh token found - user has old token. Will get refresh token on next login.');
          }
        }
      } else {
        AppLogger.info('No stored tokens found');
      }
    } catch (e) {
      AppLogger.error('Error checking authentication: $e');
      // On error, assume user is not logged in
    }
  }

  /// Start the automatic token refresh service
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
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfdf8e4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(50), // Adjust radius as needed
              child: Image.asset(
                'assets/logo/logo.png',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.apps,
                    size: 150,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Optional: Add loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
