import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../models/notification_model.dart';
import '../config/app_config.dart';
import 'authentication_service.dart';

class NotificationWebSocketService {
  final AuthenticationService _authService;
  WebSocketChannel? _channel;
  StreamController<NotificationModel>? _notificationController;
  StreamSubscription<dynamic>? _channelSubscription;
  Timer? _reconnectTimer;
  bool _isConnecting = false;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  NotificationWebSocketService(this._authService) {
    _notificationController = StreamController<NotificationModel>.broadcast();
  }

  Stream<NotificationModel> get notificationStream =>
      _notificationController!.stream;

  /// Manually add a notification to the stream (e.g., from push notifications)
  /// This allows push notifications to be added to the in-app notification system
  void addNotification(NotificationModel notification) {
    if (_notificationController != null && !_notificationController!.isClosed) {
      _notificationController!.add(notification);
      print('✅ Manually injected notification into stream: type=${notification.type}, id=${notification.id}');
    } else {
      print('⚠️ Cannot inject notification - stream controller is closed or null');
    }
  }

/// Build WebSocket URI from base URL
Uri _buildWebSocketUri(String token) {
  // Clean token - remove any trailing characters like #
  final cleanToken = token.replaceAll(RegExp(r'[#\s]+$'), '');
  
  // Get the base WebSocket URL from config
  final wsUrl = AppConfig.getNotificationsWsUrl();
  
  // Parse the base URL
  final baseUri = Uri.parse(wsUrl);
  
  // If the URL already has the correct WebSocket scheme, just add the token parameter
  if (baseUri.scheme == 'wss' || baseUri.scheme == 'ws') {
    final wsUri = baseUri.replace(
      queryParameters: {'token': cleanToken},
    );
    print('🔌 Connecting to: $wsUri');
    return wsUri;
  }
  
  // Otherwise, convert http/https to ws/wss
  final wsScheme = baseUri.scheme == 'https' ? 'wss' : 'ws';
  
  final wsUri = Uri(
    scheme: wsScheme,
    host: baseUri.host,
    port: baseUri.hasPort ? baseUri.port : null,
    path: baseUri.path,
    queryParameters: {'token': cleanToken},
  );
  
  print('🔌 Connecting to: $wsUri');
  return wsUri;
}

  /// Connect to WebSocket
  Future<void> connect() async {
    if (_isConnecting || (_channel != null && _channel!.closeCode == null)) {
      print('⚠️ Already connected or connecting, skipping...');
      return; // Already connected or connecting
    }

    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ Max reconnect attempts reached. Stopping reconnection.');
      return;
    }

    _isConnecting = true;
    final token = await _authService.getStoredToken();
    
    if (token == null) {
      _isConnecting = false;
      return;
    }

    final uri = _buildWebSocketUri(token);

    try {
      _channel = WebSocketChannel.connect(uri);

      _channelSubscription = _channel!.stream.listen(
        (message) {
          print('📨 WebSocket message received:');
          print('📦 Raw message type: ${message.runtimeType}');
          print('📦 Raw message: $message');
          
          try {
            final jsonData = json.decode(message);
            print('✅ JSON decoded successfully');
            print('📋 Parsed JSON data: $jsonData');
            print('📋 JSON keys: ${jsonData is Map ? (jsonData as Map).keys.toList() : 'Not a Map'}');
            
            final notification = NotificationModel.fromJson(jsonData);
            print('✅ Notification model created:');
            print('   - ID: ${notification.id}');
            print('   - Type: ${notification.type}');
            print('   - Title: ${notification.title}');
            print('   - Body: ${notification.body}');
            print('   - Is Read: ${notification.isRead}');
            print('   - Created At: ${notification.createdAt}');
            print('   - Sender: ${notification.sender}');
            print('   - Sender Username: ${notification.senderUsername}');
            print('   - Object ID: ${notification.objectId}');
            
            // Broadcast to all stream listeners
            _notificationController!.add(notification);
            print('✅ Notification broadcasted to all listeners');
            _reconnectAttempts = 0; // Reset on successful message
          } catch (e, stackTrace) {
            print('❌ Error parsing WebSocket message: $e');
            print('📦 Raw message: $message');
            print('📦 Stack trace: $stackTrace');
          }
        },
        onError: (error) {
          print('❌ WebSocket error: $error');
          _isConnecting = false;
          _channel = null;
          _channelSubscription?.cancel();
          _channelSubscription = null;
          _scheduleReconnect();
        },
        onDone: () {
          if (_channel?.closeCode != status.normalClosure) {
            print('🔌 WebSocket connection closed (code: ${_channel?.closeCode})');
            _scheduleReconnect();
          } else {
            print('✅ WebSocket closed normally');
          }
          _channel = null;
          _channelSubscription?.cancel();
          _channelSubscription = null;
          _isConnecting = false;
        },
        cancelOnError: false,
      );

      print('✅ Connected to notifications WebSocket');
      _isConnecting = false;
      _reconnectAttempts = 0; // Reset on successful connection
    } catch (e) {
      print('❌ Error connecting to WebSocket: $e');
      _isConnecting = false;
      _channel = null;
      _channelSubscription?.cancel();
      _channelSubscription = null;
      _scheduleReconnect();
    }
  }

  /// Schedule reconnection with exponential backoff
  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectAttempts++;
    
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ Max reconnect attempts ($_maxReconnectAttempts) reached. Please check your connection.');
      return;
    }
    
    // Exponential backoff: 1s, 2s, 4s, 8s, 16s
    final delaySeconds = 1 << (_reconnectAttempts - 1);
    print('🔄 Scheduling reconnect in ${delaySeconds}s (attempt $_reconnectAttempts/$_maxReconnectAttempts)');
    
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      connect();
    });
  }
  
  /// Reset reconnect attempts (call when manually reconnecting)
  void resetReconnectAttempts() {
    _reconnectAttempts = 0;
  }

  /// Disconnect WebSocket
  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _isConnecting = false;
    
    _channelSubscription?.cancel();
    _channelSubscription = null;
    
    if (_channel != null) {
      try {
        _channel!.sink.close(status.normalClosure);
      } catch (e) {
        print('Error closing WebSocket: $e');
      }
      _channel = null;
    }
    
    _reconnectAttempts = 0;
    print('🔌 WebSocket disconnected');
  }
  
  /// Check if WebSocket is connected
  bool get isConnected => 
      _channel != null && _channel!.closeCode == null && !_isConnecting;

  /// Dispose resources
  void dispose() {
    disconnect();
    _notificationController?.close();
  }
}
