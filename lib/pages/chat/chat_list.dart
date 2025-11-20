import 'package:app/pages/chat//chat_room.dart';
import 'package:app/pages/chat/user_list.dart';
import 'package:app/pages/chat/blocked_users_screen.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Messages'),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please log in to view messages',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserListScreen(),
                ),
              );
            },
            tooltip: 'New Message',
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
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'blocked',
                child: Row(
                  children: [
                    Icon(Icons.block, size: 20),
                    SizedBox(width: 8),
                    Text('Blocked Users'),
                  ],
                ),
              ),
            ],
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
                      height: 1,
                      thickness: 0.5,
                      indent: 84, // Align with content (avatar + padding)
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatRoomScreen(
                                  chatRoom: chatRoom,
                                ),
                              ),
                            );
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
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
              size: 28,
            ),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
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
          builder: (context) => AlertDialog(
            title: const Text('Delete Chat'),
            content: Text(
              'Are you sure you want to delete the chat with ${chatRoom.name}? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        return confirmed ?? false;
      },
      onDismissed: (direction) async {
        // Delete the chat room
        if (mounted) {
          final success = await ref.read(chatProvider.notifier).deleteChatRoom(chatRoom.id);
          if (mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Chat with ${chatRoom.name} deleted'),
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
                const SnackBar(
                  content: Text('Failed to delete chat'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a conversation by tapping the + button',
            style: TextStyle(color: Colors.grey),
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
            label: const Text('Start a Conversation'),
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

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat('EEEE').format(timestamp);
    } else {
      return DateFormat('dd/MM/yyyy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = chatRoom.unreadCount > 0;

    // 🔥 FIX: Handle empty name
    final displayName = chatRoom.name.isNotEmpty ? chatRoom.name : 'Unknown';
    final avatarLetter = displayName[0].toUpperCase();
    
    // 🔥 NEW: Get other user for online status (for direct chats)
    User? otherUser;
    if (!chatRoom.isGroup && chatRoom.participants.isNotEmpty) {
      otherUser = chatRoom.participants.firstWhere(
        (p) => p.id != currentUserId,
        orElse: () => chatRoom.participants.first,
      );
    }

    // 🔥 NEW: KakaoTalk-style modern chat list tile
    return Container(
      color: Colors.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // 🔥 NEW: Larger avatar (KakaoTalk style)
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: hasUnread
                              ? [Colors.blue[400]!, Colors.blue[600]!]
                              : [Colors.grey[400]!, Colors.grey[600]!],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          avatarLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    // Online status indicator (smaller, more subtle)
                    if (otherUser != null && otherUser.isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              displayName,
                              style: TextStyle(
                                fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                                fontSize: 17,
                                color: Colors.black87,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(chatRoom.lastMessageTimestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              chatRoom.lastMessagePreview?.isEmpty ?? true
                                  ? 'No messages yet'
                                  : chatRoom.lastMessagePreview!,
                              style: TextStyle(
                                color: hasUnread ? Colors.black87 : Colors.grey[600],
                                fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                                fontSize: 14,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: chatRoom.unreadCount > 99 ? 7 : 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[500],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 20,
                                minHeight: 20,
                              ),
                              child: Center(
                                child: Text(
                                  chatRoom.unreadCount > 99 ? '99+' : '${chatRoom.unreadCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
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
