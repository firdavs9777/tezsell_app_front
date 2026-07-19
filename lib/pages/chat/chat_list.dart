import 'package:app/pages/chat/blocked_users_screen.dart';
import 'package:app/pages/chat/widgets/chat_shimmer.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/notification_bell.dart';
import 'package:app/providers/provider_root/notification_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

// Avatar color palette — consistent per-user color from name hash
const _avatarColors = [
  Color(0xFFE57373), // red
  Color(0xFFFF8A65), // deep orange
  Color(0xFFFFB74D), // orange
  Color(0xFFFFD54F), // amber
  Color(0xFF81C784), // green
  Color(0xFF4DB6AC), // teal
  Color(0xFF4FC3F7), // light blue
  Color(0xFF7986CB), // indigo
  Color(0xFFBA68C8), // purple
  Color(0xFFF06292), // pink
];

Color _avatarColor(String name) {
  if (name.isEmpty) return _avatarColors[0];
  int hash = 0;
  for (int i = 0; i < name.length; i++) {
    hash = name.codeUnitAt(i) + ((hash << 5) - hash);
  }
  return _avatarColors[hash.abs() % _avatarColors.length];
}

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
      ref.read(chatProvider.notifier).ensureChatListConnected();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && _isInitialized) {
      Future.microtask(() {
        if (!mounted) return;
        final notifier = ref.read(chatProvider.notifier);
        notifier.ensureChatListConnected();
        // If the chat list is becoming active again and there's a stale room
        // error (from a failed room WebSocket), reload rooms so it's cleared.
        if (ref.read(chatProvider).error != null) {
          print('🔵 [ChatList] didChangeDependencies — stale error found, reloading rooms');
          notifier.loadChatRooms();
        }
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
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Filter out blocked users
    final chatRooms = allChatRooms.where((room) {
      if (!room.isGroup && room.participants.isNotEmpty) {
        final otherUser = room.participants.firstWhere(
          (p) => p.id != chatState.currentUserId,
          orElse: () => room.participants.first,
        );
        return !blockedUserIds.contains(otherUser.id);
      }
      return true;
    }).toList();

    // Sort: pinned first, then by last message time
    chatRooms.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      final aTime = a.lastMessageTimestamp ?? a.createdAt ?? DateTime(2000);
      final bTime = b.lastMessageTimestamp ?? b.createdAt ?? DateTime(2000);
      return bTime.compareTo(aTime);
    });

    if (!_isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: Text(l.messages)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.chat_bubble_outline_rounded, size: 48, color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
              Text(
                l.please_log_in,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.messages,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          NotificationBell(
            provider: chatNotificationProvider,
            iconColor: null,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz),
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
              return [
                PopupMenuItem(
                  value: 'blocked',
                  child: Row(
                    children: [
                      Icon(Icons.block, size: 20, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 12),
                      Text(l.blocked_users),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: isLoading
          ? const ChatListShimmer()
          : chatState.error != null
              ? Builder(builder: (ctx) {
                  print('🔴 [ChatList] showing error state: "${chatState.error}"');
                  return _buildErrorState(ctx, chatState.error!);
                })
              : chatRooms.isEmpty
                  ? _buildEmptyState(context)
                  : RefreshIndicator(
                      color: colorScheme.primary,
                      onRefresh: () async {
                        if (mounted) {
                          await ref.read(chatProvider.notifier).loadChatRooms();
                          await ref.read(chatProvider.notifier).loadBlockedUsers();
                        }
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 4),
                        itemCount: chatRooms.length,
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

  Widget _buildSwipeableChatTile(
    BuildContext context,
    ChatRoom chatRoom,
    int currentUserId,
    VoidCallback onTap,
  ) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key('chat_${chatRoom.id}'),
      direction: DismissDirection.horizontal,
      background: Container(
        color: chatRoom.isPinned
            ? colorScheme.surfaceContainerHighest
            : colorScheme.primary,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        child: Icon(
          chatRoom.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
          color: chatRoom.isPinned ? colorScheme.onSurfaceVariant : Colors.white,
          size: 24,
        ),
      ),
      secondaryBackground: Container(
        color: colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (direction) async {
        HapticFeedback.mediumImpact();
        if (direction == DismissDirection.startToEnd) {
          await ref.read(chatProvider.notifier).togglePinChat(chatRoom.id);
          return false;
        }
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text(l.delete_chat),
              content: Text(l.delete_chat_confirm(chatRoom.name)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: Text(l.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, true),
                  child: Text(
                    l.delete,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ),
              ],
            );
          },
        );
        return confirmed ?? false;
      },
      onDismissed: (direction) async {
        if (mounted) {
          final success = await ref
              .read(chatProvider.notifier)
              .deleteChatRoom(chatRoom.id);
          if (mounted) {
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.chat_deleted(chatRoom.name)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.delete_failed),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.forum_outlined,
                size: 44,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.no_conversations,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.start_conversation_hint,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                size: 40,
                color: colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l.something_went_wrong,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l.check_connection_and_retry,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () {
                if (mounted) {
                  ref.read(chatProvider.notifier).loadChatRooms();
                }
              },
              icon: const Icon(Icons.refresh, size: 20),
              label: Text(l.retry),
            ),
          ],
        ),
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
    final today = DateTime(now.year, now.month, now.day);
    final msgDay = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final difference = today.difference(msgDay).inDays;
    final l = AppLocalizations.of(context)!;

    if (difference == 0) {
      return DateFormat('HH:mm').format(timestamp);
    } else if (difference == 1) {
      return l.yesterday;
    } else if (difference < 7) {
      return DateFormat('EEE').format(timestamp); // Mon, Tue...
    } else {
      return DateFormat('dd.MM.yy').format(timestamp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasUnread = chatRoom.unreadCount > 0;
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final displayName = chatRoom.name.isNotEmpty ? chatRoom.name : l.unknown;
    final avatarLetter = displayName[0].toUpperCase();
    final bgColor = _avatarColor(displayName);

    // Get other user for online status
    User? otherUser;
    if (!chatRoom.isGroup && chatRoom.participants.isNotEmpty) {
      otherUser = chatRoom.participants.firstWhere(
        (p) => p.id != currentUserId,
        orElse: () => chatRoom.participants.first,
      );
    }

    return Material(
      color: chatRoom.isPinned
          ? (isDark ? colorScheme.surfaceContainerHigh : colorScheme.surfaceContainerLowest)
          : colorScheme.surface,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Listing thumbnail (falls back to the user avatar when the
              // room isn't anchored to a listing, or the listing has none)
              _buildLeadingImage(
                context,
                listing: chatRoom.listing,
                avatarLetter: avatarLetter,
                bgColor: bgColor,
                isOnline: otherUser?.isOnline ?? false,
                isDark: isDark,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: name + time
                    Row(
                      children: [
                        if (chatRoom.isPinned) ...[
                          Icon(
                            Icons.push_pin,
                            size: 13,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            displayName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w500,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTimestamp(chatRoom.lastMessageTimestamp, context),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: hasUnread
                                ? colorScheme.primary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    if (chatRoom.listing != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _listingSubtitle(chatRoom.listing!),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    // Bottom row: message preview + unread badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatRoom.lastMessagePreview?.isEmpty ?? true
                                ? l.no_messages_yet
                                : chatRoom.lastMessagePreview!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: hasUnread
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.w400,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: chatRoom.unreadCount > 99 ? 6 : 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Center(
                              child: Text(
                                chatRoom.unreadCount > 99
                                    ? '99+'
                                    : '${chatRoom.unreadCount}',
                                style: TextStyle(
                                  color: colorScheme.onPrimary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
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
    );
  }

  // 🔥 NEW: "$title · $price $currency" preview line for listing-anchored
  // rooms, shown under the participant name.
  String _listingSubtitle(ChatListing listing) {
    final title = listing.title;
    if (listing.price == null || listing.price!.isEmpty) return title;
    final currency = listing.currency ?? '';
    final priceLine = currency.isNotEmpty
        ? '${listing.price} $currency'
        : listing.price!;
    return '$title · $priceLine';
  }

  // 🔥 NEW: Listing thumbnail when the room is anchored to a product/
  // service/property listing with an image; falls back to the normal
  // per-user avatar otherwise.
  Widget _buildLeadingImage(
    BuildContext context, {
    required ChatListing? listing,
    required String avatarLetter,
    required Color bgColor,
    required bool isOnline,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    if (listing != null && (listing.imageUrl?.isNotEmpty ?? false)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImageWidget(
          imageUrl: listing.imageUrl,
          width: 54,
          height: 54,
          fit: BoxFit.cover,
        ),
      );
    }
    return _buildAvatar(
      context,
      avatarLetter: avatarLetter,
      bgColor: bgColor,
      isOnline: isOnline,
      isDark: isDark,
      colorScheme: colorScheme,
    );
  }

  Widget _buildAvatar(
    BuildContext context, {
    required String avatarLetter,
    required Color bgColor,
    required bool isOnline,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    return SizedBox(
      width: 54,
      height: 54,
      child: Stack(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? bgColor.withValues(alpha: 0.85) : bgColor,
            ),
            child: Center(
              child: Text(
                avatarLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CD964),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.surface,
                    width: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
