import 'package:app/firebase_options.dart';
import 'package:app/pages/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service/push_notification_service.dart';
// import 'service/notification_service.dart'; // Remove if redundant

// Global navigator key for handling notification navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Background message handler (must be top-level)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('🔔 📱 BACKGROUND message received!');
  print('   Title: ${message.notification?.title}');
  print('   Body: ${message.notification?.body}');
  print('   Data: ${message.data}');
  print('   Message ID: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 Starting app initialization...');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized');

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    print('✅ Background handler set');

    // Initialize push notifications
    final pushNotificationService = PushNotificationService();
    await pushNotificationService.initialize();
    print('✅ Push notifications initialized');

    // Set up notification tap handler
    pushNotificationService.onNotificationTap = (RemoteMessage message) {
      print('🔔 Notification tapped!');
      print('   Data: ${message.data}');

      // Handle navigation based on notification data
      _handleNotificationNavigation(message.data);
    };

    runApp(
      ProviderScope(
        child: MyApp(pushNotificationService: pushNotificationService),
      ),
    );
  } catch (e) {
    print('❌ Initialization error: $e');
    // Still run app even if notifications fail
    runApp(const ProviderScope(child: MyApp()));
  }
}

// Handle notification navigation
void _handleNotificationNavigation(Map<String, dynamic> data) {
  final context = navigatorKey.currentContext;
  if (context == null) {
    print('⚠️ Navigator context is null');
    return;
  }

  final type = data['type'] as String?;
  final id = data['id'] as String?;

  print('🔔 Navigating to: type=$type, id=$id');

  if (type == null || id == null) {
    print('⚠️ Invalid notification data');
    return;
  }

  // TODO: Implement your navigation logic
  // Example:
  // if (type == 'chat') {
  //   Navigator.of(context).pushNamed('/chat/$id');
  // }
}

class MyApp extends StatelessWidget {
  final PushNotificationService? pushNotificationService;

  const MyApp({Key? key, this.pushNotificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TezSell',
      navigatorKey: navigatorKey, // IMPORTANT: Add global navigator key
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
