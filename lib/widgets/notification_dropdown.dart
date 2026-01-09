import 'package:app/models/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/provider_root/notification_provider.dart';
import 'notification_item.dart';

class NotificationDropdown extends ConsumerWidget {
  final StateNotifierProvider<NotificationNotifier, NotificationState> provider;

  const NotificationDropdown({Key? key, required this.provider}) : super(key: key);

  String _getTitle(NotificationState state) {
    // Determine title based on the provider's filter type
    final filterType = state.filter;
    switch (filterType) {
      case 'product_like':
        return 'Product Notifications';
      case 'service_like':
        return 'Service Notifications';
      case 'service_comment':
      case 'product_comment':
        return 'Comment Notifications';
      case 'comment_like':
        return 'Comment Likes';
      case 'chat':
        return 'Chat Notifications';
      case 'real_estate':
        return 'Real Estate Notifications';
      case 'recommended_product':
        return 'Recommended Products';
      case 'recommended_service':
        return 'Recommended Services';
      default:
        return 'Notifications';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    
    // Use filtered notifications from state (handles 'all' vs 'unread' filter)
    final filteredNotifications = notificationState.filteredNotifications;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _getTitle(notificationState),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => notifier.markAllAsRead(),
                          child: const Text('Mark all read'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Filters - simplified since each provider is already filtered by type
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _FilterChip(
                      label: 'All',
                      isSelected: notificationState.filter == null || notificationState.filter == 'all',
                      onTap: () => notifier.setFilter('all'),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Unread',
                      isSelected: notificationState.filter == 'unread',
                      onTap: () => notifier.setFilter('unread'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Notifications List
              Expanded(
                child:
                    notificationState.isLoading &&
                        notificationState.notifications.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : filteredNotifications.isEmpty
                    ? Center(
                        child: Text(
                          'No ${_getTitle(notificationState).toLowerCase()}',
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            notifier.fetchNotifications(refresh: true),
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = filteredNotifications[index];
                            return NotificationItem(
                              notification: notification,
                              onTap: () {
                                notifier.markAsRead(notification.id);
                                // Navigate to relevant page
                                _handleNotificationTap(context, ref, notification);
                              },
                              onDelete: () =>
                                  notifier.deleteNotification(notification.id),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNotificationTap(
    BuildContext context,
    WidgetRef ref,
    NotificationModel notification,
  ) {
    // Close the notification dropdown first
    context.pop();

    // Navigate based on notification type and object_id using router
    if (notification.objectId == null) {
      return; // No object ID, can't navigate
    }

    switch (notification.type) {
      case 'product_like':
      case 'recommended_product':
        context.push('/product/${notification.objectId}');
        break;

      case 'service_like':
      case 'service_comment':
      case 'recommended_service':
        context.push('/service/${notification.objectId}');
        break;

      case 'real_estate':
        context.push('/real-estate/${notification.objectId}');
        break;

      case 'chat':
        context.push('/chat/${notification.objectId}');
        break;

      default:
        // For other types, just close
        break;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
