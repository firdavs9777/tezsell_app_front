import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';

/// Service for managing app badge count on the home screen icon
/// Works on iOS (Android not supported by this package)
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
      // Badge only supported on iOS (not web)
      _isSupported = !kIsWeb && Platform.isIOS;
      _initialized = true;
      print('Badge service initialized. Supported: $_isSupported');
    } catch (e) {
      print('Badge service initialization error: $e');
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
      print('Badge not supported on this device');
      return;
    }

    try {
      await FlutterAppBadge.count(count);
      print('Badge count updated to: $count');
    } catch (e) {
      print('Error updating badge count: $e');
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
