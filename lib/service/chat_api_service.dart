import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

/// 🔥 NEW: Thrown by [ChatApiService.startFromListing] when the backend
/// returns 400 — in practice this is the requester trying to chat about
/// their own listing (`ChatSelfChatError` guard in `chat/views.py`), so
/// callers should surface `l.chatSelfChatError` for it.
class SelfChatException implements Exception {
  final String message;
  SelfChatException(this.message);

  @override
  String toString() => message;
}

/// 🔥 NEW: Result of `POST /chats/<id>/transaction/` (Task 13 — seller
/// reserve/sold/available). `status` is the resulting listing status
/// ('reserved'/'sold'/'available'), derived from the request `action` since
/// the backend's success payload doesn't echo it back directly (it returns
/// `is_reserved`/`is_sold` flags instead). `unchanged` mirrors the backend's
/// idempotency guard (`{'status': 'unchanged'}` when the product is already
/// in the target state — no new system messages were created).
class TransactionResult {
  final String status;
  final bool unchanged;
  const TransactionResult({required this.status, required this.unchanged});
}

class ChatApiService {
  static const String apiBaseUrl = baseUrl;

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
      final request = http.MultipartRequest(
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
  // 🔥 NEW: Task 17 — [waveform] is up to 100 amplitude samples (ints
  // 0..100) captured while recording; sent as a JSON-encoded string under
  // the `metadata` field (DRF's JSONField parses a JSON string from
  // multipart form data the same way it would a JSON body), landing in
  // `Message.metadata = {'waveform': [...]}` for the playback bubble to
  // render a real waveform instead of a placeholder pattern.
  Future<ChatMessage> sendVoiceMessage(
      File audioFile, int roomId, int duration, {List<int>? waveform}) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Not authenticated');
    }

    try {
      final fileSize = await audioFile.length();
      final mimeType = lookupMimeType(audioFile.path) ?? 'audio/m4a';
      print('🎙️ [VoiceAPI] uploading — room:$roomId duration:${duration}s size:${fileSize}B mime:$mimeType path:${audioFile.path}');

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/chats/$roomId/messages/'),
      );

      request.headers['Authorization'] = 'Token $token';
      request.fields['message_type'] = 'voice';
      request.fields['duration'] = duration.toString();
      if (waveform != null && waveform.isNotEmpty) {
        request.fields['metadata'] = json.encode({'waveform': waveform});
      }

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

      print('🎙️ [VoiceAPI] response ${response.statusCode}: ${response.body}');

