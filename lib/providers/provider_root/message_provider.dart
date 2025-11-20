// services/websocket_service.dart

import 'dart:convert';
import 'dart:async';
import 'package:app/service/endpoints.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ChatWebSocketService {
  WebSocketChannel? _channel;
  final String token;
  StreamController<Map<String, dynamic>>? _messageController;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  bool _shouldReconnect = true;
  String? _lastEndpoint;

  ChatWebSocketService({required this.token});

  Stream<Map<String, dynamic>> get messages => _messageController!.stream;
  bool get isConnected => _channel != null;

  Future<void> connect(String endpoint) async {
    if (_isConnecting) return;

    try {
      _isConnecting = true;
      _lastEndpoint = endpoint;
      _shouldReconnect = true;

      await _disconnect();
      _messageController = StreamController<Map<String, dynamic>>.broadcast();

      final uri = Uri.parse('${Endpoints.wsUrl}$endpoint?token=$token');

      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        (data) {
          try {
            final decoded = json.decode(data) as Map<String, dynamic>;
            _messageController!.add(decoded);
          } catch (e) {
          }
        },
        onError: (error) {
          _messageController!.addError(error);
          if (_shouldReconnect) {
            _scheduleReconnect();
          }
        },
        onDone: () {
          if (_shouldReconnect && _lastEndpoint != null) {
            _scheduleReconnect();
          }
        },
      );

      _isConnecting = false;
    } catch (e) {
      _isConnecting = false;
      if (_shouldReconnect) {
        _scheduleReconnect();
      }
      rethrow;
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    if (_channel != null) {
      try {
        final jsonMessage = json.encode(message);
        _channel!.sink.add(jsonMessage);
      } catch (e) {
      }
    } else {
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Endpoints.reconnectDelay, () {
      if (_shouldReconnect && _lastEndpoint != null) {
        connect(_lastEndpoint!);
      }
    });
  }

  Future<void> _disconnect() async {
    _reconnectTimer?.cancel();
    if (_channel != null) {
      await _channel!.sink.close(status.goingAway);
      _channel = null;
    }
  }

  Future<void> disconnect() async {
    _shouldReconnect = false;
    await _disconnect();
    await _messageController?.close();
    _messageController = null;
  }

  void dispose() {
    disconnect();
  }
}
