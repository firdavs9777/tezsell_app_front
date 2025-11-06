import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatApiService {
  static const String apiBaseUrl = '$baseUrl';

  // Get auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Check authentication
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Get headers with auth
  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  // Get all chat rooms
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/'),
        headers: headers,
      );

      print('🔥 getChatRooms response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        return results.map((json) => ChatRoom.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      } else {
        throw Exception('Failed to load chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 getChatRooms error: $e');
      rethrow;
    }
  }

  // KARROT STYLE: Get or create direct chat
  Future<ChatRoom> getOrCreateDirectChat(int targetUserId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/direct/'),
        headers: headers,
        body: json.encode({'target_user_id': targetUserId}),
      );

      print('🔥 getOrCreateDirectChat response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatRoom.fromJson(data['chat']);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to create chat');
      }
    } catch (e) {
      print('🚨 getOrCreateDirectChat error: $e');
      rethrow;
    }
  }

  // Create group chat
  Future<ChatRoom> createChatRoom(String name, List<int> participantIds) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/'),
        headers: headers,
        body: json.encode({
          'name': name,
          'participants': participantIds,
        }),
      );

      print('🔥 createChatRoom response: ${response.statusCode}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatRoom.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to create chat room');
      }
    } catch (e) {
      print('🚨 createChatRoom error: $e');
      rethrow;
    }
  }

  // Delete chat room
  Future<void> deleteChatRoom(int chatId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$apiBaseUrl/chats/$chatId/'),
        headers: headers,
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete chat room');
      }
    } catch (e) {
      print('🚨 deleteChatRoom error: $e');
      rethrow;
    }
  }

  // Get messages for a chat room
  Future<List<ChatMessage>> getChatMessages(int roomId) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/$roomId/'),
        headers: headers,
      );

      print('🔥 getChatMessages response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final messages = data['messages'] as List;
        return messages.map((json) => ChatMessage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load messages');
      }
    } catch (e) {
      print('🚨 getChatMessages error: $e');
      rethrow;
    }
  }

  // Get all users (for creating chats)
  Future<List<User>> getUsers() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$apiBaseUrl/users/'),
        headers: headers,
      );

      print('🔥 getUsers response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle both paginated and non-paginated responses
        final users = (data is List) ? data : (data['results'] ?? []);
        return (users as List).map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('🚨 getUsers error: $e');
      return [];
    }
  }
}
