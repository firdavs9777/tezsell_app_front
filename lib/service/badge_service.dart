import 'package:flutter_app_badger/flutter_app_badger.dart';

/// Service for managing app badge count on the home screen icon
/// Works on iOS and Android (where supported)
class BadgeService {
  static final BadgeService _instance = BadgeService._internal();
  factory BadgeService() => _instance;
  BadgeService._internal();

  bool _isSupported = false;
  bool _initialized = false;

  /// Initialize the badge service
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Check if badge is supported on this device
      _isSupported = await FlutterAppBadger.isAppBadgeSupported();
      _initialized = true;
      print('🔢 Badge service initialized. Supported: $_isSupported');
    } catch (e) {
      print('⚠️ Badge service initialization error: $e');
      _isSupported = false;
      _initialized = true;
    }
  }

  /// Update the app badge count
  /// Set to 0 to remove the badge
  Future<void> updateBadgeCount(int count) async {
    if (!_initialized) {
      await initialize();
    }

    if (!_isSupported) {
      print('🔢 Badge not supported on this device');
      return;
    }

    try {
      if (count > 0) {
        await FlutterAppBadger.updateBadgeCount(count);
        print('🔢 Badge count updated to: $count');
      } else {
        await FlutterAppBadger.removeBadge();
        print('🔢 Badge removed');
      }
    } catch (e) {
      print('❌ Error updating badge count: $e');
    }
  }

  /// Remove the badge
  Future<void> removeBadge() async {
    await updateBadgeCount(0);
  }

  /// Increment badge count by 1
  /// Note: This requires knowing the current count, so it's handled by the caller
  Future<void> incrementBadge(int currentCount) async {
    await updateBadgeCount(currentCount + 1);
  }

  /// Decrement badge count by 1
  Future<void> decrementBadge(int currentCount) async {
    if (currentCount > 0) {
      await updateBadgeCount(currentCount - 1);
    }
  }

  /// Check if badges are supported
  bool get isSupported => _isSupported;
}

/// Global badge service provider
final badgeService = BadgeService();
