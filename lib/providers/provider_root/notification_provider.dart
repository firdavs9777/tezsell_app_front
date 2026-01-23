import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/notification_model.dart';
import '../../service/notification_api_service.dart';
import '../../service/notification_websocket_service.dart';
import '../../service/authentication_service.dart';
import '../../service/notification_service.dart';
import '../../service/push_notification_service.dart';
import 'chat_provider.dart';

// Notification State
class NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;
  final String? filter; // 'all', 'unread', 'chat', 'like', etc.

  NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
    this.filter,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationState &&
        other.unreadCount == unreadCount &&
        other.notifications.length == notifications.length &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.filter == filter;
  }

  @override
  int get hashCode {
    return Object.hash(unreadCount, notifications.length, isLoading, error, filter);
  }

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
    String? filter,
  }) {
    final newState = NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filter: filter ?? this.filter,
    );
    // Debug: Log state changes
    if (unreadCount != null && unreadCount != this.unreadCount) {
      print('📊 State changed: unreadCount ${this.unreadCount} -> $unreadCount');
    }
    return newState;
  }

  List<NotificationModel> get filteredNotifications {
    if (filter == null || filter == 'all') return notifications;
    if (filter == 'unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications.where((n) => n.type == filter).toList();
  }

  /// Get unread count for a specific notification type
  int getUnreadCountForType(String? type) {
    if (type == null || type == 'all') {
      return unreadCount;
    }
    return notifications
        .where((n) => !n.isRead && n.type == type)
        .length;
  }
}

