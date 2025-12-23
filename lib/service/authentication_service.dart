import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:app/constants/constants.dart';
import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Token model containing access token and refresh token
class Token {
  final String accessToken;
  final String? refreshToken;
  final int? expiresIn; // seconds
  final int? refreshExpiresIn; // seconds

  const Token({
    required this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.refreshExpiresIn,
  });

  // Backward compatibility: use accessToken as token
  String get token => accessToken;
}

final authenticationServiceProvider = Provider(
  (ref) => AuthenticationService(authStatesProvider),
);

class AuthenticationService {
  // Optimize HTTP client for mobile
  static http.Client? _httpClient;
  SharedPreferences? _prefs;

  // Simple request cache to avoid duplicate requests
  static final Map<String, Future<Token?>> _pendingRequests = {};

  // Get or create optimized HTTP client
  static http.Client get httpClient {
    if (_httpClient == null) {
      _initializeHttpClient();
    }
    return _httpClient!;
  }

  // Initialize optimized HTTP client
  static void _initializeHttpClient() {
    if (kIsWeb) {
      _httpClient = http.Client();
    } else {
      // Mobile-specific optimizations
      _httpClient = http.Client();

      // For Android/iOS, we can create a custom client with optimizations
      if (Platform.isAndroid || Platform.isIOS) {
        // Connection pooling is handled automatically by http.Client
        // Additional optimizations can be added here
      }
    }
  }

  AuthenticationService(
    StateNotifierProvider<authStateProvider, List<dynamic>> authStatesProvider,
  );

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Expose _getPrefs for TokenRefreshService (needed for expiry check)
  @visibleForTesting
  Future<SharedPreferences> getPrefsForTesting() => _getPrefs();

