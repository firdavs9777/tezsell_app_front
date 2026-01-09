import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../models/notification_model.dart';
import '../providers/provider_root/notification_provider.dart';
import 'notification_websocket_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 🔥 Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('🔔 Background message received: ${message.notification?.title}');
  print('🔔 Data: ${message.data}');
}

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  bool _initialized = false;
  Function(RemoteMessage)? onNotificationTap;
  GoRouter? _router;
  NotificationWebSocketService? _notificationWebSocketService;
  
  /// Set the router instance for navigation
  void setRouter(GoRouter router) {
    _router = router;
  }

  /// Set the notification WebSocket service for injecting push notifications
  void setNotificationWebSocketService(NotificationWebSocketService service) {
    _notificationWebSocketService = service;
  }

  /// Convert RemoteMessage to NotificationModel
  /// Returns null if the message doesn't have required fields
  /// Handles both WebSocket format (id, sender) and FCM format (notification_id, sender_id)
  NotificationModel? _convertPushNotificationToModel(RemoteMessage message) {
    try {
      final data = message.data;
      
      // Check if we have the required fields
      // Backend may send 'id' (WebSocket format) or 'notification_id' (FCM format)
      final hasId = data.containsKey('id') || data.containsKey('notification_id');
      if (!hasId || !data.containsKey('type')) {
        print('⚠️ Push notification missing required fields (id/notification_id, type)');
        print('   Available keys: ${data.keys.toList()}');
        return null;
      }

      // Parse notification ID - handle both 'id' and 'notification_id'
      int notificationId;
      if (data.containsKey('id')) {
        notificationId = data['id'] is int 
            ? data['id'] 
            : int.tryParse(data['id'].toString()) ?? 0;
      } else if (data.containsKey('notification_id')) {
        notificationId = data['notification_id'] is int 
            ? data['notification_id'] 
            : int.tryParse(data['notification_id'].toString()) ?? 0;
      } else {
        print('⚠️ Push notification missing both id and notification_id');
        return null;
      }

      // Parse sender - handle both 'sender' (WebSocket format) and 'sender_id' (FCM format)
      int? sender;
      if (data.containsKey('sender')) {
        sender = data['sender'] is int 
            ? data['sender'] 
            : int.tryParse(data['sender'].toString());
      } else if (data.containsKey('sender_id')) {
        sender = data['sender_id'] is int 
            ? data['sender_id'] 
            : int.tryParse(data['sender_id'].toString());
      }

      // Parse sender_username (same in both formats)
      final senderUsername = data['sender_username'] as String?;

      // Parse object_id (can be string or int)
      int? objectId;
      if (data['object_id'] != null) {
        if (data['object_id'] is int) {
          objectId = data['object_id'];
        } else if (data['object_id'] is String) {
          objectId = int.tryParse(data['object_id']);
        }
      }

      // Parse created_at (use current time if not provided)
      DateTime createdAt;
      if (data.containsKey('created_at') && data['created_at'] != null) {
        try {
          createdAt = DateTime.parse(data['created_at']);
        } catch (e) {
          createdAt = DateTime.now();
        }
      } else {
        createdAt = DateTime.now();
      }

      // Parse is_read (default to false for new notifications)
      final isRead = data['is_read'] ?? false;

      // Get title and body - prefer data fields, fallback to notification payload
      final title = data['title'] ?? message.notification?.title ?? 'New Notification';
      final body = data['body'] ?? message.notification?.body ?? '';

      return NotificationModel(
        id: notificationId,
        sender: sender,
        senderUsername: senderUsername,
        type: data['type'],
        title: title,
        body: body,
        objectId: objectId,
        isRead: isRead is bool ? isRead : false,
        createdAt: createdAt,
      );
    } catch (e) {
      print('❌ Error converting push notification to NotificationModel: $e');
      print('   Message data: ${message.data}');
      return null;
    }
  }
  
  /// Navigate based on notification data
  void _navigateFromNotification(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    final objectId = data['object_id'] as String?;
    
    if (objectId == null || type == null || _router == null) {
      return;
    }
    
    switch (type) {
      case 'product_like':
      case 'recommended_product':
        _router!.go('/product/$objectId');
        break;
      case 'service_like':
      case 'service_comment':
      case 'recommended_service':
        _router!.go('/service/$objectId');
        break;
      case 'real_estate':
        _router!.go('/real-estate/$objectId');
        break;
      case 'chat':
        _router!.go('/chat/$objectId');
        break;
      default:
        // Navigate to tabs for other types
        _router!.go('/tabs');
        break;
    }
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    print('🔔 Initializing Firebase Push Notifications...');

    try {
      // Request permission
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('🔔 Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Initialize local notifications first
        await _initializeLocalNotifications();

        // iOS-specific: Get APNS token before FCM token
        String? apnsToken;
        if (Platform.isIOS) {
          apnsToken = await _getAPNSToken();
          
          // On simulator, APNS token will be null - skip FCM token
          if (apnsToken == null) {
            print('⚠️ Skipping FCM token retrieval - APNS token not available (iOS simulator)');
            print('✅ Firebase Push Notifications initialized (will work on real device)');
            _initialized = true;
            return;
          }
        }

        // Get FCM token with retry logic (only if APNS token is available on iOS)
        await _getFCMTokenWithRetry();

        // Setup message handlers
        _setupMessageHandlers();

        _initialized = true;
        print('✅ Firebase Push Notifications initialized');
        print('📱 FCM Token: ${_fcmToken}...');
        print('💡 Make sure your backend is sending notifications to this FCM token');
        print('💡 Test by sending a notification from Firebase Console or your backend');
        
        // Check if running in debug mode
        bool isDebugMode = false;
        assert(isDebugMode = true); // This only runs in debug mode
        
        if (Platform.isIOS && isDebugMode) {
          print('⚠️ NOTE: You are running in DEBUG mode');
          print('⚠️ For iOS push notifications to work in development, you need:');
          print('   1. A Development APNs Auth Key uploaded to Firebase Console');
          print('   2. Or test with a Release/Production build');
          print('   3. Or test on a real device (simulator does not support push notifications)');
          print('   📱 Current setup: Production APNs key is configured, but Development key is missing');
        }
      } else {
        print('⚠️ Notification permission denied');
      }
    } catch (e) {
      print('❌ Error initializing push notifications: $e');
    }
  }

  /// iOS-specific: Wait for APNS token
  Future<String?> _getAPNSToken() async {
    if (!Platform.isIOS) return null;

    try {
      print('📱 Waiting for APNS token...');

      // Try to get existing APNS token with polling
      String? apnsToken;
      int attempts = 0;
      const maxAttempts = 20; // 10 seconds total (20 * 500ms)

      while (apnsToken == null && attempts < maxAttempts) {
        apnsToken = await _messaging.getAPNSToken();
        if (apnsToken != null) {
          print('✅ APNS Token received: ${apnsToken.substring(0, 20)}...');
          return apnsToken;
        }
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
        if (attempts % 4 == 0) {
          print('⏳ APNS token not available, waiting... (${attempts * 500}ms)');
        }
      }

      if (apnsToken == null) {
        print('⚠️ APNS token timeout after ${maxAttempts * 500}ms');
        print('⚠️ Note: Push notifications DO NOT work on iOS simulator');
        print('⚠️ This is expected - test on a real iOS device for push notifications');
      }
      return apnsToken;
    } catch (e) {
      print('⚠️ Error getting APNS token: $e');
      print('⚠️ Note: Push notifications DO NOT work on iOS simulator');
      return null;
    }
  }

  /// Get FCM token with retry logic
  Future<void> _getFCMTokenWithRetry() async {
    _fcmToken = await _getFCMTokenWithRetryHelper();
    
    if (_fcmToken != null) {
      print('🔔 FCM Token: ${_fcmToken!.substring(0, 20)}...');

      // Save token locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', _fcmToken!);

      // Send token to backend
      await _sendTokenToBackend(_fcmToken!);
    } else {
      print('⚠️ FCM token not available - notifications may not work');
    }
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    print('🔔 Setting up Firebase message handlers...');
    
    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) async {
      print('🔔 Token refreshed: $newToken');
      _fcmToken = newToken;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('fcm_token', newToken);
      await _sendTokenToBackend(newToken);
    });

    // Handle foreground messages (app is open)
    FirebaseMessaging.onMessage.listen((message) {
      print('🔔 📱 FOREGROUND message received!');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
      _handleForegroundMessage(message);
    });

    // Handle background tap (app is in background)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('🔔 📱 BACKGROUND notification tapped!');
      print('   Title: ${message.notification?.title}');
      print('   Body: ${message.notification?.body}');
      print('   Data: ${message.data}');
      
      // Convert push notification to in-app notification
      _convertAndInjectNotification(message);
      
      _navigateFromNotification(message);
      if (onNotificationTap != null) {
        onNotificationTap!(message);
      }
    });

    // Handle terminated state tap (app was closed)
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        print('🔔 📱 TERMINATED notification tapped!');
        print('   Title: ${message.notification?.title}');
        print('   Body: ${message.notification?.body}');
        print('   Data: ${message.data}');
        
        // Convert push notification to in-app notification
        _convertAndInjectNotification(message);
        
        _navigateFromNotification(message);
        if (onNotificationTap != null) {
          onNotificationTap!(message);
        }
      }
    });
    
    print('✅ Firebase message handlers set up successfully');
  }

  Future<void> _initializeLocalNotifications() async {
    // Android notification channel
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS notification settings
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission:
              false, // Changed to false - already requested above
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔔 Local notification tapped: ${response.payload}');
        // Handle local notification tap with router navigation
        if (response.payload != null) {
          try {
            final data = json.decode(response.payload!);
            final message = RemoteMessage(
              notification: null,
              data: Map<String, dynamic>.from(data),
            );
            _navigateFromNotification(message);
          } catch (e) {
            print('❌ Error parsing notification payload: $e');
          }
        }
      },
    );

    // Create notification channels for Android
    if (Platform.isAndroid) {
      await _createNotificationChannels();
    }
  }

  Future<void> _createNotificationChannels() async {
    // General notifications channel
    const AndroidNotificationChannel generalChannel =
        AndroidNotificationChannel(
          'general_notifications',
          'General Notifications',
          description: 'Notifications for likes, comments, and other updates',
          importance: Importance.high,
          playSound: true,
          enableVibration: true,
        );

    // Chat notifications channel
    const AndroidNotificationChannel chatChannel = AndroidNotificationChannel(
      'chat_notifications',
      'Chat Notifications',
      description: 'Notifications for chat messages',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(generalChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(chatChannel);
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('🔔 Handling foreground message...');
    print('   Notification: ${message.notification != null ? "YES" : "NO"}');
    print('   Title: ${message.notification?.title ?? "N/A"}');
    print('   Body: ${message.notification?.body ?? "N/A"}');
    print('   Data keys: ${message.data.keys.toList()}');
    print('   Full data: ${message.data}');
    print('   Message ID: ${message.messageId}');
    print('   Sent time: ${message.sentTime}');
    print('   From: ${message.from}');

    // Show local notification when app is in foreground
    final notification = message.notification;
    final android = message.notification?.android;
    
    // If no notification payload, create one from data
    final title = notification?.title ?? 
                 message.data['title'] ?? 
                 message.data['notification']?['title'] ?? 
                 'New Notification';
    final body = notification?.body ?? 
                message.data['body'] ?? 
                message.data['message'] ?? 
                message.data['notification']?['body'] ?? 
                '';

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      android?.channelId ?? 'general_notifications',
      android?.channelId ?? 'General Notifications',
      channelDescription: 'Notifications for app updates',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: android?.smallIcon ?? '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _localNotifications.show(
        message.hashCode,
        title,
        body,
        details,
        payload: json.encode(message.data),
      );
      print('✅ Local notification shown: $title');
    } catch (e) {
      print('❌ Error showing local notification: $e');
    }

    // Convert push notification to in-app notification and add to notification system
    _convertAndInjectNotification(message);
  }

  /// Convert push notification to in-app notification and inject it
  /// This is called from foreground, background, and terminated handlers
  void _convertAndInjectNotification(RemoteMessage message) {
    final notificationModel = _convertPushNotificationToModel(message);
    if (notificationModel != null && _notificationWebSocketService != null) {
      print('✅ Converting push notification to in-app notification: type=${notificationModel.type}, id=${notificationModel.id}');
      _notificationWebSocketService!.addNotification(notificationModel);
    } else if (notificationModel == null) {
      print('⚠️ Could not convert push notification to NotificationModel - missing required fields');
      print('   Data keys: ${message.data.keys.toList()}');
      print('   Full data: ${message.data}');
    } else if (_notificationWebSocketService == null) {
      print('⚠️ NotificationWebSocketService not set - push notification will not appear in-app');
    }
  }

  /// Helper method to get FCM token with retry
  Future<String?> _getFCMTokenWithRetryHelper({int maxAttempts = 3}) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final token = await _messaging.getToken();
        if (token != null) {
          return token;
        }
      } catch (e) {
        print('❌ Error getting FCM token (attempt $attempt/$maxAttempts): $e');
        if (attempt < maxAttempts) {
          final waitTime = Duration(seconds: attempt * 2);
          print('⏳ Waiting ${waitTime.inSeconds}s before retry $attempt...');
          await Future.delayed(waitTime);
        }
      }
    }
    print('❌ Failed to get FCM token after $maxAttempts attempts');
    return null;
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      // Get auth token directly from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      if (authToken == null) {
        print('⚠️ No auth token, skipping FCM token registration');
        return;
      }

      // Use the correct endpoint: /accounts/fcm-token/
      final url = Uri.parse(AppConfig.getFcmTokenUrl());
      print('🔔 Sending FCM token to: ${url.toString()}');
      
      // Prepare request body
      final requestBody = {
        'fcm_token': token,
        'device_type': Platform.isAndroid ? 'android' : 'ios',
        // Optional: Add device_id if you have device_info_plus package
        // 'device_id': await _getDeviceId(),
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $authToken',
        },
        body: json.encode(requestBody),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print('✅ FCM token sent to backend successfully');
        if (responseData['created'] == true) {
          print('   📝 New token registered (ID: ${responseData['device_token_id']})');
        } else {
          print('   🔄 Token updated');
        }
      } else {
        print('⚠️ Failed to send FCM token to backend: ${response.statusCode}');
        print('Response: ${response.body}');
        
        // Try to parse error message
        try {
          final errorData = json.decode(response.body);
          if (errorData['error'] != null) {
            print('   Error: ${errorData['error']}');
          }
        } catch (_) {
          // Ignore JSON parse errors
        }
      }
    } catch (e) {
      print('❌ Error sending FCM token to backend: $e');
    }
  }

  /// Unregister FCM token from backend
  Future<void> unregisterToken({String? fcmToken}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('token');

      if (authToken == null) {
        print('⚠️ No auth token, skipping FCM token unregistration');
        return;
      }

      final url = Uri.parse(AppConfig.getFcmTokenUrl());
      print('🔔 Unregistering FCM token from: ${url.toString()}');
      
      final body = fcmToken != null
          ? json.encode({'fcm_token': fcmToken})
          : null;

      final headers = <String, String>{
        'Authorization': 'Token $authToken',
        if (body != null) 'Content-Type': 'application/json',
      };

      final response = await http.delete(
        url,
        headers: headers,
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print('✅ FCM token unregistered successfully');
        // Clear local token
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('fcm_token');
        _fcmToken = null;
      } else {
        print('⚠️ Failed to unregister FCM token: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error unregistering FCM token: $e');
    }
  }

  Future<void> deleteToken() async {
    try {
      // Unregister from backend first
      await unregisterToken(fcmToken: _fcmToken);
      
      // Then delete from Firebase
      await _messaging.deleteToken();
      
      // Clear local storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('fcm_token');
      _fcmToken = null;
      
      print('✅ FCM token deleted from Firebase and backend');
    } catch (e) {
      print('❌ Error deleting FCM token: $e');
    }
  }

  /// Test method to verify notification setup
  /// This will show a local notification to test if the system is working
  Future<void> testLocalNotification() async {
    try {
      await _localNotifications.show(
        999999,
        'Test Notification',
        'If you see this, local notifications are working!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'general_notifications',
            'General Notifications',
            channelDescription: 'Test notification',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('✅ Test notification sent');
    } catch (e) {
      print('❌ Error showing test notification: $e');
    }
  }

  void dispose() {
    // Cleanup if needed
  }
}
