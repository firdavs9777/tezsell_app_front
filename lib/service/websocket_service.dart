import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListWebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  // TODO: Replace with your backend WebSocket URL
  static const String wsUrl = 'ws://127.0.0.1:8000/ws/chatlist';

  Future<void> connectToChatList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print(wsUrl);
      print(token);
      final uri = Uri.parse('$wsUrl?token=$token');
      _channel = WebSocketChannel.connect(uri);

      print('🔥 Connecting to chat list WebSocket: $wsUrl');

      _channel!.stream.listen(
        (data) {
          try {
            final message = json.decode(data);
            print('🔥 Chat list WS received: ${message['type']}');
            _messageController.add(message);
          } catch (e) {
            print('🚨 Error parsing chat list message: $e');
          }
        },
        onError: (error) {
          print('🚨 Chat list WebSocket error: $error');
        },
        onDone: () {
          print('🔥 Chat list WebSocket closed');
        },
      );
    } catch (e) {
      print('🚨 Error connecting to chat list WebSocket: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
    print('🔥 Chat list WebSocket disconnected');
  }

  void dispose() {
    disconnect();
    _messageController.close();
  }
}

class ChatRoomWebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;
  bool _isConnecting = false;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 3;
  final Completer<void> _connectionCompleter = Completer<void>();

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  Future<void> get ready => _connectionCompleter.future;

  static const String wsBaseUrl = 'ws://127.0.0.1:8000';

  Future<void> connectToChatRoom(int roomId) async {
    if (_isConnecting) {
      print('⏳ Already connecting to chat room');
      return ready;
    }

    try {
      _isConnecting = true;

      // Close existing connection if any
      await disconnect();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final wsUrl = 'ws://127.0.0.1:8000/ws/chat/$roomId/?token=$token';
      final uri = Uri.parse(wsUrl);

      print('🔥 Connecting to chat room $roomId WebSocket: $wsUrl');

      print('🔍 WS URL Final: $wsUrl');
      print('🔍 Parsed URI: $uri');
      _channel = WebSocketChannel.connect(uri);
      _reconnectAttempts = 0;

      // Set up stream listener
      _channel!.stream.listen(
        (data) {
          try {
            final message = json.decode(data);
            print('📨 Chat room WS received: ${message['type']}');

            // Mark as connected when we get connection_established
            if (message['type'] == 'connection_established') {
              _isConnected = true;
              _isConnecting = false;
              if (!_connectionCompleter.isCompleted) {
                _connectionCompleter.complete();
              }
              print('✅ Connection established');
            }

            if (!_messageController.isClosed) {
              _messageController.add(message);
            }
          } catch (e) {
            print('🚨 Error parsing chat room message: $e');
          }
        },
        onError: (error) {
          print('🚨 Chat room WebSocket error: $error');
          _isConnected = false;
          _isConnecting = false;
          if (!_connectionCompleter.isCompleted) {
            _connectionCompleter.completeError(error);
          }
          _attemptReconnect(roomId);
        },
        onDone: () {
          print('🔥 Chat room WebSocket closed');
          _isConnected = false;
          _isConnecting = false;
        },
        cancelOnError: false,
      );

      // Wait for connection or timeout
      await ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⏱️ Connection timeout, assuming connected');
          _isConnected = true;
          _isConnecting = false;
        },
      );

      print('✅ Connected to chat room $roomId');
    } catch (e) {
      print('🚨 Error connecting to chat room WebSocket: $e');
      _isConnected = false;
      _isConnecting = false;
      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.completeError(e);
      }
      _attemptReconnect(roomId);
      rethrow;
    }
  }

  void _attemptReconnect(int roomId) {
    if (_reconnectAttempts >= maxReconnectAttempts) {
      print('🚨 Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    final delay = Duration(seconds: _reconnectAttempts * 2);
    print(
        '🔄 Attempting to reconnect in ${delay.inSeconds} seconds (attempt $_reconnectAttempts)');

    _reconnectTimer = Timer(delay, () {
      connectToChatRoom(roomId);
    });
  }

  void sendChatMessage(String content) {
    if (!_isConnected || _channel == null) {
      print(
          '🚨 Cannot send message - WebSocket not connected (connected: $_isConnected, channel: ${_channel != null})');
      return;
    }

    try {
      final message = json.encode({
        'message': content,
      });

      _channel!.sink.add(message);
      print('📤 Sent message: $content');
    } catch (e) {
      print('🚨 Error sending message: $e');
      _isConnected = false;
    }
  }

  void sendTypingStatus(bool isTyping) {
    if (!_isConnected || _channel == null) {
      return;
    }

    try {
      final message = json.encode({
        'type': 'typing',
        'is_typing': isTyping,
      });

      _channel!.sink.add(message);
    } catch (e) {
      print('🚨 Error sending typing status: $e');
    }
  }

  Future<void> disconnect() async {
    print('🔥 Disconnecting chat room WebSocket');

    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempts = 0;
    _isConnected = false;
    _isConnecting = false;

    try {
      await _channel?.sink.close();
      _channel = null;
    } catch (e) {
      print('🚨 Error closing chat room WebSocket: $e');
    }
  }

  void dispose() {
    disconnect();
    if (!_messageController.isClosed) {
      _messageController.close();
    }
  }
}
