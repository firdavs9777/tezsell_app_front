import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final ChatRoom chatRoom;
  final VoidCallback onInfoTap;
  final VoidCallback onBlockTap;
  final VoidCallback onDeleteTap;

  /// 🔥 NEW: Task 18 — opens the inline in-room search bar (replaces this
  /// app bar entirely while active).
  final VoidCallback? onSearchTap;

  /// 🔥 NEW: Task 18 — opens the media gallery screen (room menu entry).
  final VoidCallback? onMediaGalleryTap;

  const ChatAppBar({
    super.key,
    required this.chatRoom,
    required this.onInfoTap,
    required this.onBlockTap,
    required this.onDeleteTap,
    this.onSearchTap,
    this.onMediaGalleryTap,
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

    // 🔥 NEW: Task 13 — seller reserve/sold/available menu, product rooms
    // only. Status reflects any local override applied from the transaction
    // API response / `transaction_updated` WS event ahead of a full refetch.
    final listing = chatRoom.listing;
    final listingStatusOverride = chatState.listingStatusOverrides[chatRoom.id];
    final effectiveListingStatus =
        listingStatusOverride ?? listing?.status ?? 'available';
    final isSellerProductRoom = listing != null &&
        listing.type == 'product' &&
        currentUserId != null &&
        listing.sellerId != null &&
        currentUserId == listing.sellerId;

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
                                ? const Color(0xFF4CAF50) // Standard green for online
                                : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
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
                  String subtitle;
                  if (chatRoom.isGroup) {
                    subtitle = l.participants(chatRoom.participants.length);
                  } else if (chatState.typingUsers.entries
                      .where((e) => e.key != currentUserId && e.value)
                      .isNotEmpty) {
                    subtitle = l.typing;
                  } else {
                    // Check actual online status
                    final user = chatRoom.participants.firstWhere(
                      (p) => p.id != currentUserId,
                      orElse: () => chatRoom.participants.first,
                    );
                    final onlineUser = chatState.onlineUsers[user.id];
                    final isOnline = onlineUser?.isOnline ?? user.isOnline;
                    final lastSeen = onlineUser?.lastSeen ?? user.lastSeen;

                    if (isOnline) {
                      subtitle = l.online;
                    } else if (lastSeen != null) {
                      final now = DateTime.now();
                      final diff = now.difference(lastSeen);
                      String timeStr;
                      if (diff.inMinutes < 1) {
                        timeStr = 'just now';
                      } else if (diff.inHours < 1) {
                        timeStr = '${diff.inMinutes}m ago';
                      } else if (diff.inDays < 1) {
                        timeStr = DateFormat.Hm().format(lastSeen);
                      } else if (diff.inDays < 7) {
                        timeStr = DateFormat.E().add_Hm().format(lastSeen);
                      } else {
                        timeStr = DateFormat.MMMd().format(lastSeen);
                      }
                      subtitle = l.last_seen_at(timeStr);
                    } else {
                      subtitle = l.offline;
                    }
                  }
                  return Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // 🔥 NEW: Task 18 — in-room search icon (swaps this app bar for
        // ChatSearchBar).
        if (onSearchTap != null)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: onSearchTap,
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
              // 🔥 NEW: Task 18 — media gallery (Images/Voice tabs) built
              // from the loaded messages of this room.
              if (onMediaGalleryTap != null)
                PopupMenuItem(
                  value: 'media_gallery',
                  child: Row(
                    children: [
                      const Icon(Icons.perm_media_outlined, size: 20),
                      const SizedBox(width: 8),
                      Text(l?.chatMediaGallery ?? 'Media'),
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
              // 🔥 NEW: Task 13 — seller-only reserve/sold/available actions,
              // items depend on the listing's current status.
              if (isSellerProductRoom) ...[
                if (effectiveListingStatus == 'available') ...[
                  PopupMenuItem(
                    value: 'reserve',
                    child: Row(
                      children: [
                        const Icon(Icons.bookmark_add_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l?.chatReserve ?? 'Reserve'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'sold',
                    child: Row(
                      children: [
                        const Icon(Icons.sell_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l?.chatMarkSold ?? 'Mark as sold'),
                      ],
                    ),
                  ),
                ] else if (effectiveListingStatus == 'reserved') ...[
                  PopupMenuItem(
                    value: 'sold',
                    child: Row(
                      children: [
                        const Icon(Icons.sell_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l?.chatMarkSold ?? 'Mark as sold'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'available',
                    child: Row(
                      children: [
                        const Icon(Icons.restore_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l?.chatMarkAvailable ?? 'Back to available'),
                      ],
                    ),
                  ),
                ] else if (effectiveListingStatus == 'sold') ...[
                  PopupMenuItem(
                    value: 'available',
                    child: Row(
                      children: [
                        const Icon(Icons.restore_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(l?.chatMarkAvailable ?? 'Back to available'),
                      ],
                    ),
                  ),
                ],
              ],
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
            } else if (value == 'reserve' || value == 'sold' || value == 'available') {
              _handleTransactionAction(context, ref, value);
            } else if (value == 'media_gallery') {
              onMediaGalleryTap?.call();
            }
          },
        ),
      ],
    );
  }

  /// 🔥 NEW: Task 13 — seller reserve/sold/available action. The listing
  /// status chip/menu update via [ChatNotifier.updateTransactionStatus]
  /// (local override applied from the response) and the system message(s)
  /// arrive over the room's existing WebSocket message stream.
  void _handleTransactionAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final success = await ref
        .read(chatProvider.notifier)
        .updateTransactionStatus(chatRoom.id, action);

    if (!success && context.mounted) {
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l?.something_went_wrong ?? 'Something went wrong'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

