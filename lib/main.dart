import 'package:app/firebase_options.dart';
import 'package:app/pages/welcome.dart';
import 'package:app/service/token_store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'service/push_notification_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:app/config/app_config.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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

  // Crash reporting is opt-in at build time (see AppConfig.sentryDsn). With
  // no DSN the SDK is never initialised at all, so debug and CI runs stay
  // completely offline rather than shipping errors somewhere by accident.
  if (!AppConfig.isSentryEnabled) {
    await _bootstrap();
    return;
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      // Sampled rather than 1.0: this is a consumer marketplace app and
      // full-rate tracing on every session is needless quota burn.
      options.tracesSampleRate = 0.2;
      options.enableAutoSessionTracking = true;
    },
    appRunner: _bootstrap,
  );
}

Future<void> _bootstrap() async {
  print('🚀 Starting app initialization...');

  // Load locale-specific date symbols so DateFormat(pattern, locale) can
  // render month/weekday names in ru/uz rather than throwing
  // LocaleDataException or silently falling back to English.
  await initializeDateFormatting();

  // Load/migrate auth tokens into secure storage before any auth check runs
  // (splash screen, router redirect, etc. all read via TokenStore).
  try {
    await TokenStore.instance.init();
    print('✅ Token store initialized');
  } catch (e) {
    print('❌ Token store init error: $e');
  }

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
