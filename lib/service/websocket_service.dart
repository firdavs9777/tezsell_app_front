import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:app/service/connection_state_controller.dart';
import 'package:app/service/token_store.dart';

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
      final token = await TokenStore.instance.getAccessToken();

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
              ConnectionStateController.instance.setSocketState(true);
            }

            _messageController.add(message);
          } catch (e) {

          }
        },
        onError: (error) {

          _isConnected = false;
          ConnectionStateController.instance.setSocketState(false);
        },
        onDone: () {

          _isConnected = false;
          ConnectionStateController.instance.setSocketState(false);
        },
      );

      // Mark as connected after a short delay (connection is established)
      Future.delayed(const Duration(milliseconds: 500), () {
        _isConnected = true;
        ConnectionStateController.instance.setSocketState(true);
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

      final token = await TokenStore.instance.getAccessToken();

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
              ConnectionStateController.instance.setSocketState(true);
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
          ConnectionStateController.instance.setSocketState(false);
          if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
            _connectionCompleter!.completeError(error);
          }
          _attemptReconnect(roomId);
        },
        onDone: () {
          print('🔌 WebSocket stream done (closed)');
          _isConnected = false;
          _isConnecting = false;
          ConnectionStateController.instance.setSocketState(false);
          // Unblock any pending ready future so the caller doesn't wait 5s.
          if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
            _connectionCompleter!.completeError(
              Exception('WebSocket closed before connection_established'),
            );
          }
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
          ConnectionStateController.instance.setSocketState(true);
        },
      );

      print('🔌 Connection complete. _isConnected: $_isConnected');

    } catch (e) {
      print('❌ Connection error: $e');
      _isConnected = false;
      _isConnecting = false;
      ConnectionStateController.instance.setSocketState(false);
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

  /// Sends a chat message. [localId] is a client-generated id (see
  /// `ChatNotifier._generateLocalId`) echoed back by the backend in the ack /
  /// broadcast so the sender can match its optimistic bubble to the
  /// persisted message without creating a duplicate.
  void sendChatMessage(String content, {String? localId}) {
    print('📤 sendChatMessage called with: "$content", localId: $localId');
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
        if (localId != null) 'local_id': localId,
      });

      print('📤 Sending WebSocket message: $message');
      // 🔥 Ensure UTF-8 encoding when sending
      _channel!.sink.add(message);
      print('✅ Message sent to WebSocket');

    } catch (e) {
      print('❌ Error sending message: $e');
      _isConnected = false;
      ConnectionStateController.instance.setSocketState(false);
    }
  }

  /// 🔥 NEW: Task 20 — sends the dedicated `typing_start`/`typing_stop`
  /// client events the backend now listens for (it also still accepts the
  /// legacy `{type: 'typing', is_typing}` shape for older clients, but this
  /// is the documented contract going forward).
  void sendTypingStatus(bool isTyping) {
    if (!_isConnected || _channel == null) {
      return;
    }

    try {
      final message = json.encode({
        'type': isTyping ? 'typing_start' : 'typing_stop',
      });
      _channel!.sink.add(message);
    } catch (e) {
      print('❌ Error sending typing status: $e');
    }
  }

  /// 🔥 Send read receipt to mark messages as read (KakaoTalk-style)
  void sendReadReceipt() {
    if (!_isConnected || _channel == null) {
      return;
    }

    try {
      // Backend expects 'mark_read' type
      final message = json.encode({
        'type': 'mark_read',
      });
      _channel!.sink.add(message);
      print('✅ Read receipt sent (mark_read)');
    } catch (e) {
      print('❌ Error sending read receipt: $e');
    }
  }

  /// 🔥 NEW: Mark specific message as read
  void markMessageAsRead(int messageId) {
    if (!_isConnected || _channel == null) {
      print('❌ Cannot mark message as read: not connected');
      return;
    }

    try {
      final message = json.encode({
        'type': 'mark_read',
        'message_id': messageId,
      });
      _channel!.sink.add(message);
      print('✅ Marked message $messageId as read');
    } catch (e) {
      print('❌ Error marking message as read: $e');
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
