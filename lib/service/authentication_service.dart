import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:developer' as developer;

import 'package:app/store/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:app/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class Token {
  final String token;
  const Token({required this.token});
}

final authenticationServiceProvider =
    Provider((ref) => AuthenticationService(authStatesProvider));

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
      StateNotifierProvider<authStateProvider, List<dynamic>>
          authStatesProvider);

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

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
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/forgot-password/send-otp/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'OTP sent successfully'
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to send OTP'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String phoneNumber,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/forgot-password/reset/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone_number': phoneNumber,
          'otp': otp,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully'
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? 'Failed to change password'
        };
      }
    } catch (e) {
      return {'success': false, 'error': 'Network error: ${e.toString()}'};
    }
  }

  Future<Token?> login(
      BuildContext context, String phoneNumber, String password) async {
    // Prevent duplicate login requests
    final requestKey = '$phoneNumber:login';
    if (_pendingRequests.containsKey(requestKey)) {
      if (kDebugMode) {
        print('🔄 Login already in progress for $phoneNumber');
      }
      return _pendingRequests[requestKey];
    }

    // Start comprehensive timing
    final totalTimer = Stopwatch()..start();
    developer.Timeline.startSync('Mobile Login Request');

    // Create and cache the login future
    final loginFuture =
        _performLogin(context, phoneNumber, password, totalTimer);
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

  Future<Token?> _performLogin(BuildContext context, String phoneNumber,
      String password, Stopwatch totalTimer) async {
    try {
      // URL preparation timing
      final urlTimer = Stopwatch()..start();
      final url = Uri.parse('$baseUrl$LOGIN_URL');
      urlTimer.stop();
      _logTiming('URL Parse', urlTimer.elapsed.inMilliseconds);

      // Body preparation timing
      final bodyTimer = Stopwatch()..start();
      final body = jsonEncode({
        'phone_number': phoneNumber,
        'password': password,
        // Add client metadata to help server optimize
        'client_info': {
          'platform': Platform.operatingSystem,
          'version': Platform.operatingSystemVersion,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        }
      });
      bodyTimer.stop();
      _logTiming('Body Preparation', bodyTimer.elapsed.inMilliseconds);

      if (kDebugMode) {
        print('🌐 Starting mobile network request to: $url');
        print('📱 Platform: ${Platform.operatingSystem}');
        print('📊 Body size: ${body.length} bytes');
      }

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
          throw TimeoutException('Login request timed out after 15 seconds',
              const Duration(seconds: 15));
        },
      );

      networkTimer.stop();
      final networkTime = networkTimer.elapsed.inMilliseconds;
      _logTiming('Network Request', networkTime);

      // Log detailed network metrics
      if (kDebugMode) {
        print('📡 Network completed in ${networkTime}ms');
        print('📊 Response status: ${response.statusCode}');
        print('📊 Response length: ${response.body.length} bytes');

        // Log compression efficiency
        final contentLength = response.headers['content-length'];
        if (contentLength != null) {
          print('📊 Content-Length: $contentLength bytes');
        }

        final contentEncoding = response.headers['content-encoding'];
        if (contentEncoding != null) {
          print('📊 Content-Encoding: $contentEncoding');
        }
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

        final token = userData['token'] as String;
        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();

        // Save user data asynchronously (don't wait)
        unawaited(_saveUserDataAsync(token, userId, userLocation));

        totalTimer.stop();
        _logTiming('TOTAL LOGIN', totalTimer.elapsed.inMilliseconds);

        if (kDebugMode) {
          print('✅ Login successful in ${totalTimer.elapsed.inMilliseconds}ms');
          _printNetworkAnalysis(networkTime, totalTimer.elapsed.inMilliseconds);
        }

        return Token(token: token);
      } else {
        parseTimer.stop();
        _handleHttpError(context, response.statusCode, response.body);
        return null;
      }
    } on TimeoutException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Timeout', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print(
            '⏰ Login timeout after ${totalTimer.elapsed.inMilliseconds}ms: $e');
      }
      _showError(context,
          'Request timed out. Please check your internet connection and try again.');
      return null;
    } on SocketException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Network Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print(
            '🌐 Network error after ${totalTimer.elapsed.inMilliseconds}ms: $e');
      }
      _showError(context,
          'No internet connection. Please check your network and try again.');
      return null;
    } on FormatException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - Parse Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print('📝 JSON parsing error: $e');
      }
      _showError(context, 'Invalid response from server. Please try again.');
      return null;
    } on HttpException catch (e) {
      totalTimer.stop();
      _logTiming('FAILED - HTTP Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print('🌐 HTTP error: $e');
      }
      _showError(context, 'Server error. Please try again later.');
      return null;
    } catch (error) {
      totalTimer.stop();
      _logTiming('FAILED - Unknown Error', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print(
            '💥 Unknown login error after ${totalTimer.elapsed.inMilliseconds}ms: $error');
      }
      _showError(context, 'An unexpected error occurred. Please try again.');
      return null;
    }
  }

  void _printNetworkAnalysis(int networkTime, int totalTime) {
    if (!kDebugMode) return;

    print('\n📊 NETWORK PERFORMANCE ANALYSIS:');
    print('─' * 40);
    print(
        '🌐 Network Time: ${networkTime}ms (${((networkTime / totalTime) * 100).toStringAsFixed(1)}%)');
    print(
        '⚡ Processing Time: ${totalTime - networkTime}ms (${(((totalTime - networkTime) / totalTime) * 100).toStringAsFixed(1)}%)');

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

    print('🏆 Network Performance: $networkRating');
    print('─' * 40);
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

    print('$emoji ⏱️ $operation: ${milliseconds}ms');
  }

  void _handleHttpError(
      BuildContext context, int statusCode, String responseBody) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Invalid request. Please check your input.';
        break;
      case 401:
        message =
            'Invalid credentials. Please check your phone number and password.';
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

    if (kDebugMode) {
      print('❌ HTTP Error $statusCode: $responseBody');
    }

    _showError(context, message);
  }

  Future<void> _saveUserDataAsync(
      String token, String userId, String userLocation) async {
    try {
      final saveTimer = Stopwatch()..start();
      final prefs = await _getPrefs();

      await Future.wait([
        prefs.setString('token', token),
        prefs.setString('userId', userId),
        prefs.setString('userLocation', userLocation),
      ]);

      saveTimer.stop();
      _logTiming('SharedPreferences Save', saveTimer.elapsed.inMilliseconds);
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error saving user data: $e');
      }
      // Don't throw here as the login was successful
    }
  }

  bool _isValidLoginResponse(Map<String, dynamic> userData) {
    return userData.containsKey('token') &&
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
    String phoneNumber,
    String password,
    String userName,
    String regionName,
    String districtName,
    String districtId,
    File? profileImage,
  ) async {
    // Prevent duplicate registration requests
    final requestKey = '$phoneNumber:register';
    if (_pendingRequests.containsKey(requestKey)) {
      if (kDebugMode) {
        print('🔄 Registration already in progress for $phoneNumber');
      }
      return _pendingRequests[requestKey];
    }

    final totalTimer = Stopwatch()..start();

    final registrationFuture = _performRegistration(
        phoneNumber,
        password,
        userName,
        regionName,
        districtName,
        districtId,
        profileImage,
        totalTimer);

    _pendingRequests[requestKey] = registrationFuture;

    try {
      final result = await registrationFuture;
      return result;
    } finally {
      _pendingRequests.remove(requestKey);
    }
  }

  Future<Token?> _performRegistration(
    String phoneNumber,
    String password,
    String userName,
    String regionName,
    String districtName,
    String districtId, // Make sure this is passed as String
    File? profileImage,
    Stopwatch totalTimer,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$REGISTER_URL');
      print("Here");

      // Ensure districtId is not null or empty
      if (districtId.isEmpty) {
        throw Exception('District ID cannot be empty');
      }

      final request = http.MultipartRequest('POST', url)
        ..fields.addAll({
          'phone_number': phoneNumber,
          'password': password,
          'user_type': 'regular',
          'username': userName,
          'location_id': districtId,
          // Try removing the nested location fields if they're causing issues
          // 'location[country]': 'Uzbekistan',
          // 'location[region]': regionName,
          // 'location[district]': districtName,
        })
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

      if (kDebugMode) {
        print('📝 Sending optimized registration request...');
        print('📍 District ID being sent: $districtId');
      }

      final networkTimer = Stopwatch()..start();
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 45), // Reduced from 60s
          );
      networkTimer.stop();
      _logTiming('Registration Network', networkTimer.elapsed.inMilliseconds);

      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('📊 Response Status: ${response.statusCode}');
        print('📊 Response Headers: ${response.headers}');
        print('📊 Response Body Length: ${response.body.length}');
        if (response.body.length < 1000) {
          // Only print if not too long
          print('📊 Response Body: ${response.body}');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);

        if (!_isValidLoginResponse(userData)) {
          throw Exception('Invalid response format from server');
        }

        final token = userData['token'] as String;
        final userId = userData['user_info']['id'].toString();
        final userLocation = userData['user_info']['location']['id'].toString();

        unawaited(_saveUserDataAsync(token, userId, userLocation));

        totalTimer.stop();
        _logTiming('TOTAL REGISTRATION', totalTimer.elapsed.inMilliseconds);

        return Token(token: token);
      } else {
        if (kDebugMode) {
          print(
              '❌ Registration failed: ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (error) {
      totalTimer.stop();
      _logTiming('FAILED REGISTRATION', totalTimer.elapsed.inMilliseconds);
      if (kDebugMode) {
        print('💥 Registration error: $error');
      }
      return null;
    }
  }

  // Get current stored token
  Future<String?> getStoredToken() async {
    try {
      final prefs = await _getPrefs();
      return prefs.getString('token');
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error retrieving stored token: $e');
      }
      return null;
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  // Logout and clear data
  Future<void> logout() async {
    try {
      final prefs = await _getPrefs();
      await Future.wait([
        prefs.remove('token'),
        prefs.remove('userId'),
        prefs.remove('userLocation'),
      ]);

      // Clear pending requests
      _pendingRequests.clear();

      if (kDebugMode) {
        print('✅ User logged out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error during logout: $e');
      }
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
