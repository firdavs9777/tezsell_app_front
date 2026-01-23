import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/providers/provider_root/social_auth_provider.dart';
import 'package:app/providers/provider_models/social_auth_model.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/l10n/app_localizations.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  // Apple credential cache keys
  static const String _appleEmailKey = 'apple_cached_email';
  static const String _appleNameKey = 'apple_cached_name';

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _startTokenRefreshService() {
    try {
      final authService = ref.read(authenticationServiceProvider);
      final tokenRefreshService = TokenRefreshService(authService);
      tokenRefreshService.start();
    } catch (e) {
      if (kDebugMode) print('Error starting token refresh: $e');
    }
  }

  Future<void> _cacheAppleCredentials(String? email, String? name) async {
    if (email == null && name == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (email != null && email.isNotEmpty) {
        await prefs.setString(_appleEmailKey, email);
      }
      if (name != null && name.isNotEmpty) {
        await prefs.setString(_appleNameKey, name);
      }
    } catch (e) {
      if (kDebugMode) print('Error caching Apple credentials: $e');
    }
  }

  Future<Map<String, String?>> _getCachedAppleCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'email': prefs.getString(_appleEmailKey),
        'name': prefs.getString(_appleNameKey),
      };
    } catch (e) {
      return {'email': null, 'name': null};
    }
  }

  void _handleSocialAuthSuccess(SocialAuthResponse response) {
    _startTokenRefreshService();
    final needsLocationSetup = response.isNewUser || response.userInfo?.needsLocationSetup == true;
    if (context.mounted) {
      context.go(needsLocationSetup ? '/location-setup' : '/tabs');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading || _isAppleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() => _isGoogleLoading = false);
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final photoUrl = googleUser.photoUrl;

      if (idToken == null) {
        _showError('Failed to get Google authentication token');
        setState(() => _isGoogleLoading = false);
        return;
      }

      final socialAuthNotifier = ref.read(socialAuthProvider.notifier);
      final response = await socialAuthNotifier.loginWithGoogle(idToken, photoUrl: photoUrl);

      if (!mounted) return;

      if (response.success) {
        _handleSocialAuthSuccess(response);
      } else {
        _showError(response.error ?? 'Google sign-in failed');
      }
    } catch (e) {
      if (kDebugMode) print('Google Sign-In error: $e');
      if (mounted) _showError('Google sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isAppleLoading || _isGoogleLoading) return;
    setState(() => _isAppleLoading = true);

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        _showError('Failed to get Apple authentication token');
        setState(() => _isAppleLoading = false);
        return;
      }

      String? userEmail = credential.email;
      String? userName;
      if (credential.givenName != null || credential.familyName != null) {
        userName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
        if (userName.isEmpty) userName = null;
      }

      if (userEmail != null || userName != null) {
        await _cacheAppleCredentials(userEmail, userName);
      } else {
        final cached = await _getCachedAppleCredentials();
        userEmail = cached['email'];
        userName = cached['name'];
      }

      final socialAuthNotifier = ref.read(socialAuthProvider.notifier);
      final response = await socialAuthNotifier.loginWithApple(
        idToken: idToken,
        userEmail: userEmail,
        userName: userName,
      );

      if (!mounted) return;

      if (response.success) {
        _handleSocialAuthSuccess(response);
      } else {
        _showError(response.error ?? 'Apple sign-in failed');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled && mounted) {
        _showError('Apple sign-in failed. Please try again.');
      }
    } catch (e) {
      if (kDebugMode) print('Apple Sign-In error: $e');
      if (mounted) _showError('Apple sign-in failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isAppleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              ClipRRect(
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
                        color: colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.store_rounded,
                        size: 60,
                        color: colorScheme.primary,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Welcome text
              Text(
                localizations?.welcome ?? 'Welcome to TezSell',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                localizations?.home_welcome_subtitle ?? 'Buy and sell with people nearby.\nSafe, simple, and local.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      height: 1.4,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),

              // Google Sign-In Button
              _buildSocialButton(
                onPressed: !_isGoogleLoading && !_isAppleLoading ? _handleGoogleSignIn : null,
                isLoading: _isGoogleLoading,
                icon: Image.asset(
                  'assets/icons/google.png',
                  width: 24,
                  height: 24,
                  errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24, color: Colors.red),
                ),
                label: 'Continue with Google',
              ),
              const SizedBox(height: 12),

              // Apple Sign-In Button (iOS only)
              if (Platform.isIOS) ...[
                _buildSocialButton(
                  onPressed: !_isGoogleLoading && !_isAppleLoading ? _handleAppleSignIn : null,
                  isLoading: _isAppleLoading,
                  icon: Icon(
                    Icons.apple,
                    size: 24,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  label: 'Continue with Apple',
                  isApple: true,
                ),
                const SizedBox(height: 16),
              ],

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: colorScheme.outlineVariant)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      localizations?.or ?? 'OR',
                      style: TextStyle(
                        color: colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: colorScheme.outlineVariant)),
                ],
              ),
              const SizedBox(height: 16),

              // Continue with Email Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: !_isGoogleLoading && !_isAppleLoading
                      ? () => context.go('/login')
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor: colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue with Email',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required Widget icon,
    required String label,
    bool isApple = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isApple
              ? (isDark ? Colors.white : Colors.black)
              : colorScheme.surface,
          foregroundColor: isApple
              ? (isDark ? Colors.black : Colors.white)
              : colorScheme.onSurface,
          side: BorderSide(
            color: colorScheme.outline.withOpacity(0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isApple
                        ? (isDark ? Colors.black : Colors.white)
                        : colorScheme.primary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isApple
                          ? (isDark ? Colors.black : Colors.white)
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
