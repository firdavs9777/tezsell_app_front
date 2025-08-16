import 'package:app/pages/authentication/register.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'dart:developer' as developer;

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  late final TextEditingController _phoneNumberController;
  late final TextEditingController _passwordController;
  late final AuthenticationService _authService;

  String _countryCode = '+998';
  String _countryName = 'Uzbekistan';

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Performance tracking variables
  final Stopwatch _totalLoginTime = Stopwatch();
  final Map<String, int> _performanceMetrics = {};
  DateTime? _loginStartTime;

  // Get full phone number with country code
  String get fullPhoneNumber =>
      '$_countryCode${_phoneNumberController.text.trim()}';

  @override
  void initState() {
    super.initState();

    // Track initialization time
    final initTimer = Stopwatch()..start();

    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _authService = ref.read(authenticationServiceProvider);

    initTimer.stop();
    _logPerformance('Widget Initialization', initTimer.elapsed.inMilliseconds);
  }

  @override
  void dispose() {
    // Print performance summary before disposing
    _printPerformanceSummary();

    _phoneNumberController.dispose();
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
      print('$emoji ⏱️ $operation: ${milliseconds}ms');
    }
  }

  /// Print comprehensive performance summary
  void _printPerformanceSummary() {
    if (!kDebugMode) return;

    print('\n📊 LOGIN PERFORMANCE SUMMARY');
    print('═' * 60);

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
      print('$emoji $operation: ${time}ms');
    });

    print('─' * 60);
    print('🎯 Total measured time: ${totalTime}ms');

    // Performance analysis
    final networkTime = _performanceMetrics['Network Request'] ?? 0;
    final uiTime = totalTime - networkTime;

    print(
        '📊 Network time: ${networkTime}ms (${((networkTime / totalTime) * 100).toStringAsFixed(1)}%)');
    print(
        '📊 UI/Processing time: ${uiTime}ms (${((uiTime / totalTime) * 100).toStringAsFixed(1)}%)');

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

    print('🏆 Overall Performance: $rating');
    print('═' * 60);
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

      if (_phoneNumberController.text.trim().isEmpty) {
        _showError(AppLocalizations.of(context)?.pleaseEnterPhoneNumber ??
            'Please enter your phone number');
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
      final String phoneNumber = fullPhoneNumber;
      final String password = _passwordController.text.trim();
      dataTimer.stop();
      _logPerformance('Data Preparation', dataTimer.elapsed.inMilliseconds);

      if (kDebugMode) {
        print('🚀 Starting login attempt...');
        print('📱 Phone: $phoneNumber');
        print('⏰ Started at: ${_loginStartTime!.toIso8601String()}');
      }

      // Network request timing (this is usually the bottleneck)
      final networkTimer = Stopwatch()..start();
      final result = await _authService.login(context, phoneNumber, password);
      networkTimer.stop();
      _logPerformance('Network Request', networkTimer.elapsed.inMilliseconds);

      if (kDebugMode) {
        print('📡 Network request completed');
        print('📊 Result: ${result != null ? 'Success' : 'Failed'}');
      }

      if (!mounted) return; // Check if widget is still mounted

      // Navigation timing
      if (result != null) {
        final navigationTimer = Stopwatch()..start();

        // Login successful - navigate and replace current route
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const TabsScreen(),
          ),
        );

        navigationTimer.stop();
        _logPerformance('Navigation', navigationTimer.elapsed.inMilliseconds);

        if (kDebugMode) {
          print('✅ Login successful - navigating to TabsScreen');
        }
      } else {
        // Login failed - error already shown by AuthenticationService
        if (kDebugMode) {
          print('❌ Login failed - no token returned');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 Login error: $e');
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

      // Calculate time since login started
      if (_loginStartTime != null) {
        final totalElapsed = DateTime.now().difference(_loginStartTime!);
        if (kDebugMode) {
          print('🏁 Total elapsed time: ${totalElapsed.inMilliseconds}ms');
        }
      }

      // Always reset loading state
      if (mounted) {
        final resetTimer = Stopwatch()..start();
        setState(() {
          _isLoading = false;
        });
        resetTimer.stop();
        _logPerformance('UI Reset', resetTimer.elapsed.inMilliseconds);
      }
    }
  }

  void _showError(String message) {
    final errorTimer = Stopwatch()..start();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    errorTimer.stop();
    _logPerformance('Error Display', errorTimer.elapsed.inMilliseconds);
  }

  @override
  Widget build(BuildContext context) {
    // Track build performance (only in debug mode)
    final buildTimer = Stopwatch()..start();

    final widget = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          AppLocalizations.of(context)?.loginToAccount ?? 'Login to Account',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      body: AbsorbPointer(
        absorbing: _isLoading, // Disable all interactions during loading
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)?.loginToAccount ??
                      'Login to Account',
                  style: const TextStyle(fontSize: 20, color: Colors.black87),
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isLoading ? Colors.grey.shade300 : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10),
                color: _isLoading ? Colors.grey.shade100 : null,
              ),
              child: Row(
                children: [
                  // Country Code Picker with constrained width
                  SizedBox(
                    width: 150, // Fixed width to give less space
                    child: CountryCodePicker(
                      onChanged: _isLoading
                          ? null
                          : (country) {
                              setState(() {
                                _countryCode = country.dialCode!;
                                _countryName = country.name!;
                              });
                            },
                      initialSelection: 'UZ', // Uzbekistan as default
                      favorite: [
                        '+998',
                        'UZ',
                        '+82',
                        'KR',
                        '+1',
                        'US',
                        '+91',
                        'IN'
                      ],
                      showCountryOnly: false,
                      showFlag: true,
                      showDropDownButton: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4), // Reduced padding
                      textStyle: TextStyle(
                        fontSize: 14, // Slightly smaller font
                        color: _isLoading ? Colors.grey.shade400 : Colors.black,
                      ),
                      enabled: !_isLoading,
                      flagWidth: 20, // Smaller flag
                    ),
                  ),

                  // Divider line
                  Container(
                    height: 50,
                    width: 1,
                    color: _isLoading
                        ? Colors.grey.shade300
                        : Colors.grey.shade400,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.number,
                      enabled: !_isLoading, // Disable during loading
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            AppLocalizations.of(context)?.enterPhoneNumber ??
                                'Enter phone number',
                        hintStyle: TextStyle(
                          color: _isLoading
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Show selected country and full number preview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)?.selectedCountryLabel ?? "Selected:"} $_countryName ($_countryCode)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (_phoneNumberController.text.isNotEmpty)
                  Text(
                    '${AppLocalizations.of(context)?.fullPhoneLabel ?? "Full:"} $fullPhoneNumber',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 20.0),

            // Password input
            TextField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              enabled: !_isLoading, // Disable during loading
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isLoading ? Colors.grey.shade300 : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _isLoading ? Colors.grey.shade300 : Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: AppLocalizations.of(context)?.password ?? 'Password',
                labelStyle: TextStyle(
                  color: _isLoading
                      ? Colors.grey.shade400
                      : Theme.of(context).colorScheme.primary,
                ),
                filled: _isLoading,
                fillColor: _isLoading ? Colors.grey.shade100 : null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: _isLoading ? Colors.grey.shade400 : null,
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

            const SizedBox(height: 24.0),

            // Login button with live timing display
            SizedBox(
              width: 200.0,
              height: 48.0, // Fixed height to prevent jumping
              child: ElevatedButton(
                onPressed:
                    _isLoading ? null : _handleLogin, // Disable when loading
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isLoading ? Colors.grey.shade400 : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                child: _isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Show loading text
                          Text(
                            AppLocalizations.of(context)?.loading ??
                                'Loading...',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      )
                    : Text(
                        AppLocalizations.of(context)?.login ?? 'Login',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 8.0),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          // Implement forgot password logic
                          _showError(AppLocalizations.of(context)
                                  ?.forgotPasswordComingSoon ??
                              'Forgot password feature coming soon');
                        },
                  child: Text(
                    AppLocalizations.of(context)?.forgotPassword ??
                        'Forgot password?',
                    style: TextStyle(
                      color: _isLoading
                          ? Colors.grey.shade400
                          : Theme.of(context).colorScheme.primary,
                    ),
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
                  child: Text(
                    AppLocalizations.of(context)?.registerNow ?? 'Register Now',
                    style: TextStyle(
                      color: _isLoading ? Colors.grey.shade400 : Colors.black54,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ]),
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
