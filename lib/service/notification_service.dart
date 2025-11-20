// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// // 🔥 Background message handler (must be top-level function)
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print('🔔 Background message: ${message.notification?.title}');
// }
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _localNotifications =
//       FlutterLocalNotificationsPlugin();
//
//   String? _fcmToken;
//   String? get fcmToken => _fcmToken;
//
//   Future<void> initialize() async {
//     print('🔔 Initializing Firebase Notifications...');
//
//     // Request permission
//     NotificationSettings settings = await _messaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//       provisional: false,
//     );
//
//     print('🔔 Permission status: ${settings.authorizationStatus}');
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       // Initialize local notifications
//       await _initializeLocalNotifications();
//
//       // Get FCM token
//       _fcmToken = await _messaging.getToken();
//       print('🔔 FCM Token: $_fcmToken');
//
//       // Save token locally
//       if (_fcmToken != null) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('fcm_token', _fcmToken!);
//       }
//
//       // Listen for token refresh
//       _messaging.onTokenRefresh.listen((newToken) {
//         print('🔔 Token refreshed: $newToken');
//         _fcmToken = newToken;
//       });
//
//       // Handle foreground messages
//       FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
//
//       // Handle background tap
//       FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
//
//       // Handle terminated state tap
//       _messaging.getInitialMessage().then((message) {
//         if (message != null) {
//           _handleNotificationTap(message);
//         }
//       });
//
//       print('✅ Firebase Notifications initialized');
//     }
//   }
//
//   Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings android =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const DarwinInitializationSettings iOS = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
//
//     const InitializationSettings settings = InitializationSettings(
//       android: android,
//       iOS: iOS,
//     );
//
//     await _localNotifications.initialize(settings);
//   }
//
//   Future<void> _handleForegroundMessage(RemoteMessage message) async {
//     print('🔔 Foreground message: ${message.notification?.title}');
//
//     // Show local notification when app is in foreground
//     const AndroidNotificationDetails android = AndroidNotificationDetails(
//       'messages',
//       'Messages',
//       channelDescription: 'Chat message notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     const DarwinNotificationDetails iOS = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//
//     const NotificationDetails details = NotificationDetails(
//       android: android,
//       iOS: iOS,
//     );
//
//     await _localNotifications.show(
//       message.hashCode,
//       message.notification?.title ?? 'New Message',
//       message.notification?.body ?? '',
//       details,
//     );
//   }
//
//   void _handleNotificationTap(RemoteMessage message) {
//     print('🔔 Notification tapped: ${message.data}');
//     // TODO: Navigate to chat room
//   }
// }
// Above ready firebase notifications

// lib/service/notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  Future<void> showMessageNotification({
    required String title,
    required String body,
    String? payload,
  }) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'messages',
      'Messages',
      channelDescription: 'Chat message notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch % 100000, // Unique ID
      title,
      body,
      details,
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    // TODO: Navigate to chat room with ID from payload
    // You can use a global navigator key or callback here
  }
}
