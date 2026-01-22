import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListWebSocketService {
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  static const String wsUrl = 'wss://api.webtezsell.com/ws/chatlist';

  bool get isConnected => _isConnected && _channel != null;

  Future<void> connectToChatList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      final uri = Uri.parse('$wsUrl?token=$token');
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (data) {
          try {
            final message = json.decode(data);

            // Mark as connected when we get connection_established
            if (message['type'] == 'connection_established') {
              _isConnected = true;
            }
            
            _messageController.add(message);
          } catch (e) {

          }
        },
        onError: (error) {

          _isConnected = false;
        },
        onDone: () {

          _isConnected = false;
        },
      );
      
      // Mark as connected after a short delay (connection is established)
      Future.delayed(const Duration(milliseconds: 500), () {
        _isConnected = true;
      });
    } catch (e) {

      rethrow;
    }
  }

  // 🔥 NEW: Request list refresh
  void requestListRefresh() {
    if (!isConnected || _channel == null) {

      return;
    }
    
    try {
      final message = json.encode({
        'type': 'request_list',
      });
      _channel!.sink.add(message);

    } catch (e) {

    }
  }

  Future<void> disconnect() async {
    _isConnected = false;
    await _channel?.sink.close();
    _channel = null;

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
  // Fixed: Completer is now recreated for each connection attempt
  Completer<void>? _connectionCompleter;

  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  bool get isConnected => _isConnected;
  bool get isConnecting => _isConnecting;
  Future<void> get ready => _connectionCompleter?.future ?? Future.value();

  static const String wsBaseUrl = 'wss://api.webtezsell.com';

  Future<void> connectToChatRoom(int roomId) async {
    print('🔌 connectToChatRoom called for room $roomId');
    print('🔌 _isConnecting: $_isConnecting, _isConnected: $_isConnected');

    if (_isConnecting) {
      print('🔌 Already connecting, waiting for ready...');
      return ready;
    }

    try {
      _isConnecting = true;

      // Create a new completer for this connection attempt
      _connectionCompleter = Completer<void>();

      // Close existing connection if any
      await disconnect();

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        print('❌ No authentication token found');
        throw Exception('No authentication token found');
      }

      final wsUrl = 'wss://api.webtezsell.com/ws/chat/$roomId/?token=$token';
      print('🔌 Connecting to WebSocket: $wsUrl');
      final uri = Uri.parse(wsUrl);

      _channel = WebSocketChannel.connect(uri);
      _reconnectAttempts = 0;

      // Set up stream listener
      _channel!.stream.listen(
        (data) {
          try {
            print('📨 WebSocket received data: $data');
            final message = json.decode(data);

            // Mark as connected when we get connection_established
            if (message['type'] == 'connection_established') {
              print('✅ Connection established message received!');
              _isConnected = true;
              _isConnecting = false;
              if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
                _connectionCompleter!.complete();
              }
            }

            if (!_messageController.isClosed) {
              _messageController.add(message);
            }
          } catch (e) {
            print('❌ Error parsing WebSocket data: $e');
          }
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          _isConnected = false;
          _isConnecting = false;
          if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
            _connectionCompleter!.completeError(error);
          }
          _attemptReconnect(roomId);
        },
        onDone: () {
          print('🔌 WebSocket stream done (closed)');
          _isConnected = false;
          _isConnecting = false;
        },
        cancelOnError: false,
      );

      // Wait for connection or timeout
      print('🔌 Waiting for connection_established or timeout...');
      await ready.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          print('⏱️ Connection timeout - setting _isConnected = true anyway');
          _isConnected = true;
          _isConnecting = false;
        },
      );

      print('🔌 Connection complete. _isConnected: $_isConnected');

    } catch (e) {
      print('❌ Connection error: $e');
      _isConnected = false;
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(e);
      }
      _attemptReconnect(roomId);
      rethrow;
    }
  }

  void _attemptReconnect(int roomId) {
    if (_reconnectAttempts >= maxReconnectAttempts) {

      return;
    }

    _reconnectTimer?.cancel();
    _reconnectAttempts++;

    final delay = Duration(seconds: _reconnectAttempts * 2);

    _reconnectTimer = Timer(delay, () {
      connectToChatRoom(roomId);
    });
  }

  void sendChatMessage(String content) {
    print('📤 sendChatMessage called with: "$content"');
    print('📤 _isConnected: $_isConnected, _channel: ${_channel != null ? "exists" : "null"}');

    if (!_isConnected || _channel == null) {
      print('❌ Cannot send message: not connected or channel is null');
      return;
    }

    try {
      // 🔥 FIX: Backend expects "type": "message" field according to documentation
      // Format: {"type": "message", "message": "content"}
      // Also include delivery_status as backend requires it (NOT NULL constraint)
      final message = json.encode({
        'type': 'message',
        'message': content,
        'delivery_status': 'sent',  // Backend requires this field
      });

      print('📤 Sending WebSocket message: $message');
      // 🔥 Ensure UTF-8 encoding when sending
      _channel!.sink.add(message);
      print('✅ Message sent to WebSocket');

    } catch (e) {
      print('❌ Error sending message: $e');
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

    }
  }

  Future<void> disconnect() async {

    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempts = 0;
    _isConnected = false;
    _isConnecting = false;

    try {
      await _channel?.sink.close();
      _channel = null;
    } catch (e) {

    }
  }

  void dispose() {
    disconnect();
    if (!_messageController.isClosed) {
      _messageController.close();
    }
  }
}
