import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/social_auth_model.dart';

/// Social Authentication Service for Google and Apple Sign-In
class SocialAuthService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await _getPrefs();
    final token = prefs.getString('token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Save tokens and user info to local storage
  Future<void> _saveAuthData(AuthTokens tokens, SocialUserInfo? userInfo, {String? photoUrl}) async {
    final prefs = await _getPrefs();
    await prefs.setString('token', tokens.access);
    // Also save to access_token key for compatibility
    await prefs.setString('access_token', tokens.access);
    if (tokens.refresh.isNotEmpty) {
      await prefs.setString('refresh_token', tokens.refresh);
    }
    // Save user info for chat and other features
    if (userInfo != null) {
      await prefs.setString('userId', userInfo.id.toString());
      await prefs.setString('username', userInfo.username);
      await prefs.setString('email', userInfo.email);
      if (userInfo.avatar != null && userInfo.avatar!.isNotEmpty) {
        await prefs.setString('avatar', userInfo.avatar!);
      }
    }
    // Save photo URL from Google if provided and no avatar from user info
    if (photoUrl != null && photoUrl.isNotEmpty) {
      final existingAvatar = prefs.getString('avatar');
      if (existingAvatar == null || existingAvatar.isEmpty) {
        await prefs.setString('avatar', photoUrl);
      }
    }
    if (kDebugMode) {
      print('🔐 Auth data saved to SharedPreferences');
      print('   token: ${tokens.access.substring(0, 10)}...');
      if (userInfo != null) {
        print('   userId: ${userInfo.id}');
        print('   username: ${userInfo.username}');
      }
      if (photoUrl != null) {
        print('   photoUrl: $photoUrl');
      }
    }
  }

  /// Fetch user info after login if not included in response
  Future<void> _fetchAndSaveUserInfo(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/user/info/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await _getPrefs();

        // Handle nested response format
        final userData = data['data'] ?? data['user'] ?? data;

        if (userData['id'] != null) {
          await prefs.setString('userId', userData['id'].toString());
        }
        if (userData['username'] != null) {
          await prefs.setString('username', userData['username']);
        }
        if (userData['email'] != null) {
          await prefs.setString('email', userData['email']);
        }
        if (userData['avatar'] != null && userData['avatar'].toString().isNotEmpty) {
          await prefs.setString('avatar', userData['avatar'].toString());
        }

        if (kDebugMode) {
          print('🔐 User info fetched and saved');
          print('   userId: ${userData['id']}');
          print('   username: ${userData['username']}');
          print('   avatar: ${userData['avatar']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to fetch user info: $e');
      }
    }
  }

  // ==================== Google Sign-In ====================

  /// Login with Google
  Future<SocialAuthResponse> loginWithGoogle(String idToken, {String? photoUrl}) async {
    try {
      final url = '$baseUrl/accounts/auth/google/';
      if (kDebugMode) {
        print('🔐 Google login API call to: $url');
      }

      final body = <String, dynamic>{'id_token': idToken};
      if (photoUrl != null) body['photo_url'] = photoUrl;

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print('🔐 Google login response status: ${response.statusCode}');
        print('🔐 Google login response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = SocialAuthResponse.fromJson(data);

        // Save tokens and user info if successful
        if (authResponse.success && authResponse.tokens != null) {
          await _saveAuthData(authResponse.tokens!, authResponse.userInfo, photoUrl: photoUrl);

          // If no user info in response, fetch it separately
          if (authResponse.userInfo == null) {
            await _fetchAndSaveUserInfo(authResponse.tokens!.access);
          }
        }

        return authResponse;
      }

      // Check for account lockout
      if (response.statusCode == 429 || data['locked_until'] != null) {
        return SocialAuthResponse.error(
          data['error'] ?? 'Account temporarily locked',
        );
      }

      return SocialAuthResponse.error(
        data['error'] ?? 'Google login failed',
      );
    } catch (e) {
      print('Error with Google login: $e');
      return SocialAuthResponse.error('Network error: $e');
    }
  }

  // ==================== Apple Sign-In ====================

  /// Login with Apple
  Future<SocialAuthResponse> loginWithApple({
    required String idToken,
    String? userEmail,
    String? userName,
  }) async {
    try {
      final body = <String, dynamic>{'id_token': idToken};
      if (userEmail != null) body['user_email'] = userEmail;
      if (userName != null) body['user_name'] = userName;

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/apple/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final authResponse = SocialAuthResponse.fromJson(data);

        // Save tokens and user info if successful
        if (authResponse.success && authResponse.tokens != null) {
          await _saveAuthData(authResponse.tokens!, authResponse.userInfo);

          // If no user info in response, fetch it separately
          if (authResponse.userInfo == null) {
            await _fetchAndSaveUserInfo(authResponse.tokens!.access);
          }
        }

        return authResponse;
      }

      return SocialAuthResponse.error(
        data['error'] ?? 'Apple login failed',
      );
    } catch (e) {
      print('Error with Apple login: $e');
      return SocialAuthResponse.error('Network error: $e');
    }
  }

  // ==================== Linked Accounts ====================

  /// Get linked social accounts
  Future<List<SocialAccount>> getLinkedAccounts() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/social-accounts/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((a) => SocialAccount.fromJson(a))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting linked accounts: $e');
      return [];
    }
  }

  /// Unlink social account
  Future<Map<String, dynamic>> unlinkAccount(String provider) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/accounts/social-accounts/'),
        headers: headers,
        body: jsonEncode({'provider': provider}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return {
          'success': true,
          'message': 'Account unlinked successfully',
        };
      }

      final data = jsonDecode(response.body);
      return {
        'success': false,
        'error': data['error'] ?? 'Failed to unlink account',
      };
    } catch (e) {
      print('Error unlinking account: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  /// Link Google account to existing account
  Future<Map<String, dynamic>> linkGoogleAccount(String idToken) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/google/link/'),
        headers: headers,
        body: jsonEncode({'id_token': idToken}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Google account linked',
        };
      }

      return {
        'success': false,
        'error': data['error'] ?? 'Failed to link Google account',
      };
    } catch (e) {
      print('Error linking Google account: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  /// Link Apple account to existing account
  Future<Map<String, dynamic>> linkAppleAccount({
    required String idToken,
    String? userEmail,
    String? userName,
  }) async {
    try {
      final headers = await _getAuthHeaders();
      final body = <String, dynamic>{'id_token': idToken};
      if (userEmail != null) body['user_email'] = userEmail;
      if (userName != null) body['user_name'] = userName;

      final response = await http.post(
        Uri.parse('$baseUrl/accounts/auth/apple/link/'),
        headers: headers,
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Apple account linked',
        };
      }

      return {
        'success': false,
        'error': data['error'] ?? 'Failed to link Apple account',
      };
    } catch (e) {
      print('Error linking Apple account: $e');
      return {
        'success': false,
        'error': 'Network error: $e',
      };
    }
  }

  // ==================== Login History ====================

  /// Get login history
  Future<List<LoginHistoryEntry>> getLoginHistory({int limit = 20}) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/accounts/login-history/?limit=$limit'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return (data['data'] as List)
              .map((e) => LoginHistoryEntry.fromJson(e))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting login history: $e');
      return [];
    }
  }

  // ==================== Helpers ====================

  /// Check if Google Sign-In is available
  bool get isGoogleSignInAvailable {
    // Google Sign-In is available on all platforms
    return true;
  }

  /// Check if Apple Sign-In is available
  bool get isAppleSignInAvailable {
    // Apple Sign-In is only available on iOS 13+ and macOS
    if (kIsWeb) return false;
    return Platform.isIOS || Platform.isMacOS;
  }

  /// Clear stored tokens (for logout)
  Future<void> clearTokens() async {
    final prefs = await _getPrefs();
    await prefs.remove('token');
    await prefs.remove('refresh_token');
  }
}
