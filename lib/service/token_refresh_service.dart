import 'dart:async';
import 'package:app/service/authentication_service.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Service for automatic token refresh
/// 
/// Refreshes access tokens proactively before they expire (every 23 hours)
class TokenRefreshService {
  static TokenRefreshService? _instance;
  final AuthenticationService _authService;
  Timer? _refreshTimer;
  bool _isRunning = false;

  TokenRefreshService._(this._authService);

  factory TokenRefreshService(AuthenticationService authService) {
    _instance ??= TokenRefreshService._(authService);
    return _instance!;
  }

  /// Start automatic token refresh (refreshes every 23 hours)
  void start() {
    if (_isRunning) {
      AppLogger.warning('Token refresh service is already running');
      return;
    }

    _isRunning = true;
    AppLogger.info('Starting automatic token refresh service');

    // Refresh immediately if token is close to expiry
    _checkAndRefreshIfNeeded();

    // Set up periodic refresh (every 23 hours = 82800 seconds)
    _refreshTimer = Timer.periodic(
      const Duration(hours: 23),
      (_) => _refreshToken(),
    );
  }

  /// Stop automatic token refresh
  void stop() {
    if (!_isRunning) {
      return;
    }

    _isRunning = false;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    AppLogger.info('Stopped automatic token refresh service');
  }

  /// Check if token needs refresh and refresh if needed
  Future<void> _checkAndRefreshIfNeeded() async {
    try {
      // First check if refresh token exists
      final refreshToken = await _authService.getStoredRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.info('No refresh token available - skipping automatic refresh');
        return;
      }

      // Check if token is close to expiry (within 1 hour)
      final expiresAt = await _getTokenExpiry();
      
      if (expiresAt != null) {
        final now = DateTime.now();
        final timeUntilExpiry = expiresAt.difference(now);

        // If token expires within 1 hour, refresh now
        if (timeUntilExpiry.inHours < 1) {
          AppLogger.info('Token expires soon, refreshing now');
          await _refreshToken();
        } else {
          AppLogger.info('Token is still valid for ${timeUntilExpiry.inHours} hours');
        }
      } else {
        // No expiry info, but we have refresh token - try to refresh to get expiry info
        AppLogger.info('No expiry info found, attempting refresh to get expiry info');
        await _refreshToken();
      }
    } catch (e) {
      AppLogger.error('Error checking token expiry: $e');
    }
  }

  /// Get token expiry time from storage
  Future<DateTime?> _getTokenExpiry() async {
    try {
      final prefs = await _authService.getPrefsForTesting();
      final expiresAtStr = prefs.getString('token_expires_at');
      if (expiresAtStr != null) {
        return DateTime.parse(expiresAtStr);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting token expiry: $e');
      return null;
    }
  }

  /// Refresh the token
  Future<void> _refreshToken() async {
    try {
      AppLogger.info('Automatic token refresh triggered');
      final token = await _authService.refreshToken();
      
      if (token != null) {
        AppLogger.info('Token refreshed successfully');
      } else {
        AppLogger.warning('Token refresh failed - user may need to login again');
        // Don't stop the service, it will try again next cycle
      }
    } catch (e) {
      AppLogger.error('Error during automatic token refresh: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    stop();
    _instance = null;
  }
}