// Notification Notifier
class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationApiService _apiService;
  final NotificationWebSocketService _webSocketService;
  final String? _notificationType; // Filter type for this provider instance
  Timer? _refreshTimer;
  StreamSubscription<NotificationModel>? _webSocketSubscription;
  final NotificationService _notificationService = NotificationService();

  NotificationNotifier(
    this._apiService,
    this._webSocketService, {
    String? notificationType,
  })  : _notificationType = notificationType,
        super(NotificationState(filter: notificationType)) {
    _initializeWebSocket();
    // Auto-refresh unread count every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchUnreadCount();
    });
  }

  /// Initialize WebSocket connection
  void _initializeWebSocket() async {
    // Ensure WebSocket is connected
    if (!_webSocketService.isConnected) {
      await _webSocketService.connect();
    }
    
    // Subscribe to the WebSocket stream
    _webSocketSubscription = _webSocketService.notificationStream.listen(
      (notification) {
        // Only add notification if it matches this provider's type
        if (_notificationType == null || notification.type == _notificationType) {
          // Check if notification already exists (avoid duplicates)
          final exists = state.notifications.any((n) => n.id == notification.id);
          if (!exists) {
            print('✅ [$_notificationType] Adding notification ID ${notification.id}, unread: ${!notification.isRead}');
            final newUnreadCount = notification.isRead
                ? state.unreadCount
                : state.unreadCount + 1;

            state = state.copyWith(
              notifications: [notification, ...state.notifications],
              unreadCount: newUnreadCount,
            );

            print('✅ [$_notificationType] State updated: unreadCount=${state.unreadCount}, total=${state.notifications.length}');

            // Update OS badge count for unread notifications (only for global provider)
            if (_notificationType == null && !notification.isRead) {
              PushNotificationService().updateBadgeCount(newUnreadCount);
            }

            // Show local notification for chat messages when app is in foreground
            if (notification.type == 'chat' && !notification.isRead) {
              _showLocalNotification(notification);
            }
          } else {
            print('⚠️ [$_notificationType] Notification ID ${notification.id} already exists, skipping');
          }
        }
        // Silently ignore notifications that don't match this provider's type
      },
      onError: (error) {
        print('❌ WebSocket stream error in provider [$_notificationType]: $error');
      },
    );
  }

  /// Show local notification for chat messages
  Future<void> _showLocalNotification(NotificationModel notification) async {
    try {
      final notificationService = NotificationService();
      
      // Create payload with notification data for navigation
      final payload = json.encode({
        'type': notification.type,
        'id': notification.id,
        'object_id': notification.objectId?.toString(),
        'sender_id': notification.sender?.toString(),
        'sender_username': notification.senderUsername,
      });
      
      await notificationService.showMessageNotification(
        title: notification.title,
        body: notification.body,
        payload: payload,
      );
      
      print('✅ Local notification shown for chat message: ${notification.body}');
    } catch (e) {
      print('❌ Error showing local notification: $e');
    }
  }

  /// Fetch notifications
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (!refresh && state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Always use the provider's notification type for filtering
      final response = await _apiService.getNotifications(
        type: _notificationType,
        isRead: null, // Fetch all (read and unread) for this type
      );

      state = state.copyWith(
        notifications: refresh ? response.results : [...state.notifications, ...response.results],
        isLoading: false,
        error: null,
      );

      await fetchUnreadCount();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Fetch unread count
  Future<void> fetchUnreadCount() async {
    try {
      int newUnreadCount = 0;

      if (_notificationType != null) {
        // For typed providers, calculate unread count from notifications
        // But also fetch from API to ensure accuracy
        final localUnreadCount = state.notifications
            .where((n) => !n.isRead && n.type == _notificationType)
            .length;

        // Try to get accurate count from API
        try {
          final response = await _apiService.getNotifications(
            type: _notificationType,
            isRead: false, // Only unread
          );
          final apiUnreadCount = response.results.length;
          // Use the higher of the two counts to ensure we don't miss any
          newUnreadCount = apiUnreadCount > localUnreadCount
              ? apiUnreadCount
              : localUnreadCount;
          state = state.copyWith(unreadCount: newUnreadCount);
        } catch (e) {
          // Fallback to local count if API fails
          newUnreadCount = localUnreadCount;
          state = state.copyWith(unreadCount: localUnreadCount);
        }
      } else {
        // For global provider, use API and update badge
        final count = await _apiService.getUnreadCount();
        newUnreadCount = count;
        state = state.copyWith(unreadCount: count);

        // Update OS badge count (only for global provider)
        await PushNotificationService().updateBadgeCount(count);
      }
    } catch (e) {
      // Silently fail - don't update state on error
      print('⚠️ Error fetching unread count: $e');
    }
  }

  /// Set filter
  void setFilter(String? filter) {
    state = state.copyWith(filter: filter);
    fetchNotifications(refresh: true);
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiService.markAsRead(notificationId);
      final updatedNotifications = state.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final newUnreadCount = state.unreadCount > 0 ? state.unreadCount - 1 : 0;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      );

      // Update OS badge count (only for global provider)
      if (_notificationType == null) {
        await PushNotificationService().updateBadgeCount(newUnreadCount);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead() async {
    try {
      await _apiService.markAllAsRead();
      final updatedNotifications = state.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      );

      // Clear OS badge count (only for global provider)
      if (_notificationType == null) {
        await PushNotificationService().clearBadgeCount();
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Delete notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _apiService.deleteNotification(notificationId);
      final notification = state.notifications.firstWhere(
        (n) => n.id == notificationId,
      );
      final updatedNotifications = state.notifications
          .where((n) => n.id != notificationId)
          .toList();

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: !notification.isRead && state.unreadCount > 0
            ? state.unreadCount - 1
            : state.unreadCount,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Connect WebSocket (optional - fails gracefully if endpoint doesn't exist)
  Future<void> connectWebSocket() async {
    try {
      await _webSocketService.connect();
    } catch (e) {
      // WebSocket is optional - REST API will still work for notifications
      print('⚠️ WebSocket connection failed (optional): $e');
    }
  }

  /// Disconnect WebSocket
  void disconnectWebSocket() {
    _webSocketService.disconnect();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    // Don't disconnect WebSocket here - it's shared across providers
    // Only dispose if this is the last provider using it
    super.dispose();
  }
}

// Providers
final notificationApiServiceProvider = Provider<NotificationApiService>((ref) {
  final authService = ref.watch(authenticationServiceProvider);
  return NotificationApiService(authService);
});

final notificationWebSocketServiceProvider =
    Provider<NotificationWebSocketService>((ref) {
  final authService = ref.watch(authenticationServiceProvider);
  final service = NotificationWebSocketService(authService);
  ref.onDispose(() => service.dispose());
  return service;
});

// Global notification provider (all notifications)
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(apiService, webSocketService);
  // Initialize on first load
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

// Separate providers for each notification type
// Using new backend notification types: product_like, service_like, service_comment, etc.
final productNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'product_like', // New backend type
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

final serviceNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'service_like', // New backend type
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

final chatNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'chat',
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  
  // Note: Marking notifications as read when entering a chat room is handled
  // in chat_room.dart via _markChatNotificationsAsRead() method
  // This avoids circular dependency issues
  
  return notifier;
});

final realEstateNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'real_estate', // Backend type (unchanged)
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

final commentNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'service_comment', // New backend type
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

final recommendedProductNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'recommended_product',
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

final recommendedServiceNotificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final apiService = ref.watch(notificationApiServiceProvider);
  final webSocketService = ref.watch(notificationWebSocketServiceProvider);
  final notifier = NotificationNotifier(
    apiService,
    webSocketService,
    notificationType: 'recommended_service',
  );
  notifier.fetchNotifications(refresh: true);
  notifier.fetchUnreadCount();
  notifier.connectWebSocket();
  return notifier;
});

