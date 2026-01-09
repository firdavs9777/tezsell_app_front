import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ChatRoom chatRoom;
  final VoidCallback onInfoTap;
  final VoidCallback onBlockTap;
  final VoidCallback onDeleteTap;

  const ChatAppBar({
    super.key,
    required this.chatRoom,
    required this.onInfoTap,
    required this.onBlockTap,
    required this.onDeleteTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final currentUserId = chatState.currentUserId;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(chatRoom.name),
              const SizedBox(width: 8),
              // Online status indicator
              if (chatRoom.participants.isNotEmpty)
                Builder(
                  builder: (context) {
                    final otherUser = chatRoom.participants.firstWhere(
                      (p) => p.id != currentUserId,
                      orElse: () => chatRoom.participants.first,
                    );
                    final onlineUser = chatState.onlineUsers[otherUser.id];
                    final isOnline = onlineUser?.isOnline ?? otherUser.isOnline;
                    return Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
            ],
          ),
          Builder(
            builder: (context) {
              final l = AppLocalizations.of(context)!;
              return Text(
                chatRoom.isGroup
                    ? l.participants(chatRoom.participants.length)
                    : chatState.typingUsers.entries
                            .where((e) => e.key != currentUserId && e.value)
                            .isNotEmpty
                        ? l.typing
                        : l.online,
                style: const TextStyle(fontSize: 12),
              );
            },
          ),
        ],
      ),
      actions: [
        // Voice call button
        IconButton(
          icon: const Icon(Icons.phone),
          onPressed: () {
            ref.read(chatProvider.notifier).initiateCall('voice');
          },
        ),
        // Video call button
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {
            ref.read(chatProvider.notifier).initiateCall('video');
          },
        ),
        PopupMenuButton(
          itemBuilder: (context) {
            final l = AppLocalizations.of(context)!;
            return [
              PopupMenuItem(
                value: 'info',
                child: Text(l.chat_info),
              ),
              // Block user option (for direct chats)
              if (!chatRoom.isGroup && chatRoom.participants.isNotEmpty)
                PopupMenuItem(
                  value: 'block',
                  child: Text(
                    chatState.blockedUserIds.contains(
                      chatRoom.participants
                          .firstWhere((p) => p.id != currentUserId,
                              orElse: () => chatRoom.participants.first)
                          .id,
                    )
                        ? l.unblock_user
                        : l.block_user,
                  ),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Text(l.delete_chat),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'delete') {
              onDeleteTap();
            } else if (value == 'info') {
              onInfoTap();
            } else if (value == 'block') {
              onBlockTap();
            }
          },
        ),
      ],
    );
  }
}

