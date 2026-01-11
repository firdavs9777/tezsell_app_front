import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

    // Get other user for profile navigation (for direct chats)
    final otherUser = chatRoom.participants.isNotEmpty && !chatRoom.isGroup
        ? chatRoom.participants.firstWhere(
            (p) => p.id != currentUserId,
            orElse: () => chatRoom.participants.first,
          )
        : null;

    return AppBar(
      titleSpacing: 0,
      title: InkWell(
        onTap: otherUser != null
            ? () => context.push('/user/${otherUser.id}')
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      chatRoom.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Online status indicator
                  if (chatRoom.participants.isNotEmpty)
                    Builder(
                      builder: (context) {
                        final user = chatRoom.participants.firstWhere(
                          (p) => p.id != currentUserId,
                          orElse: () => chatRoom.participants.first,
                        );
                        final onlineUser = chatState.onlineUsers[user.id];
                        final isOnline = onlineUser?.isOnline ?? user.isOnline;
                        return Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOnline
                                ? (Theme.of(context).brightness == Brightness.dark
                                    ? Theme.of(context).colorScheme.primary
                                    : const Color(0xFF43A047))
                                : Theme.of(context).colorScheme.onSurfaceVariant,
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
        ),
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
            final l = AppLocalizations.of(context);
            return [
              // View profile option (for direct chats)
              if (!chatRoom.isGroup && otherUser != null)
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person_outline, size: 20),
                      const SizedBox(width: 8),
                      Text('Profilni ko\'rish'),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'info',
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 20),
                    const SizedBox(width: 8),
                    Text(l?.chat_info ?? 'Chat ma\'lumotlari'),
                  ],
                ),
              ),
              // Block user option (for direct chats)
              if (!chatRoom.isGroup && chatRoom.participants.isNotEmpty)
                PopupMenuItem(
                  value: 'block',
                  child: Row(
                    children: [
                      const Icon(Icons.block, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        chatState.blockedUserIds.contains(
                          chatRoom.participants
                              .firstWhere((p) => p.id != currentUserId,
                                  orElse: () => chatRoom.participants.first)
                              .id,
                        )
                            ? (l?.unblock_user ?? 'Blokdan chiqarish')
                            : (l?.block_user ?? 'Bloklash'),
                      ),
                    ],
                  ),
                ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Text(
                      l?.delete_chat ?? 'Chatni o\'chirish',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
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
            } else if (value == 'profile' && otherUser != null) {
              context.push('/user/${otherUser.id}');
            }
          },
        ),
      ],
    );
  }
}

