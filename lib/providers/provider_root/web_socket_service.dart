import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:shared_preferences/shared_preferences.dart';

class WebSocketService {
  static const String wsUrl = 'wss://api.webtezsell.com';

  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _messageController;
  String? _currentEndpoint;
  bool _isConnecting = false;
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get messages => _messageController!.stream;
  bool get isConnected => _isConnected;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token;
  }

  Future<void> connect(String endpoint) async {
    if (_isConnecting) {
      return;
    }

    try {
      _isConnecting = true;
      _currentEndpoint = endpoint;

      await disconnect();
      _messageController = StreamController<Map<String, dynamic>>.broadcast();

      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final wsUrlWithEndpoint = '$wsUrl/$endpoint?token=$token';

      final uri = Uri.parse(wsUrlWithEndpoint);

      _channel = WebSocketChannel.connect(uri);
      _isConnected = true;

      _channel!.stream.listen(
        (data) {

          try {
            // 🔥 CRITICAL: Handle UTF-8 encoding properly
            String jsonString;

            if (data is String) {
              // Data is already a string
              jsonString = data;
            } else if (data is List<int>) {
              // Data is bytes - decode as UTF-8
              jsonString = utf8.decode(data, allowMalformed: false);
            } else {
              // Fallback to toString
              jsonString = data.toString();
            }

            final decoded = json.decode(jsonString) as Map<String, dynamic>;

            // Extra debugging for chatroom_list messages
            if (decoded['type'] == 'chatroom_list') {
              final chatrooms = decoded['chatrooms'];
              if (chatrooms != null && chatrooms.isNotEmpty) {

                final firstRoom = chatrooms[0] as Map<String, dynamic>;

                // 🔥 Check last_message content encoding
                if (firstRoom.containsKey('last_message')) {
                  final lastMsg = firstRoom['last_message'];

                  if (lastMsg is Map && lastMsg.containsKey('content')) {
                    final content = lastMsg['content'];
                  }
                } else if (firstRoom.containsKey('last_message_preview')) {
                }
              }
            }

            // 🔥 Check for chat messages
            if (decoded['type'] == 'message' ||
                decoded['type'] == 'chat_message') {
              final content = decoded['content'] ?? decoded['message'];
              if (content != null) {
              }
            }

            _messageController!.add(decoded);
          } catch (e, stackTrace) {
          }
        },
        onError: (error) {
          _isConnected = false;
          _messageController!.addError(error);
        },
        onDone: () {
          _isConnected = false;
        },
      );

      // Wait a moment to ensure connection is established
      await Future.delayed(const Duration(milliseconds: 500));

      _isConnecting = false;
    } catch (e, stackTrace) {
      _isConnecting = false;
      _isConnected = false;
      rethrow;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null && _isConnected) {
      try {
        // 🔥 json.encode automatically handles UTF-8 encoding
        final jsonMessage = json.encode(message);

        // 🔥 Check if message contains Korean characters
        if (message.containsKey('message') || message.containsKey('content')) {
          final content = message['message'] ?? message['content'];
        }

        _channel!.sink.add(jsonMessage);
      } catch (e) {
      }
    } else {
    }
  }

  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close(status.goingAway);
      _channel = null;
      _isConnected = false;
    }
    await _messageController?.close();
    _messageController = null;
  }
}

// Specific services for different endpoints
class ChatListWebSocketService extends WebSocketService {
  Future<void> connectToChatList() async {
    await connect('ws/chatlist/');
  }

  void requestListRefresh() {
    sendMessage({
      'type': 'request_list',
    });
  }
}

class ChatRoomWebSocketService extends WebSocketService {
  Future<void> connectToChatRoom(int roomId) async {
    await connect('ws/chat/$roomId/');
  }

  void sendChatMessage(String content) {

    // 🔥 FIX: Backend expects "type": "message" field according to documentation
    // Format: {"type": "message", "message": "content"}
    sendMessage({
      'type': 'message',
      'message': content,
    });
  }

  void sendTypingStatus(bool isTyping) {
    sendMessage({
      'type': 'typing',
      'is_typing': isTyping,
    });
  }
}
