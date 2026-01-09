import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/provider_root/notification_provider.dart';
import 'notification_dropdown.dart';

class NotificationBell extends ConsumerWidget {
  final StateNotifierProvider<NotificationNotifier, NotificationState> provider;
  final Color? iconColor;

  const NotificationBell({
    Key? key,
    required this.provider,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(provider);
    
    // Use unread count from the provider's state
    final unreadCount = notificationState.unreadCount;
    
    // Debug logging - always log to see if rebuilds are happening
    print('🔔 NotificationBell build: unreadCount=$unreadCount, total=${notificationState.notifications.length}');

    final effectiveIconColor = iconColor ?? Colors.white;

    return GestureDetector(
      onTap: () => _showNotificationDropdown(context, ref),
      child: Stack(
        children: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: effectiveIconColor,
            ),
            onPressed: () => _showNotificationDropdown(context, ref),
          ),
          if (unreadCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  unreadCount > 99
                      ? '99+'
                      : unreadCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showNotificationDropdown(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NotificationDropdown(provider: provider),
    );
  }
}

