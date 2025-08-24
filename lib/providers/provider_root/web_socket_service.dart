// lib/services/websocket_service.dart

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

  Stream<Map<String, dynamic>> get messages => _messageController!.stream;
  bool get isConnected => _channel != null;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> connect(String endpoint) async {
    if (_isConnecting) return;

    try {
      _isConnecting = true;
      _currentEndpoint = endpoint;

      await disconnect();
      _messageController = StreamController<Map<String, dynamic>>.broadcast();

      final token = await _getToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse('$wsUrl/$endpoint?token=$token');
      print('🔥 WebSocket: Connecting to $uri');

      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = json.decode(data) as Map<String, dynamic>;
            print('🔥 WebSocket: Received: $decoded');
            _messageController!.add(decoded);
          } catch (e) {
            print('🚨 WebSocket: Decode error: $e');
          }
        },
        onError: (error) {
          print('🚨 WebSocket: Error: $error');
          _messageController!.addError(error);
        },
        onDone: () {
          print('🔥 WebSocket: Connection closed');
        },
      );

      _isConnecting = false;
    } catch (e) {
      _isConnecting = false;
      print('🚨 WebSocket: Connection error: $e');
      rethrow;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      try {
        final jsonMessage = json.encode(message);
        print('🔥 WebSocket: Sending: $jsonMessage');
        _channel!.sink.add(jsonMessage);
      } catch (e) {
        print('🚨 WebSocket: Send error: $e');
      }
    } else {
      print('🚨 WebSocket: Cannot send - not connected');
    }
  }

  Future<void> disconnect() async {
    if (_channel != null) {
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
    await _messageController?.close();
    _messageController = null;
  }
}

// Specific services for different endpoints
class ChatListWebSocketService extends WebSocketService {
  Future<void> connectToChatList() async {
    await connect('ws/chatrooms/');
  }
}

class ChatRoomWebSocketService extends WebSocketService {
  Future<void> connectToChatRoom(int roomId) async {
    await connect('ws/chat/$roomId/');
  }

  void sendChatMessage(String content) {
    sendMessage({
      'message': content,
    });
  }
}
