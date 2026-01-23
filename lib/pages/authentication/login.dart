import 'dart:io';
import 'package:app/pages/authentication/forget_password.dart';
import 'package:app/pages/authentication/register.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/providers/provider_root/social_auth_provider.dart';
import 'package:app/providers/provider_models/social_auth_model.dart';
import 'package:app/utils/app_logger.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AuthenticationService _authService;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  // Apple credential cache keys
  static const String _appleEmailKey = 'apple_cached_email';
  static const String _appleNameKey = 'apple_cached_name';

  // Performance tracking variables
  final Stopwatch _totalLoginTime = Stopwatch();
  final Map<String, int> _performanceMetrics = {};
  DateTime? _loginStartTime;

  @override
  void initState() {
    super.initState();

    // Track initialization time
    final initTimer = Stopwatch()..start();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = ref.read(authenticationServiceProvider);

    initTimer.stop();
    _logPerformance('Widget Initialization', initTimer.elapsed.inMilliseconds);
  }

  @override
  void dispose() {
    // Print performance summary before disposing
    _printPerformanceSummary();

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Log performance metrics with color-coded output
  void _logPerformance(String operation, int milliseconds) {
    _performanceMetrics[operation] = milliseconds;

    // Color coding based on performance
    String emoji;
    if (milliseconds < 50)
      emoji = '🟢'; // Fast
    else if (milliseconds < 200)
      emoji = '🟡'; // Medium
    else if (milliseconds < 500)
      emoji = '🟠'; // Slow
    else
      emoji = '🔴'; // Very slow

    if (kDebugMode) {
    }
  }

  /// Print comprehensive performance summary
  void _printPerformanceSummary() {
    if (!kDebugMode) return;

    int totalTime = 0;
    _performanceMetrics.forEach((operation, time) {
      totalTime += time;
      final emoji = time < 50
          ? '🟢'
          : time < 200
              ? '🟡'
              : time < 500
                  ? '🟠'
                  : '🔴';
    });

    // Performance analysis
    final networkTime = _performanceMetrics['Network Request'] ?? 0;
    final uiTime = totalTime - networkTime;

    // Performance rating
    String rating;
    if (totalTime < 1000)
      rating = '🟢 Excellent';
    else if (totalTime < 2000)
      rating = '🟡 Good';
    else if (totalTime < 3000)
      rating = '🟠 Fair';
    else
      rating = '🔴 Needs Optimization';

  }

  Future<void> _handleLogin() async {
    // Prevent multiple simultaneous login attempts
    if (_isLoading) return;

    // Start total timing
    _totalLoginTime.reset();
    _totalLoginTime.start();
    _loginStartTime = DateTime.now();

    // Start Flutter DevTools timeline event
    developer.Timeline.startSync('Login Process');

    try {
      // Validation timing
      final validationTimer = Stopwatch()..start();

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _showError('Please enter your email');
        return;
      }

      // Basic email validation
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _showError('Please enter a valid email address');
        return;
      }

      if (_passwordController.text.trim().isEmpty) {
        _showError(AppLocalizations.of(context)?.pleaseEnterPassword ??
            'Please enter your password');
        return;
      }

      validationTimer.stop();
      _logPerformance(
          'Input Validation', validationTimer.elapsed.inMilliseconds);

      // UI state update timing
      final uiUpdateTimer = Stopwatch()..start();
      setState(() {
        _isLoading = true;
      });
      uiUpdateTimer.stop();
      _logPerformance('UI State Update', uiUpdateTimer.elapsed.inMilliseconds);

      // Data preparation timing
      final dataTimer = Stopwatch()..start();
      final String password = _passwordController.text.trim();
      dataTimer.stop();
      _logPerformance('Data Preparation', dataTimer.elapsed.inMilliseconds);

      if (kDebugMode) {
      }

      // Network request timing (this is usually the bottleneck)
      final networkTimer = Stopwatch()..start();
      final result = await _authService.login(context, email, password);
      networkTimer.stop();
      _logPerformance('Network Request', networkTimer.elapsed.inMilliseconds);

      if (kDebugMode) {
      }

      if (!mounted) return; // Check if widget is still mounted

      // Navigation timing
      if (result != null) {
        final navigationTimer = Stopwatch()..start();

        // Start automatic token refresh service
        _startTokenRefreshService();

        // Login successful - navigate to tabs
        if (context.mounted) {
          context.go('/tabs');
        }

        navigationTimer.stop();
        _logPerformance('Navigation', navigationTimer.elapsed.inMilliseconds);

        if (kDebugMode) {
        }
      } else {
        // Login failed - error already shown by AuthenticationService
        if (kDebugMode) {
        }
      }
    } catch (e) {
      if (kDebugMode) {
      }
      if (mounted) {
        _showError(AppLocalizations.of(context)?.unexpectedError ??
            'An unexpected error occurred. Please try again.');
      }
    } finally {
      // Stop total timing
      _totalLoginTime.stop();
      _logPerformance(
          'TOTAL LOGIN TIME', _totalLoginTime.elapsed.inMilliseconds);

      // End Flutter DevTools timeline event
      developer.Timeline.finishSync();

      // UI update timing
      if (mounted) {
        final finalUpdateTimer = Stopwatch()..start();
        setState(() {
          _isLoading = false;
        });
        finalUpdateTimer.stop();
        _logPerformance(
            'Final UI Update', finalUpdateTimer.elapsed.inMilliseconds);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  /// Start the automatic token refresh service
  void _startTokenRefreshService() {
    try {
      final tokenRefreshService = TokenRefreshService(_authService);
      tokenRefreshService.start();
      AppLogger.info('Token refresh service started after login');
    } catch (e) {
      AppLogger.error('Error starting token refresh service: $e');
    }
  }

  /// Cache Apple credentials for subsequent logins
  Future<void> _cacheAppleCredentials(String? email, String? name) async {
    if (email == null && name == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      if (email != null && email.isNotEmpty) {
        await prefs.setString(_appleEmailKey, email);
        if (kDebugMode) {
          print('🍎 Cached Apple email: $email');
        }
      }
      if (name != null && name.isNotEmpty) {
        await prefs.setString(_appleNameKey, name);
        if (kDebugMode) {
          print('🍎 Cached Apple name: $name');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error caching Apple credentials: $e');
      }
    }
  }

  /// Get cached Apple credentials for subsequent logins
  Future<Map<String, String?>> _getCachedAppleCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'email': prefs.getString(_appleEmailKey),
        'name': prefs.getString(_appleNameKey),
      };
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting cached Apple credentials: $e');
      }
      return {'email': null, 'name': null};
    }
  }

  /// Navigate after successful social auth, checking if location setup is needed
  void _handleSocialAuthSuccess(SocialAuthResponse response) {
    // Start token refresh service
    _startTokenRefreshService();

    // Check if user needs to set up location
    final needsLocationSetup = response.isNewUser ||
        response.userInfo?.needsLocationSetup == true;

    if (kDebugMode) {
      print('📍 Social auth navigation check:');
      print('   isNewUser: ${response.isNewUser}');
      print('   needsLocationSetup: ${response.userInfo?.needsLocationSetup}');
      print('   navigating to: ${needsLocationSetup ? "/location-setup" : "/tabs"}');
    }

    if (context.mounted) {
      if (needsLocationSetup) {
        // Navigate to location setup for new users or users without location
        context.go('/location-setup');
      } else {
        // Navigate to home for existing users with location
        context.go('/tabs');
      }
    }
  }

  /// Handle Google Sign-In
  Future<void> _handleGoogleSignIn() async {
    if (_isGoogleLoading || _isLoading) return;

    setState(() {
      _isGoogleLoading = true;
    });

    try {
      // Sign out first to ensure fresh login
      await _googleSignIn.signOut();

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        if (mounted) {
          setState(() {
            _isGoogleLoading = false;
          });
        }
        return;
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        _showError('Failed to get Google authentication token');
        if (mounted) {
          setState(() {
            _isGoogleLoading = false;
          });
        }
        return;
      }

      if (kDebugMode) {
        print('🔐 Google Sign-In successful');
        print('   Email: ${googleUser.email}');
        print('   Name: ${googleUser.displayName}');
      }

      // Send idToken to backend via social auth provider
      final socialAuthNotifier = ref.read(socialAuthProvider.notifier);
      final response = await socialAuthNotifier.loginWithGoogle(idToken);

      if (!mounted) return;

      if (response.success) {
        _handleSocialAuthSuccess(response);
      } else {
        _showError(response.error ?? 'Google sign-in failed');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Google Sign-In error: $e');
      }
      if (mounted) {
        _showError('Google sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  /// Handle Apple Sign-In
  Future<void> _handleAppleSignIn() async {
    if (_isAppleLoading || _isLoading) return;

    setState(() {
      _isAppleLoading = true;
    });

    try {
      // Request Apple ID credential
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final String? idToken = credential.identityToken;

      if (idToken == null) {
        _showError('Failed to get Apple authentication token');
        if (mounted) {
          setState(() {
            _isAppleLoading = false;
          });
        }
        return;
      }

      // Get user info (only available on first sign-in)
      String? userEmail = credential.email;
      String? userName;
      if (credential.givenName != null || credential.familyName != null) {
        userName = '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim();
        if (userName.isEmpty) userName = null;
      }

      // Apple only provides email/name on FIRST sign-in
      // Cache them for subsequent logins
      if (userEmail != null || userName != null) {
        await _cacheAppleCredentials(userEmail, userName);
      } else {
        // Try to get cached credentials for subsequent logins
        final cached = await _getCachedAppleCredentials();
        userEmail = cached['email'];
        userName = cached['name'];
        if (kDebugMode) {
          print('🍎 Using cached Apple credentials:');
          print('   Cached email: $userEmail');
          print('   Cached name: $userName');
        }
      }

      if (kDebugMode) {
        print('🍎 Apple Sign-In successful');
        print('   Email: $userEmail');
        print('   Name: $userName');
      }

      // Send idToken to backend via social auth provider
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
      if (kDebugMode) {
        print('🍎 Apple Sign-In cancelled or failed: ${e.code}');
      }
      // Don't show error for user cancellation
      if (e.code != AuthorizationErrorCode.canceled) {
        if (mounted) {
          _showError('Apple sign-in failed. Please try again.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Apple Sign-In error: $e');
      }
      if (mounted) {
        _showError('Apple sign-in failed. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buildTimer = Stopwatch()..start();

    final widget = Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40.0),

                // Logo with Karrot-style circular background
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/logo.png',
                      fit: BoxFit.cover,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),

                const SizedBox(height: 32.0),

                // Welcome text - Karrot style
                Text(
                  AppLocalizations.of(context)?.welcomeBack ?? 'Welcome back!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                ),

                const SizedBox(height: 8.0),

                Text(
                  AppLocalizations.of(context)?.loginToYourAccount ??
                      'Login to continue',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),

                const SizedBox(height: 40.0),

                // Email input - Karrot style
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    hintText: 'Email address',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  enabled: !_isLoading,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    hintText:
                        AppLocalizations.of(context)?.password ?? 'Password',
                    hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: _isLoading
                            ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                            : Theme.of(context).textTheme.bodySmall?.color,
                        size: 22,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                    ),
                  ),
                ),

                const SizedBox(height: 12.0),

                // Forgot password - aligned right
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage()),
                            );
                          },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppLocalizations.of(context)?.forgotPassword ??
                          'Forgot password?',
                      style: TextStyle(
                        color: _isLoading
                            ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.4)
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24.0),

                // Login button - Karrot orange style
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _isLoading
                        ? []
                        : Theme.of(context).brightness == Brightness.dark
                            ? []
                            : [
                                BoxShadow(
                                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2)
                          : Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                AppLocalizations.of(context)?.loading ??
                                    'Loading...',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            AppLocalizations.of(context)?.login ?? 'Login',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 32.0),

                // Divider with text
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)?.or ?? 'OR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Theme.of(context).colorScheme.outlineVariant,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24.0),

                // Google Sign-In Button
                _buildSocialButton(
                  onPressed: _isLoading || _isGoogleLoading || _isAppleLoading
                      ? null
                      : _handleGoogleSignIn,
                  isLoading: _isGoogleLoading,
                  icon: Image.asset(
                    'assets/icons/google.png',
                    width: 24,
                    height: 24,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                  label: 'Continue with Google',
                ),

                const SizedBox(height: 12.0),

                // Apple Sign-In Button (iOS only)
                if (Platform.isIOS) ...[
                  _buildSocialButton(
                    onPressed: _isLoading || _isGoogleLoading || _isAppleLoading
                        ? null
                        : _handleAppleSignIn,
                    isLoading: _isAppleLoading,
                    icon: Icon(
                      Icons.apple,
                      size: 24,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    label: 'Continue with Apple',
                    isApple: true,
                  ),
                  const SizedBox(height: 24.0),
                ] else ...[
                  const SizedBox(height: 12.0),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.dontHaveAccount ??
                          "Don't have an account?",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading || _isGoogleLoading || _isAppleLoading
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Register(),
                                ),
                              );
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.registerNow ?? 'Sign up',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _isLoading || _isGoogleLoading || _isAppleLoading
                              ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4)
                              : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );

    buildTimer.stop();

    // Only log significant build times
    if (buildTimer.elapsed.inMilliseconds > 5) {
      _logPerformance('Widget Build', buildTimer.elapsed.inMilliseconds);
    }

    return widget;
  }

  /// Build social sign-in button
  Widget _buildSocialButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required Widget icon,
    required String label,
    bool isApple = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isApple
              ? (isDark ? Colors.white : Colors.black)
              : Theme.of(context).colorScheme.surface,
          foregroundColor: isApple
              ? (isDark ? Colors.black : Colors.white)
              : Theme.of(context).colorScheme.onSurface,
          elevation: 0,
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
                        : Theme.of(context).colorScheme.primary,
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
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isApple
                          ? (isDark ? Colors.black : Colors.white)
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