  Future<Map<String, dynamic>> requestAccountDeletion(String password) async {
    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/request-account-deletion/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({'password': password}),
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> confirmAccountDeletion(String otp) async {
    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/confirm-account-deletion/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({'otp': otp}),
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> cancelAccountDeletion() async {
    try {
      final prefs = await _getPrefs();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/cancel-account-deletion/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> sendOtpChangePassword({
    required String email,
    String? phoneNumber,
  }) async {
    try {
      final body = <String, dynamic>{'email': email};
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        body['phone_number'] = phoneNumber;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/forgot-password/send-otp/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to send OTP',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String email,
    required String verificationCode,
    required String newPassword,
    required String confirmPassword,
    String? phoneNumber,
  }) async {
    try {
      final body = <String, dynamic>{
        'email': email,
        'verification_code': verificationCode,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      };
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        body['phone_number'] = phoneNumber;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/forgot-password/reset/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Request password update verification code (for authenticated users)
  /// Requires current password to verify identity
  Future<Map<String, dynamic>> requestPasswordUpdate({
    required String currentPassword,
  }) async {
    try {
      final prefs = await _getPrefs();
      final token =
          prefs.getString('token') ?? prefs.getString(AppConfig.accessTokenKey);

      if (token == null || token.isEmpty) {
        return {'success': false, 'error': 'Authentication required'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/password/request-update/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({'current_password': currentPassword}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Verification code sent to your email',
        };
      } else {
        return {
          'success': false,
          'error':
              data['error'] ??
              data['message'] ??
              'Failed to send verification code',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  /// Update password with verification code (for authenticated users)
  Future<Map<String, dynamic>> updatePassword({
    required String verificationCode,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final prefs = await _getPrefs();
      final token =
          prefs.getString('token') ?? prefs.getString(AppConfig.accessTokenKey);

      if (token == null || token.isEmpty) {
        return {'success': false, 'error': 'Authentication required'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/password/update/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'verification_code': verificationCode,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password updated successfully',
        };
      } else {
        return {
          'success': false,
          'error':
              data['error'] ?? data['message'] ?? 'Failed to update password',
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Token?> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    // Prevent duplicate login requests
    final requestKey = '$email:login';
    if (_pendingRequests.containsKey(requestKey)) {
      if (kDebugMode) {}
      return _pendingRequests[requestKey];
    }

    // Start comprehensive timing
    final totalTimer = Stopwatch()..start();
    developer.Timeline.startSync('Mobile Login Request');

    // Create and cache the login future
    final loginFuture = _performLogin(context, email, password, totalTimer);
    _pendingRequests[requestKey] = loginFuture;

    try {
      final result = await loginFuture;
      return result;
    } finally {
      // Clean up pending request
      _pendingRequests.remove(requestKey);
      developer.Timeline.finishSync();
    }
  }

  Future<Token?> _performLogin(
    BuildContext context,
    String email,
    String password,
    Stopwatch totalTimer,
  ) async {
    try {
      // URL preparation timing
      final urlTimer = Stopwatch()..start();
      final url = Uri.parse('$baseUrl$LOGIN_URL');
      urlTimer.stop();
      _logTiming('URL Parse', urlTimer.elapsed.inMilliseconds);

      // Body preparation timing
      final bodyTimer = Stopwatch()..start();
      final body = jsonEncode({
        'email': email,
        'password': password,
        // Add client metadata to help server optimize
        'client_info': {
          'platform': Platform.operatingSystem,
          'version': Platform.operatingSystemVersion,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      });
      bodyTimer.stop();
      _logTiming('Body Preparation', bodyTimer.elapsed.inMilliseconds);

      if (kDebugMode) {}

      // Network request with mobile optimizations
      final networkTimer = Stopwatch()..start();

      final response = await httpClient
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Accept-Encoding': 'gzip, deflate, br', // Enable all compression
              'Connection': 'keep-alive',
              'Keep-Alive': 'timeout=5, max=1000',
              'Cache-Control': 'no-cache',
              'User-Agent': 'FlutterApp/1.0 (${Platform.operatingSystem})',
              // Mobile-specific headers
              if (Platform.isAndroid) 'X-Platform': 'Android',
              if (Platform.isIOS) 'X-Platform': 'iOS',
              // Request priority
              'X-Request-Priority': 'high',
              'X-Client-Type': 'mobile-flutter',
            },
            body: body,
          )
          .timeout(
            const Duration(seconds: 15), // Reduced timeout from 30s
            onTimeout: () {
              throw TimeoutException(
                'Login request timed out after 15 seconds',
                const Duration(seconds: 15),
              );
            },
          );

      networkTimer.stop();
      final networkTime = networkTimer.elapsed.inMilliseconds;
      _logTiming('Network Request', networkTime);

      // Log detailed network metrics
      if (kDebugMode) {
        // Log compression efficiency
        final contentLength = response.headers['content-length'];
        if (contentLength != null) {}

        final contentEncoding = response.headers['content-encoding'];
        if (contentEncoding != null) {}
      }

      // Response parsing timing
      final parseTimer = Stopwatch()..start();

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        parseTimer.stop();
        _logTiming('JSON Parsing', parseTimer.elapsed.inMilliseconds);

        // Validate response structure
        if (!_isValidLoginResponse(userData)) {
          throw Exception('Invalid response format from server');
        }

        // Get access token (backward compatible: check 'token' first, then 'access_token')
        final accessToken =
            userData['access_token'] as String? ?? userData['token'] as String;
        final refreshToken = userData['refresh_token'] as String?;
        final expiresIn = userData['expires_in'] as int?;
        final refreshExpiresIn = userData['refresh_expires_in'] as int?;

        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();

        // Save user data asynchronously (don't wait)
        unawaited(
          _saveUserDataAsync(
            accessToken,
            refreshToken,
            userId,
            userLocation,
            expiresIn,
            refreshExpiresIn,
          ),
        );

        totalTimer.stop();
        _logTiming('TOTAL LOGIN', totalTimer.elapsed.inMilliseconds);

        if (kDebugMode) {
          _printNetworkAnalysis(networkTime, totalTimer.elapsed.inMilliseconds);
        }

        return Token(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiresIn,
          refreshExpiresIn: refreshExpiresIn,
        );
      } else {
        parseTimer.stop();
        _handleHttpError(context, response.statusCode, response.body);
        return null;
      }
    } on TimeoutException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Timeout', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      _showError(
        context,
        'Request timed out. Please check your internet connection and try again.',
      );
      return null;
    } on SocketException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Network Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      _showError(
        context,
        'No internet connection. Please check your network and try again.',
      );
      return null;
    } on FormatException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Parse Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      _showError(context, 'Invalid response from server. Please try again.');
      return null;
    } on HttpException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - HTTP Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      _showError(context, 'Server error. Please try again later.');
      return null;
    } catch (error) {
      totalTimer.stop();
      _logTiming('FAILED - Unknown Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      _showError(context, 'An unexpected error occurred. Please try again.');
      return null;
    }
  }

  void _printNetworkAnalysis(int networkTime, int totalTime) {
    if (!kDebugMode) return;

    // Performance rating
    String networkRating;
    if (networkTime < 500)
      networkRating = '🟢 Excellent';
    else if (networkTime < 1000)
      networkRating = '🟡 Good';
    else if (networkTime < 2000)
      networkRating = '🟠 Fair';
    else
      networkRating = '🔴 Slow';
  }

  void _logTiming(String operation, int milliseconds) {
    if (!kDebugMode) return;

    String emoji;
    if (milliseconds < 100)
      emoji = '🟢';
    else if (milliseconds < 500)
      emoji = '🟡';
    else if (milliseconds < 2000)
      emoji = '🟠';
    else
      emoji = '🔴';
  }

  void _handleHttpError(
    BuildContext context,
    int statusCode,
    String responseBody,
  ) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Invalid request. Please check your input.';
        break;
      case 401:
        message = 'Invalid credentials. Please check your email and password.';
        break;
      case 403:
        message = 'Access denied. Please contact support.';
        break;
      case 404:
        message = 'Service not found. Please try again later.';
        break;
      case 429:
        message = 'Too many attempts. Please wait and try again.';
        break;
      case 500:
      case 502:
      case 503:
        message = 'Server error. Please try again later.';
        break;
      default:
        message = 'Login failed (Error $statusCode). Please try again.';
    }

    if (kDebugMode) {}

    _showError(context, message);
  }

  Future<void> _saveUserDataAsync(
    String accessToken,
    String? refreshToken,
    String userId,
    String userLocation,
    int? expiresIn,
    int? refreshExpiresIn,
  ) async {
    try {
      final saveTimer = Stopwatch()..start();
      final prefs = await _getPrefs();

      final futures = <Future>[
        prefs.setString('token', accessToken), // Backward compatible
        prefs.setString(AppConfig.accessTokenKey, accessToken),
        prefs.setString('userId', userId),
        prefs.setString('userLocation', userLocation),
      ];

      if (refreshToken != null) {
        futures.add(prefs.setString(AppConfig.refreshTokenKey, refreshToken));
      }

      if (expiresIn != null) {
        futures.add(prefs.setInt('token_expires_in', expiresIn));
        // Store expiry timestamp
        final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
        futures.add(
          prefs.setString('token_expires_at', expiryTime.toIso8601String()),
        );
      }

      if (refreshExpiresIn != null) {
        futures.add(prefs.setInt('refresh_token_expires_in', refreshExpiresIn));
        final refreshExpiryTime = DateTime.now().add(
          Duration(seconds: refreshExpiresIn),
        );
        futures.add(
          prefs.setString(
            'refresh_token_expires_at',
            refreshExpiryTime.toIso8601String(),
          ),
        );
      }

      await Future.wait(futures);

      saveTimer.stop();
      _logTiming('SharedPreferences Save', saveTimer.elapsed.inMilliseconds);
    } catch (e) {
      AppLogger.error('Error saving user data: $e');
      // Don't throw here as the login was successful
    }
  }

  bool _isValidLoginResponse(Map<String, dynamic> userData) {
    // Accept either 'token' (backward compatible) or 'access_token'
    final hasToken =
        userData.containsKey('token') || userData.containsKey('access_token');
    return hasToken &&
        userData.containsKey('user_info') &&
        userData['user_info'] is Map &&
        userData['user_info'].containsKey('id') &&
        userData['user_info'].containsKey('location') &&
        userData['user_info']['location'] is Map &&
        userData['user_info']['location'].containsKey('id');
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // Optimized registration method
  Future<Token?> register(
    String email,
    String password,
    String userName,
    String regionName,
    String districtName,
    String districtId,
    File? profileImage,
    String? phoneNumber,
    String verificationCode,
  ) async {
    // Prevent duplicate registration requests
    final requestKey = '$email:register';
    if (_pendingRequests.containsKey(requestKey)) {
      if (kDebugMode) {}
      return _pendingRequests[requestKey];
    }

    final totalTimer = Stopwatch()..start();

      final registrationFuture = _performRegistration(
        email,
        password,
        userName,
        regionName,
        districtName,
        districtId,
        profileImage,
        phoneNumber,
        verificationCode,
        totalTimer,
      );

    _pendingRequests[requestKey] = registrationFuture;

    try {
      final result = await registrationFuture;
      return result;
    } finally {
      _pendingRequests.remove(requestKey);
    }
  }

  Future<Token?> _performRegistration(
    String email,
    String password,
    String userName,
    String regionName,
    String districtName,
    String districtId, // Make sure this is passed as String
    File? profileImage,
    String? phoneNumber,
    String verificationCode,
    Stopwatch totalTimer,
  ) async {
    try {
      // Registration endpoint: /accounts/register/
      final url = Uri.parse('$baseUrl$REGISTER_URL');

      // Ensure districtId is not null or empty
      if (districtId.isEmpty) {
        throw Exception('District ID cannot be empty');
      }

      final fields = <String, String>{
        'email': email,
        'password': password,
        'verification_code': verificationCode,
        'user_type': 'regular',
        'username': userName,
        'location_id': districtId,
      };

      // Add phone_number only if provided
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        fields['phone_number'] = phoneNumber;
      }

      final request = http.MultipartRequest('POST', url)
        ..fields.addAll(fields)
        ..headers.addAll({
          'Accept': 'application/json',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'User-Agent': 'FlutterApp/1.0 (${Platform.operatingSystem})',
          if (Platform.isAndroid) 'X-Platform': 'Android',
          if (Platform.isIOS) 'X-Platform': 'iOS',
          'X-Request-Priority': 'high',
          'X-Client-Type': 'mobile-flutter',
        });

      if (profileImage != null) {
        final imageFile = await http.MultipartFile.fromPath(
          'profile_image',
          profileImage.path,
        );
        request.files.add(imageFile);
      }

      if (kDebugMode) {}

      final networkTimer = Stopwatch()..start();
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 45), // Reduced from 60s
      );
      networkTimer.stop();
      _logTiming('Registration Network', networkTimer.elapsed.inMilliseconds);

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        if (response.body.length < 1000) {
          // Only print if not too long
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);

        if (!_isValidLoginResponse(userData)) {
          throw Exception('Invalid response format from server');
        }

        // Get access token (backward compatible: check 'token' first, then 'access_token')
        final accessToken =
            userData['access_token'] as String? ?? userData['token'] as String;
        final refreshToken = userData['refresh_token'] as String?;
        final expiresIn = userData['expires_in'] as int?;
        final refreshExpiresIn = userData['refresh_expires_in'] as int?;

        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();

        unawaited(
          _saveUserDataAsync(
            accessToken,
            refreshToken,
            userId,
            userLocation,
            expiresIn,
            refreshExpiresIn,
          ),
        );

        totalTimer.stop();
        _logTiming('TOTAL REGISTRATION', totalTimer.elapsed.inMilliseconds);

        return Token(
          accessToken: accessToken,
          refreshToken: refreshToken,
          expiresIn: expiresIn,
          refreshExpiresIn: refreshExpiresIn,
        );
      } else {
        if (kDebugMode) {}
        return null;
      }
    } catch (error) {
      totalTimer.stop();
      _logTiming('FAILED REGISTRATION', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {}
      return null;
    }
  }

  // Get current stored access token
  Future<String?> getStoredToken() async {
    try {
      final prefs = await _getPrefs();
      // Try new key first, fallback to old key for backward compatibility
      return prefs.getString(AppConfig.accessTokenKey) ??
          prefs.getString('token');
    } catch (e) {
      AppLogger.error('Error getting stored token: $e');
      return null;
    }
  }

  // Get stored refresh token
  Future<String?> getStoredRefreshToken() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString(AppConfig.refreshTokenKey);
    } catch (e) {
      AppLogger.error('Error getting refresh token: $e');
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  /// Refresh the access token using the refresh token
  /// Returns new Token if successful, null otherwise
  Future<Token?> refreshToken() async {
    try {
      final refreshToken = await getStoredRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('No refresh token available');
        return null;
      }

      final url = Uri.parse(
        '${AppConfig.baseUrl}${AppConfig.refreshTokenPath}',
      );

      final response = await httpClient
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException(
                'Token refresh timed out',
                const Duration(seconds: 15),
              );
            },
          );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true || data.containsKey('access_token')) {
          final accessToken = data['access_token'] as String;
          final newRefreshToken =
              data['refresh_token'] as String? ?? refreshToken;
          final expiresIn = data['expires_in'] as int?;
          final refreshExpiresIn = data['refresh_expires_in'] as int?;

          // Save new tokens
          final prefs = await _getPrefs();
          await Future.wait([
            prefs.setString('token', accessToken), // Backward compatible
            prefs.setString(AppConfig.accessTokenKey, accessToken),
            if (newRefreshToken != refreshToken)
              prefs.setString(AppConfig.refreshTokenKey, newRefreshToken),
            if (expiresIn != null) ...[
              prefs.setInt('token_expires_in', expiresIn),
              prefs.setString(
                'token_expires_at',
                DateTime.now()
                    .add(Duration(seconds: expiresIn))
                    .toIso8601String(),
              ),
            ],
            if (refreshExpiresIn != null) ...[
              prefs.setInt('refresh_token_expires_in', refreshExpiresIn),
              prefs.setString(
                'refresh_token_expires_at',
                DateTime.now()
                    .add(Duration(seconds: refreshExpiresIn))
                    .toIso8601String(),
              ),
            ],
          ]);

          AppLogger.info('Token refreshed successfully');
          return Token(
            accessToken: accessToken,
            refreshToken: newRefreshToken,
            expiresIn: expiresIn,
            refreshExpiresIn: refreshExpiresIn,
          );
        } else {
          AppLogger.error('Invalid refresh response: ${response.body}');
          return null;
        }
      } else {
        AppLogger.error(
          'Token refresh failed: ${response.statusCode} - ${response.body}',
        );
        // If refresh token is invalid/expired, clear tokens
        if (response.statusCode == 401 || response.statusCode == 403) {
          await logout();
        }
        return null;
      }
    } on TimeoutException catch (e) {
      AppLogger.error('Token refresh timeout: $e');
      return null;
    } catch (e) {
      AppLogger.error('Error refreshing token: $e');
      return null;
    }
  }

  /// Verify if the current access token is valid
  Future<bool> verifyToken() async {
    try {
      final accessToken = await getStoredToken();
      if (accessToken == null || accessToken.isEmpty) {
        return false;
      }

      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.verifyTokenPath}');

      final response = await httpClient
          .get(
            url,
            headers: {
              'Authorization': 'Token $accessToken',
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw TimeoutException(
                'Token verification timed out',
                const Duration(seconds: 10),
              );
            },
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e) {
      AppLogger.error('Error verifying token: $e');
      return false;
    }
  }

  // Logout and clear data
  Future<void> logout() async {
    try {
      final accessToken = await getStoredToken();
      final refreshToken = await getStoredRefreshToken();

      // Try to revoke tokens on backend (don't wait for it)
      if (accessToken != null) {
        unawaited(_revokeTokensOnBackend(accessToken, refreshToken));
      }

      final prefs = await _getPrefs();
      await Future.wait([
        prefs.remove('token'), // Backward compatible
        prefs.remove(AppConfig.accessTokenKey),
        prefs.remove(AppConfig.refreshTokenKey),
        prefs.remove('userId'),
        prefs.remove('userLocation'),
        prefs.remove('token_expires_in'),
        prefs.remove('token_expires_at'),
        prefs.remove('refresh_token_expires_in'),
        prefs.remove('refresh_token_expires_at'),
      ]);

      // Clear pending requests
      _pendingRequests.clear();

      AppLogger.info('User logged out successfully');
    } catch (e) {
      AppLogger.error('Error during logout: $e');
    }
  }

  /// Revoke tokens on backend
  Future<void> _revokeTokensOnBackend(
    String? accessToken,
    String? refreshToken,
  ) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.logoutPath}');

      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (accessToken != null) {
        headers['Authorization'] = 'Token $accessToken';
      }

      final body = <String, dynamic>{};
      if (refreshToken != null) {
        body['refresh_token'] = refreshToken;
      }

      try {
        await httpClient
            .post(url, headers: headers, body: jsonEncode(body))
            .timeout(const Duration(seconds: 5));
      } on TimeoutException {
        // Don't throw, just log - logout should succeed even if backend call fails
        AppLogger.warning('Logout backend call timed out');
      }
    } catch (e) {
      // Don't throw - logout should succeed even if backend call fails
      AppLogger.warning('Failed to revoke tokens on backend: $e');
    }
  }

  void clearCache() {
    _prefs?.clear();
    _prefs = null;
    _pendingRequests.clear();
  }

  void dispose() {
    _httpClient?.close();
    _httpClient = null;
    clearCache();
  }
}

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;

  const TimeoutException(this.message, this.timeout);

  @override
  String toString() => 'TimeoutException: $message (${timeout.inSeconds}s)';
}