      if (response.statusCode == 201) {
        final decoded = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(decoded);
      } else {
        throw Exception('Failed to upload voice: ${response.statusCode} — ${response.body}');
      }
    } catch (e) {
      print('🔴 [VoiceAPI] error: $e');
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

  // 🔥 NEW: Listing-anchored chat (Karrot-style "Chat with seller") — starts
  // or fetches the existing room anchored to a product/service/property
  // listing via `POST /chats/start-from-listing/`.
  //
  // `listingId` is `dynamic` because product/service ids are ints while
  // property ids are UUID strings; the backend's `_resolve_listing` coerces
  // via `int(listing_id)` for product/service and `str(listing_id)` for
  // property, so either representation the caller already has on hand
  // (int or String) is forwarded as-is.
  Future<ChatRoom> startFromListing({
    required String listingType,
    required dynamic listingId,
  }) async {
    try {
      final headers = await _getHeaders(includeCharset: true);
      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/start-from-listing/'),
        headers: headers,
        body: json.encode({
          'listing_type': listingType,
          'listing_id': listingId,
        }),
        encoding: utf8,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return ChatRoom.fromJson(data['room'] as Map<String, dynamic>);
      } else if (response.statusCode == 400) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        // Backend (`StartChatFromListingView`) puts the message under
        // `error`, not `detail` -- fall back to `detail` in case that ever
        // changes upstream.
        final message =
            data is Map ? (data['error'] ?? data['detail'])?.toString() : null;
        // Only the self-chat case ("You cannot start a chat about your own
        // listing") should surface as SelfChatException -- other 400s (bad
        // listing_type, listing not found/inactive, etc.) should fall
        // through to the generic exception so callers don't show a
        // misleading self-chat snackbar for them.
        if (message != null && message.contains('own listing')) {
          throw SelfChatException(message);
        }
        throw Exception(message ?? 'Cannot start this chat');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      } else {
        throw Exception(
            'Failed to start chat from listing: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🔥 NEW: Seller reserve/sold/available action (Task 13). `action` is one
  // of 'reserve' | 'sold' | 'available' — mirrors `RoomTransactionView.ACTIONS`.
  Future<TransactionResult> updateTransactionStatus(
      int chatId, String action) async {
    try {
      final headers = await _getHeaders(includeCharset: true);
      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/transaction/'),
        headers: headers,
        body: json.encode({'action': action}),
        encoding: utf8,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final unchanged = data is Map && data['status'] == 'unchanged';
        // Mirrors `RoomTransactionView.post`'s
        // `listing_status = 'reserved' if action == 'reserve' else action`.
        final newStatus = action == 'reserve' ? 'reserved' : action;
        return TransactionResult(status: newStatus, unchanged: unchanged);
      } else if (response.statusCode == 403) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final message =
            data is Map ? data['error']?.toString() : null;
        throw Exception(
            message ?? 'Only the seller can update this listing status');
      } else if (response.statusCode == 400) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final message = data is Map ? data['error']?.toString() : null;
        throw Exception(message ?? 'Cannot update this listing status');
      } else {
        throw Exception(
            'Failed to update transaction status: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // KARROT STYLE: Get or create direct chat
  Future<ChatRoom> getOrCreateDirectChat(int targetUserId) async {
    try {
      print('🔍 [ChatAPI] getOrCreateDirectChat called for userId: $targetUserId');
      final headers = await _getHeaders();
      print('🔍 [ChatAPI] Making POST to: $apiBaseUrl/chats/direct/');

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/direct/'),
        headers: headers,
        body: json.encode({'target_user_id': targetUserId}),
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        print('❌ [ChatAPI] getOrCreateDirectChat timed out');
        throw Exception('Request timed out');
      });

      print('🔍 [ChatAPI] getOrCreateDirectChat response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        print('✅ [ChatAPI] getOrCreateDirectChat success');
        return ChatRoom.fromJson(data['chat']);
      } else if (response.statusCode == 401) {
        print('❌ [ChatAPI] Authentication failed');
        throw Exception('Authentication failed');
      } else {
        final error = json.decode(response.body);
        print('❌ [ChatAPI] getOrCreateDirectChat failed: ${error['error']}');
        throw Exception(error['error'] ?? 'Failed to create chat');
      }
    } catch (e) {
      print('❌ [ChatAPI] getOrCreateDirectChat error: $e');
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
        final usersList = (data is List) ? data : (data['results'] ?? []);

        // 🔍 Debug: Log online status for each user
        for (var u in usersList) {
          print('👤 [Users] ${u['username']}: is_online=${u['is_online']}, last_seen=${u['last_seen']}');
        }

        return (usersList as List).map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('❌ [Users] Error loading users: $e');
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
      print('🔍 [ChatAPI] startChatWithUser called for userId: $userId');
      final headers = await _getHeaders();
      print('🔍 [ChatAPI] Headers ready, making request to: $apiBaseUrl/chats/start/$userId/');

      final response = await http.get(
        Uri.parse('$apiBaseUrl/chats/start/$userId/'),
        headers: headers,
      ).timeout(const Duration(seconds: 30), onTimeout: () {
        print('❌ [ChatAPI] Request timed out after 30 seconds');
        throw Exception('Request timed out');
      });

      print('🔍 [ChatAPI] Response status: ${response.statusCode}');

      // 🔥 Accept both 200 (OK) and 201 (Created) as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        print('✅ [ChatAPI] startChatWithUser success');
        return data as Map<String, dynamic>;
      } else {
        print('❌ [ChatAPI] startChatWithUser failed: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to start chat: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [ChatAPI] startChatWithUser error: $e');
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
        // 🔥 NEW: Task 15 — surface the backend's `detail` message (e.g. the
        // 403 raised once the sender-only 15-minute edit window has
        // expired) instead of a generic status-code string, so the UI can
        // show it directly in a snackbar.
        throw Exception(_extractErrorDetail(response, 'Failed to edit message'));
      }
    } catch (e) {

      rethrow;
    }
  }

  /// 🔥 NEW: Task 15 — best-effort extraction of a human-readable error
  /// message from a non-2xx JSON body (DRF-style `{"detail": "..."}` or
  /// `{"error": "..."}`), falling back to `$fallback: <status code>`.
  String _extractErrorDetail(http.Response response, String fallback) {
    try {
      final data = json.decode(utf8.decode(response.bodyBytes));
      if (data is Map) {
        final detail = data['detail'] ?? data['error'] ?? data['message'];
        if (detail != null) return detail.toString();
      }
    } catch (_) {
      // Body wasn't JSON (or was empty) — fall through to the generic message.
    }
    return '$fallback: ${response.statusCode}';
  }

  // 🔥 NEW: Delete message. [mode] is 'for_me' (removes the message only
  // for the calling user/account) or 'for_everyone' (own messages only —
  // blanks it for all participants via the backend + `message_deleted` WS
  // relay).
  Future<void> deleteMessage(
    int chatId,
    int messageId, {
    String mode = 'for_me',
  }) async {
    try {
      final headers = await _getHeaders();

      final response = await http.delete(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/?mode=$mode'),
        headers: headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception(_extractErrorDetail(response, 'Failed to delete message'));
      }
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Task 16 — toggle pin state for a message. Returns the resulting
  // `is_pinned` flag from `POST /chats/<chat_id>/messages/<id>/pin/`.
  Future<bool> togglePinMessage(int chatId, int messageId) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/pin/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data is Map ? (data['is_pinned'] as bool? ?? false) : false;
      } else {
        throw Exception(_extractErrorDetail(response, 'Failed to toggle pin'));
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🔥 NEW: Task 16 — forward a message to another room via
  // `POST /chats/<chat_id>/messages/<id>/forward/`. Returns the newly
  // created message (broadcast to the target room over its own WS).
  Future<ChatMessage> forwardMessage(
    int chatId,
    int messageId,
    int targetRoomId,
  ) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/$chatId/messages/$messageId/forward/'),
        headers: headers,
        body: json.encode({'target_room_id': targetRoomId}),
        encoding: utf8,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return ChatMessage.fromJson(data);
      } else {
        throw Exception(_extractErrorDetail(response, 'Failed to forward message'));
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
        final Map<String, List<int>> reactions = {};
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

  // 🔥 NEW: Task 18 — translate a message's text content into [target]
  // (BCP-47-ish language code, e.g. 'en'/'ru'/'uz'). Backend caches per
  // (message, target) so repeat calls are cheap. Surfaces the backend's
  // `detail` message (503 "Translation not configured.", 502 provider
  // failure, 400 bad target/empty/deleted/non-text) via the thrown
  // Exception's message so callers can decide how to present it.
  Future<String> translateMessage(int messageId, String target) async {
    try {
      final headers = await _getHeaders(includeCharset: true);

      final response = await http.post(
        Uri.parse('$apiBaseUrl/chats/messages/$messageId/translate/'),
        headers: headers,
        body: json.encode({'target': target}),
        encoding: utf8,
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        return data['translated_text'] as String;
      } else {
        throw Exception(_extractErrorDetail(response, 'Failed to translate message'));
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🔥 NEW: Task 18 — in-room message search via
  // `GET /chats/<chat_id>/search/?q=`. Returns the raw decoded response
  // ({results, query, page, page_size, total_count, has_more}) so the
  // caller can both list matches and show the server's total count.
  Future<Map<String, dynamic>> searchMessagesInChat(
    int chatId,
    String query, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      final uri = Uri.parse('$apiBaseUrl/chats/$chatId/search/').replace(
        queryParameters: {
          'q': query,
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      } else {
        throw Exception(_extractErrorDetail(response, 'Failed to search messages'));
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
