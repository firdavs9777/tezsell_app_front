// lib/services/chat_api_service.dart

import 'dart:convert';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart'; // Your existing constants

class ChatApiService {
  // Use your existing baseUrl from constants
  static const String chatBasePath = '/chats'; // Path for chat endpoints

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Using your existing token key
  }

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Using your existing userId key
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'User-Agent': 'FlutterApp/1.0',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  // Chat Rooms
  Future<List<ChatRoom>> getChatRooms() async {
    try {
      final headers = await _getHeaders();

      print('🔥 API: Fetching chat rooms from $baseUrl$chatBasePath/');
      print('🔥 API: Headers: $headers');

      final response = await http.get(
        Uri.parse('$baseUrl$chatBasePath/'),
        headers: headers,
      );

      print('🔥 API: Chat rooms response ${response.statusCode}');
      print('🔥 API: Chat rooms body ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle paginated response
        final results = data['results'] ?? data;

        if (results is List) {
          return results.map((room) => ChatRoom.fromJson(room)).toList();
        } else {
          print('🚨 API: Unexpected response format');
          return [];
        }
      } else if (response.statusCode == 401) {
        print('🚨 API: Authentication failed - token might be expired');
        throw Exception('Authentication failed');
      } else {
        print('🚨 API: Failed to load chat rooms: ${response.statusCode}');
        throw Exception('Failed to load chat rooms: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 API: Get chat rooms error: $e');
      rethrow;
    }
  }

  Future<ChatRoom> createChatRoom(String name, List<int> participantIds) async {
    try {
      final headers = await _getHeaders();
      final currentUserId = await _getUserId();

      // Ensure current user is included in participants
      if (currentUserId != null) {
        final userIdInt = int.tryParse(currentUserId);
        if (userIdInt != null && !participantIds.contains(userIdInt)) {
          participantIds.add(userIdInt);
        }
      }

      print(
          '🔥 API: Creating chat room: $name with participants: $participantIds');

      final response = await http.post(
        Uri.parse('$baseUrl$chatBasePath/'),
        headers: headers,
        body: json.encode({
          'name': name,
          'participants': participantIds,
        }),
      );

      print('🔥 API: Create chat response ${response.statusCode}');
      print('🔥 API: Create chat body ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatRoom.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        print('🚨 API: Create chat error: $errorData');
        throw Exception(errorData['error'] ??
            errorData['detail'] ??
            'Failed to create chat room');
      }
    } catch (e) {
      print('🚨 API: Create chat room error: $e');
      rethrow;
    }
  }

  Future<void> deleteChatRoom(int chatId) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$baseUrl$chatBasePath/$chatId/'),
        headers: headers,
      );

      print('🔥 API: Delete chat response ${response.statusCode}');

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Failed to delete chat room: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 API: Delete chat room error: $e');
      rethrow;
    }
  }

  // Messages
  Future<List<ChatMessage>> getChatMessages(int chatId) async {
    try {
      final headers = await _getHeaders();

      print('🔥 API: Fetching messages for chat $chatId');

      final response = await http.get(
        Uri.parse('$baseUrl$chatBasePath/$chatId/messages/'),
        headers: headers,
      );

      print('🔥 API: Messages response ${response.statusCode}');
      print('🔥 API: Messages body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          return data.map((msg) => ChatMessage.fromJson(msg)).toList();
        } else {
          print('🚨 API: Messages response is not a list: $data');
          return [];
        }
      } else {
        print(
            '🚨 API: Failed to load messages: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 API: Get messages error: $e');
      rethrow;
    }
  }

  Future<ChatMessage> sendMessage(int chatId, String content) async {
    try {
      final headers = await _getHeaders();

      print('🔥 API: Sending message to chat $chatId: $content');

      final response = await http.post(
        Uri.parse('$baseUrl$chatBasePath/$chatId/messages/'),
        headers: headers,
        body: json.encode({'content': content}),
      );

      print('🔥 API: Send message response ${response.statusCode}');
      print('🔥 API: Send message body ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatMessage.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        print('🚨 API: Send message error: $errorData');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 API: Send message error: $e');
      rethrow;
    }
  }

  // Chat Detail (for getting chat with messages)
  Future<Map<String, dynamic>> getChatDetail(int chatId) async {
    try {
      final headers = await _getHeaders();

      print('🔥 API: Fetching chat detail for $chatId');

      final response = await http.get(
        Uri.parse('$baseUrl$chatBasePath/$chatId/'),
        headers: headers,
      );

      print('🔥 API: Chat detail response ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('🔥 API: Chat detail success');
        return data;
      } else {
        print(
            '🚨 API: Failed to load chat detail: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load chat detail: ${response.statusCode}');
      }
    } catch (e) {
      print('🚨 API: Get chat detail error: $e');
      rethrow;
    }
  }

  // Get users (for participant selection)
  Future<List<User>> getUsers() async {
    try {
      final headers = await _getHeaders();

      // Try different possible user endpoints
      final possibleEndpoints = [
        '$baseUrl/accounts/users/',
        '$baseUrl/api/users/',
        '$baseUrl/users/',
      ];

      for (final endpoint in possibleEndpoints) {
        try {
          print('🔥 API: Trying users endpoint: $endpoint');

          final response = await http.get(
            Uri.parse(endpoint),
            headers: headers,
          );

          print('🔥 API: Users response ${response.statusCode} from $endpoint');

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final results = data['results'] ?? data;

            if (results is List) {
              print('🔥 API: Found ${results.length} users from $endpoint');
              return results.map((user) => User.fromJson(user)).toList();
            }
          }
        } catch (e) {
          print('🚨 API: Failed to get users from $endpoint: $e');
          continue; // Try next endpoint
        }
      }

      print('🚨 API: No working user endpoint found');
      return [];
    } catch (e) {
      print('🚨 API: Get users error: $e');
      return [];
    }
  }

  // Check authentication status
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Get current user info
  Future<Map<String, String?>> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'token': prefs.getString('token'),
      'userId': prefs.getString('userId'),
      'userLocation': prefs.getString('userLocation'),
    };
  }
}
