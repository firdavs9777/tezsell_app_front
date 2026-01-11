import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ChatApiService {
  static const String apiBaseUrl = '$baseUrl';

  // Get auth token
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<ChatMessage> sendImageMessage(File imageFile, int roomId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/chats/$roomId/messages/'),
      );

      // Add headers
      request.headers['Authorization'] = 'Token $token';

      // Add message type
      request.fields['message_type'] = 'image';

      // Add image file
      final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
      final mimeTypeData = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(decoded);
      } else {

        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Upload voice message
  Future<ChatMessage> sendVoiceMessage(
      File audioFile, int roomId, int duration) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/chats/$roomId/messages/'),
      );

      // Add headers
      request.headers['Authorization'] = 'Token $token';

      // Add message type and duration
      request.fields['message_type'] = 'voice';
      request.fields['duration'] = duration.toString();

      // Add audio file
      final mimeType = lookupMimeType(audioFile.path) ?? 'audio/m4a';
      final mimeTypeData = mimeType.split('/');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFile.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(decoded);
      } else {

        throw Exception('Failed to upload voice: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // Check authentication
  Future<bool> isAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Get headers with auth
  Future<Map<String, String>> _getHeaders({bool includeCharset = false}) async {
    final token = await _getToken();
    return {
      'Content-Type': includeCharset
          ? 'application/json; charset=utf-8'
          : 'application/json',
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

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return ChatRoom.fromJson(data);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['error'] ?? 'Failed to create chat room');
      }
    } catch (e) {

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

      rethrow;
    }
  }

  // Get messages for a chat room
  Future<List<ChatMessage>> getChatMessages(int roomId,
      {int page = 1, int pageSize = 50}) async {
    try {
      final headers = await _getHeaders();
      final uri =
          Uri.parse('$apiBaseUrl/chats/$roomId/').replace(queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      });

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        // Handle paginated response
        if (data is Map && data.containsKey('messages')) {
          final messages = data['messages'] as List;
          return messages.map((json) => ChatMessage.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('results')) {
          // Paginated response with results
          final messages = data['results'] as List;
          return messages.map((json) => ChatMessage.fromJson(json)).toList();
        } else if (data is List) {
          // Direct list response
          return data.map((json) => ChatMessage.fromJson(json)).toList();
        } else {

          return [];
        }
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Get paginated messages (returns messages and pagination info)
  Future<Map<String, dynamic>> getChatMessagesPaginated(int roomId,
      {int page = 1, int pageSize = 50}) async {
    try {
      final headers = await _getHeaders();
      final uri =
          Uri.parse('$apiBaseUrl/chats/$roomId/').replace(queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      });

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        List<ChatMessage> messages = [];
        bool hasNext = false;
        int? nextPage;
        int? totalCount;

        // Handle different response formats
        if (data is Map) {
          if (data.containsKey('messages')) {
            // Format: {"messages": [...]}
            final messagesList = data['messages'] as List?;
            messages = messagesList
                    ?.map((json) => ChatMessage.fromJson(json))
                    .toList() ??
                [];
          } else if (data.containsKey('results')) {
            // Paginated format: {"results": [...], "next": "...", "count": 123}
            final results = data['results'] as List;
            messages =
                results.map((json) => ChatMessage.fromJson(json)).toList();
            hasNext = data['next'] != null;
            if (hasNext && data['next'] is String) {
              final nextUrl = data['next'] as String;
              final nextUri = Uri.parse(nextUrl);
              nextPage = int.tryParse(nextUri.queryParameters['page'] ?? '');
            }
            totalCount = data['count'] as int?;
          }
        } else if (data is List) {
          // Direct list
          messages = data.map((json) => ChatMessage.fromJson(json)).toList();
        }

        return {
          'messages': messages,
          'hasNext': hasNext,
          'nextPage': nextPage,
          'totalCount': totalCount,
        };
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {

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

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // Handle both paginated and non-paginated responses
        final users = (data is List) ? data : (data['results'] ?? []);
        return (users as List).map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {

      return [];
    }
  }

  // 🔥 NEW: Search users (KakaoTalk-style)
  Future<List<Map<String, dynamic>>> searchUsers(
      {String? query, int? userId}) async {
    try {
      final headers = await _getHeaders();

      final uri = Uri.parse('$apiBaseUrl/chats/search-users/').replace(
        queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query,
          if (userId != null) 'user_id': userId.toString(),
        },
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        
        // 🔥 Handle different response formats
        if (data is List) {
          // Direct list response
          return data.cast<Map<String, dynamic>>();
        } else if (data is Map) {
          // Check for 'users' key (backend format)
          if (data.containsKey('users') && data['users'] is List) {
            return (data['users'] as List).cast<Map<String, dynamic>>();
          }
          // Check for 'results' key (alternative format)
          else if (data.containsKey('results') && data['results'] is List) {
            return (data['results'] as List).cast<Map<String, dynamic>>();
          }
        }
        return [];
      } else {
        throw Exception('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Start chat with user by ID (KakaoTalk-style)
  Future<Map<String, dynamic>> startChatWithUser(int userId) async {
    try {
      final headers = await _getHeaders();
      
      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/start/$userId/'),
        headers: headers,
      );

      // 🔥 Accept both 200 (OK) and 201 (Created) as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to start chat: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Send message with reply
  Future<ChatMessage> sendMessageWithReply(
      int chatId, String content, int? replyToMessageId) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final body = <String, dynamic>{
        'content': content,
        'message_type': 'text',
        'delivery_status': 'sent',  // Backend requires this field (NOT NULL constraint)
      };

      if (replyToMessageId != null) {
        body['reply_to'] = replyToMessageId;
      }

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/'),
        headers: headers,
        body: json.encode(body),
        encoding: utf8,
      );

      if (response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(data);
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Edit message
  Future<ChatMessage> editMessage(
      int chatId, int messageId, String newContent) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.put(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/'),
        headers: headers,
        body: json.encode({'content': newContent}),
        encoding: utf8,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(data);
      } else {
        throw Exception('Failed to edit message: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Delete message (soft delete)
  Future<void> deleteMessage(int chatId, int messageId) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete message: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Add/remove reaction
  Future<Map<String, List<int>>> toggleReaction(
      int chatId, int messageId, String emoji) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/reaction/'),
        headers: headers,
        body: json.encode({'emoji': emoji}),
        encoding: utf8,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // Parse reactions: {"👍": [1, 2], "❤️": [3]}
        Map<String, List<int>> reactions = {};
        if (data['reactions'] != null && data['reactions'] is Map) {
          final reactionsData = data['reactions'] as Map<String, dynamic>;
          reactionsData.forEach((emoji, userIds) {
            if (userIds is List) {
              reactions[emoji] = userIds.map((id) => id as int).toList();
            }
          });
        }
        return reactions;
      } else {
        throw Exception('Failed to toggle reaction: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Block user
  Future<void> blockUser(int userId) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/block/'),
        headers: headers,
        body: json.encode({'user_id': userId}),
        encoding: utf8,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to block user: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Unblock user
  Future<void> unblockUser(int userId) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      // http.delete doesn't support body, so use Request directly
      final request =
          http.Request('DELETE', Uri.parse('$apiBaseUrl/chats/block/'));
      request.headers.addAll(headers);
      request.body = json.encode({'user_id': userId});

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to unblock user: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Get blocked users list
  Future<List<User>> getBlockedUsers() async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/blocked/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data is List) {
          return data.map((item) {
            final blockedUser = item['blocked_user'] as Map<String, dynamic>;
            return User.fromJson(blockedUser);
          }).toList();
        }
        return [];
      } else {
        throw Exception('Failed to get blocked users: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Initiate call
  Future<Map<String, dynamic>> initiateCall(int chatId, String callType) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/call/'),
        headers: headers,
        body: json.encode({'call_type': callType}), // 'voice' or 'video'
        encoding: utf8,
      );

      if (response.statusCode == 201) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to initiate call: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Answer/reject/end call
  Future<Map<String, dynamic>> updateCall(
      int chatId, int callId, String action) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.put(
        Uri.parse('$apiBaseUrl/chats/$chatId/call/$callId/'),
        headers: headers,
        body: json.encode({'action': action}), // 'answer', 'reject', or 'end'
        encoding: utf8,
      );

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to update call: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Get call history
  Future<List<Map<String, dynamic>>> getCallHistory(int chatId) async {
    try {
      final headers = await _getHeaders();

      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/$chatId/calls/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        }
        return [];
      } else {
        throw Exception('Failed to get call history: ${response.statusCode}');
      }
    } catch (e) {

      rethrow;
    }
  }
}
