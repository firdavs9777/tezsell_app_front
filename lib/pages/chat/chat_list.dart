import 'package:app/pages/chat//chat_room.dart';
import 'package:app/pages/chat/user_list.dart';
import 'package:app/pages/chat/blocked_users_screen.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/widgets/notification_bell.dart';
import 'package:app/providers/provider_root/notification_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class MessagesList extends ConsumerStatefulWidget {
  const MessagesList({super.key});

  @override
  ConsumerState<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends ConsumerState<MessagesList>
    with WidgetsBindingObserver {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Initialize chat on first load
    Future.microtask(() {
      if (mounted) {
        ref.read(chatProvider.notifier).initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // App came back to foreground
      ref.read(chatProvider.notifier).ensureChatListConnected();
    }
  }

  // 🔥 ADD THIS - Called when widget becomes visible again
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Reconnect chat list WebSocket when returning to this screen
    if (mounted && _isInitialized) {
      Future.microtask(() {
        ref.read(chatProvider.notifier).ensureChatListConnected();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isAuthenticated = chatState.isAuthenticated;
    final allChatRooms = chatState.chatRooms;
    final blockedUserIds = chatState.blockedUserIds;
    final isLoading = chatState.isLoading;
    final localizations = AppLocalizations.of(context);

    // 🔥 NEW: Filter out chat rooms with blocked users (Karrot-style)
    final chatRooms = allChatRooms.where((room) {
      // For direct chats, check if the other participant is blocked
      if (!room.isGroup && room.participants.isNotEmpty) {
        final otherUser = room.participants.firstWhere(
          (p) => p.id != chatState.currentUserId,
          orElse: () => room.participants.first,
        );
        return !blockedUserIds.contains(otherUser.id);
      }
      // For group chats, show them (can't block groups)
      return true;
    }).toList();

    // Don't build until initialized
    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isAuthenticated) {
      final l = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(l.messages)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                    l.please_log_in,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.messages_and_conversations ?? 'Messages'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            child: NotificationBell(
              provider: chatNotificationProvider,
              iconColor: null, // Use default AppBar icon color
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserListScreen()),
              );
            },
            tooltip: localizations?.new_message ?? 'New Message',
          ),
          // 🔥 NEW: Blocked users menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'blocked') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BlockedUsersScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) {
              final l = AppLocalizations.of(context)!;
              return [
                PopupMenuItem(
                  value: 'blocked',
                  child: Row(
                    children: [
                      const Icon(Icons.block, size: 20),
                      const SizedBox(width: 8),
                      Text(l.blocked_users),
                    ],
                  ),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (mounted) {
                ref.read(chatProvider.notifier).loadChatRooms();
                ref.read(chatProvider.notifier).loadBlockedUsers();
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : chatRooms.isEmpty
          ? _buildEmptyState(context)
          : RefreshIndicator(
              onRefresh: () async {
                if (mounted) {
                  await ref.read(chatProvider.notifier).loadChatRooms();
                  await ref.read(chatProvider.notifier).loadBlockedUsers();
                }
              },
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: chatRooms.length,
                separatorBuilder: (context, index) => Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 80, // Align with content (avatar + padding)
                  color: Colors.grey[200],
                ),
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return _buildSwipeableChatTile(
                    context,
                    chatRoom,
                    chatState.currentUserId!,
                    () {
                      if (mounted) {
                        context.push('/chat/${chatRoom.id}');
                      }
                    },
                  );
                },
              ),
            ),
    );
  }

  // 🔥 NEW: Swipeable chat tile with delete action
  Widget _buildSwipeableChatTile(
    BuildContext context,
    ChatRoom chatRoom,
    int currentUserId,
    VoidCallback onTap,
  ) {
    final l = AppLocalizations.of(context)!;
    return Dismissible(
      key: Key('chat_${chatRoom.id}'),
      direction: DismissDirection.endToStart, // Swipe left to delete
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete, color: Colors.white, size: 28),
            const SizedBox(height: 4),
            Text(
              l.delete,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            final l = AppLocalizations.of(context)!;
            return AlertDialog(
              title: Text(l.delete_chat),
              content: Text(
                l.delete_chat_confirm(chatRoom.name),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    l.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
        return confirmed ?? false;
      },
      onDismissed: (direction) async {
        // Delete the chat room
        if (mounted) {
          final success = await ref
              .read(chatProvider.notifier)
              .deleteChatRoom(chatRoom.id);
          if (mounted) {
            final l = AppLocalizations.of(context)!;
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.chat_deleted(chatRoom.name)),
                  backgroundColor: Colors.green,
                  action: SnackBarAction(
                    label: 'Undo',
                    textColor: Colors.white,
                    onPressed: () {
                      // Note: Undo would require restoring the chat room
                      // This would need backend support for undo functionality
                    },
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.delete_failed),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      },
      child: ChatListTile(
        chatRoom: chatRoom,
        currentUserId: currentUserId,
        onTap: onTap,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            l.no_conversations,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.start_conversation_hint,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserListScreen(),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: Text(l.start_conversation),
          ),
        ],
      ),
    );
  }
}

class ChatListTile extends StatelessWidget {
  final ChatRoom chatRoom;
  final int currentUserId;
  final VoidCallback onTap;

  const ChatListTile({
    super.key,
    required this.chatRoom,
    required this.currentUserId,
    required this.onTap,
  });

  String _formatTimestamp(DateTime? timestamp, BuildContext context) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final l = AppLocalizations.of(context)!;

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return l.yesterday;
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = chatRoom.unreadCount > 0;
    final l = AppLocalizations.of(context)!;

    // Handle empty name
    final displayName = chatRoom.name.isNotEmpty ? chatRoom.name : l.unknown;
    final avatarLetter = displayName[0].toUpperCase();

    // Get other user for online status (for direct chats)
    User? otherUser;
    if (!chatRoom.isGroup && chatRoom.participants.isNotEmpty) {
      otherUser = chatRoom.participants.firstWhere(
        (p) => p.id != currentUserId,
        orElse: () => chatRoom.participants.first,
      );
    }

    // KakaoTalk-style clean chat list tile
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.grey[200],
          highlightColor: Colors.grey[100],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile avatar - KakaoTalk style (cleaner, no gradient)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Text(
                          avatarLetter,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    // Online status indicator - subtle green dot
                    if (otherUser != null && otherUser.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CD964), // KakaoTalk green
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Message content - KakaoTalk style layout
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name and timestamp row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: hasUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(chatRoom.lastMessageTimestamp, context),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Message preview and unread count row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatRoom.lastMessagePreview?.isEmpty ?? true
                                  ? l.no_messages_yet
                                  : chatRoom.lastMessagePreview!,
                              style: TextStyle(
                                color: hasUnread
                                    ? Colors.black87
                                    : Colors.grey[600],
                                fontWeight: hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.w400,
                                fontSize: 13,
                                letterSpacing: -0.1,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: chatRoom.unreadCount > 99 ? 6 : 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFA3E3E), // KakaoTalk red
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Center(
                                child: Text(
                                  chatRoom.unreadCount > 99
                                      ? '99+'
                                      : '${chatRoom.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
