// import 'package:app/firebase_options.dart';
// import 'package:app/pages/welcome.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'service/notification_service.dart';
//
// // Background message handler
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   print('🔔 Background message: ${message.notification?.title}');
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Set background message handler
//   FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//   // Initialize notifications
//   await NotificationService().initialize();
//   runApp(const ProviderScope(child: Welcome()));
// }

import 'package:app/pages/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Simple notification setup - no Firebase!
  await NotificationService().initialize();
  runApp(const ProviderScope(child: Welcome()));
}
