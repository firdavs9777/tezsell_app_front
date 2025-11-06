import 'package:app/pages/chat//chat_room.dart';
import 'package:app/pages/chat/user_list.dart';
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

class _MessagesListState extends ConsumerState<MessagesList> {
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize chat on first load - FIXED
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
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final isAuthenticated = chatState.isAuthenticated;
    final chatRooms = chatState.chatRooms;
    final isLoading = chatState.isLoading;

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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (mounted) {
                ref.read(chatProvider.notifier).loadChatRooms();
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
                    }
                  },
                  child: ListView.separated(
                    itemCount: chatRooms.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final chatRoom = chatRooms[index];
                      return ChatListTile(
                        chatRoom: chatRoom,
                        currentUserId: chatState.currentUserId!,
                        onTap: () {
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

// Chat List Tile Widget (no changes needed but included for completeness)
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
    print(chatRoom.lastMessagePreview);
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          chatRoom.name[0].toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        chatRoom.name,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        chatRoom.lastMessagePreview?.isEmpty ?? true
            ? 'No messages yet'
            : chatRoom.lastMessagePreview!,
        style: TextStyle(
          color: hasUnread ? Colors.black87 : Colors.grey,
          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatTimestamp(chatRoom.lastMessageTimestamp),
            style: TextStyle(
              fontSize: 12,
              color: hasUnread ? Colors.blue : Colors.grey,
              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (hasUnread) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${chatRoom.unreadCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
