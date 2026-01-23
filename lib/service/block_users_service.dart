import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';
import 'package:app/providers/provider_models/block_user_model.dart';

/// Service for handling user blocking operations
class BlockUsersService {
  final String baseUrl = AppConfig.baseUrl;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, String> _getHeaders(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Block a user
  Future<void> blockUser(int userId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/block/'),
      headers: _getHeaders(token),
      body: jsonEncode({'blocked_user_id': userId}),
    );

    if (kDebugMode) {
      print('Block User Response: ${response.statusCode}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to block user');
    }
  }

  /// Unblock a user
  Future<void> unblockUser(int userId) async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.post(
      Uri.parse('$baseUrl/api/chat/unblock/'),
      headers: _getHeaders(token),
      body: jsonEncode({'blocked_user_id': userId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to unblock user');
    }
  }

  /// Get list of blocked users
  Future<List<BlockedUser>> getBlockedUsers() async {
    final token = await _getToken();
    if (token == null) throw Exception('Not authenticated');

    final response = await http.get(
      Uri.parse('$baseUrl/api/chat/blocked-users/'),
      headers: _getHeaders(token),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        return (data['data'] as List)
            .map((json) => BlockedUser.fromJson(json))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load blocked users');
    }
  }

  /// Check if a specific user is blocked
  Future<bool> isUserBlocked(int userId) async {
    final token = await _getToken();
    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/chat/blocked-users/check/$userId/'),
        headers: _getHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_blocked'] ?? false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get count of blocked users
  Future<int> getBlockedUsersCount() async {
    try {
      final blockedUsers = await getBlockedUsers();
      return blockedUsers.length;
    } catch (e) {
      return 0;
    }
  }
}
