# Notification System Implementation

This document describes the notification system implementation in the Flutter app.

## Overview

A complete notification system has been implemented with:
- Real-time notifications via WebSocket
- REST API integration for fetching and managing notifications
- UI components (notification bell, dropdown, and item widgets)
- Riverpod state management
- Automatic unread count updates

## Files Created

### Models
- `lib/models/notification_model.dart` - Notification data model
- `lib/models/notification_response.dart` - Paginated response model

### Services
- `lib/service/notification_api_service.dart` - REST API service for notifications
- `lib/service/notification_websocket_service.dart` - WebSocket service for real-time notifications

### Providers
- `lib/providers/provider_root/notification_provider.dart` - Riverpod state management

### Widgets
- `lib/widgets/notification_bell.dart` - Notification bell icon with badge
- `lib/widgets/notification_dropdown.dart` - Notification dropdown sheet
- `lib/widgets/notification_item.dart` - Individual notification item widget

### Configuration
- Updated `lib/config/app_config.dart` - Added notification endpoints

## Integration

The notification bell has been integrated into the main tab bar (`lib/pages/tab_bar/tab_bar.dart`). It appears in the AppBar when `_shouldShowNotification()` returns true.

## API Endpoints

The following endpoints are configured in `AppConfig`:
- `notificationsPath`: `/api/notifications/`
- `notificationsUnreadCountPath`: `/api/notifications/unread-count/`
- `notificationsMarkAllReadPath`: `/api/notifications/mark-all-read/`
- `notificationsWsPath`: `/ws/notifications/`

## Features

1. **Real-time Updates**: WebSocket connection for instant notifications
2. **Unread Count**: Automatic badge display with unread count
3. **Filtering**: Filter by type (all, unread, chat, like, comment)
4. **Mark as Read**: Individual and bulk mark as read
5. **Delete**: Swipe to delete notifications
6. **Auto-refresh**: Unread count refreshes every 30 seconds
7. **Pull to Refresh**: Pull down to refresh notifications list

## Usage

The notification system is automatically initialized when the app starts. The notification bell appears in the AppBar and shows:
- White notification icon
- Red badge with unread count (if > 0)
- Click to open notification dropdown

## Notification Types

Supported notification types:
- `chat` - Chat messages
- `like` - Likes on posts/products
- `comment` - Comments
- `order` - Order updates
- `system` - System notifications

## Customization

To customize notification navigation, update the `_handleNotificationTap` method in `notification_dropdown.dart`:

```dart
void _handleNotificationTap(BuildContext context, NotificationModel notification) {
  if (notification.type == 'chat') {
    // Navigate to chat screen
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ChatScreen(chatId: notification.objectId),
    ));
  }
  // Add other navigation logic
}
```

## Dependencies

All required dependencies are already in `pubspec.yaml`:
- `http: ^1.1.0`
- `web_socket_channel: ^2.4.0`
- `flutter_riverpod: ^2.4.10`
- `intl: ^0.20.2`

## Testing

To test the notification system:
1. Ensure backend API endpoints are available
2. Ensure WebSocket endpoint is accessible
3. Check that authentication token is properly stored
4. Verify notification bell appears in AppBar
5. Test real-time notifications via WebSocket

## Notes

- The notification provider automatically connects to WebSocket on initialization
- Unread count is refreshed every 30 seconds
- Notifications are stored in memory (consider adding local persistence if needed)
- WebSocket automatically reconnects on connection loss

