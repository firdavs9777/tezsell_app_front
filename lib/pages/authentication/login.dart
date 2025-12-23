import 'package:app/pages/authentication/forget_password.dart';
import 'package:app/pages/authentication/register.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:app/service/token_refresh_service.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/terms_acceptance_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
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

        // Check terms acceptance before allowing app access
        final hasAcceptedTerms = await TermsAcceptanceHelper.hasAcceptedTerms();
        
        if (!hasAcceptedTerms) {
          // Show terms acceptance dialog
          final accepted = await TermsAcceptanceHelper.showTermsAcceptanceDialog(context);
          
          if (!accepted) {
            // User didn't accept terms, log them out
            await _authService.logout();
            if (mounted) {
              _showError(AppLocalizations.of(context)?.acceptTermsRequired ??
                  'You must accept the Terms and Conditions to use this app.');
            }
            return;
          }
        }

        // Login successful - navigate and replace current route
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabsScreen(),
          ),
        );

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

  @override
  Widget build(BuildContext context) {
    final buildTimer = Stopwatch()..start();

    final widget = Scaffold(
      backgroundColor: const Color(0xFFFFFBF5), // Karrot warm cream background
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
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
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
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212124),
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 8.0),

                Text(
                  AppLocalizations.of(context)?.loginToYourAccount ??
                      'Login to continue',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 40.0),

                // Email input - Karrot style
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    enabled: !_isLoading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212124),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: _isLoading
                            ? Colors.grey.shade400
                            : const Color(0xFF212124),
                      ),
                      hintText: 'Email address',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    enabled: !_isLoading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212124),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:
                          AppLocalizations.of(context)?.password ?? 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
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
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
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
                            ? Colors.grey.shade400
                            : const Color(0xFF6C757D),
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
                        : [
                            BoxShadow(
                              color: const Color(0xFFFF6F0F).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoading
                          ? Colors.grey.shade300
                          : const Color(0xFFFF6F0F), // Karrot orange
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
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
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppLocalizations.of(context)?.or ?? 'OR',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.dontHaveAccount ??
                          "Don't have an account?",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: _isLoading
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
                        style: TextStyle(
                          color: _isLoading
                              ? Colors.grey.shade400
                              : const Color(0xFFFF6F0F),
                          fontSize: 15,
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
}
