import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 NEW: Task 16 — modal sheet for forwarding a message to one of the
/// user's OTHER chat rooms (the room the message currently lives in is
/// excluded). Reuses the chat-list row visual (listing thumbnail/avatar +
/// name, see `chat_list.dart`'s `ChatListTile`) with a small client-side
/// search filter on top. Tapping a room forwards immediately, closes the
/// sheet, and shows a snackbar confirmation — there's no navigation to the
/// target room.
class ForwardPickerSheet extends ConsumerStatefulWidget {
  final int messageId;
  final int currentRoomId;

  const ForwardPickerSheet({
    super.key,
    required this.messageId,
    required this.currentRoomId,
  });

  @override
  ConsumerState<ForwardPickerSheet> createState() =>
      _ForwardPickerSheetState();
}

class _ForwardPickerSheetState extends ConsumerState<ForwardPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  int? _forwardingToRoomId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _forwardTo(ChatRoom room) async {
    // Already forwarding to some room — ignore extra taps.
    if (_forwardingToRoomId != null) return;
    setState(() => _forwardingToRoomId = room.id);

    final success = await ref
        .read(chatProvider.notifier)
        .forwardMessage(widget.messageId, room.id);

    if (!mounted) return;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l = AppLocalizations.of(context)!;
    final errorColor = Theme.of(context).colorScheme.error;

    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(success ? l.chatForwarded : l.unknown_error),
        backgroundColor: success ? null : errorColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final chatState = ref.watch(chatProvider);

    final otherRooms =
        chatState.chatRooms.where((r) => r.id != widget.currentRoomId).toList();

    final filtered = _query.trim().isEmpty
        ? otherRooms
        : otherRooms
            .where((r) => r.name.toLowerCase().contains(_query.trim().toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l.chatForwardTo,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: l.search,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      isDense: true,
                      filled: true,
                      fillColor: theme.colorScheme.surfaceContainerHighest,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            l.no_conversations,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final room = filtered[index];
                            return _ForwardRoomTile(
                              room: room,
                              isForwarding: _forwardingToRoomId == room.id,
                              disabled: _forwardingToRoomId != null &&
                                  _forwardingToRoomId != room.id,
                              onTap: () => _forwardTo(room),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Single room row — mirrors the chat-list tile's thumbnail/avatar + name
/// visual (see `ChatListTile._buildLeadingImage`), simplified for the
/// picker (no unread badge, timestamp, or online dot).
class _ForwardRoomTile extends StatelessWidget {
  final ChatRoom room;
  final bool isForwarding;
  final bool disabled;
  final VoidCallback onTap;

  const _ForwardRoomTile({
    required this.room,
    required this.isForwarding,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final displayName = room.name.isNotEmpty ? room.name : l.unknown;
    final avatarLetter = displayName[0].toUpperCase();
    final hasThumbnail = room.listing?.imageUrl?.isNotEmpty ?? false;

    return ListTile(
      enabled: !disabled,
      onTap: disabled ? null : onTap,
      leading: hasThumbnail
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImageWidget(
                imageUrl: room.listing!.imageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            )
          : CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                avatarLetter,
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      title: Text(
        displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      subtitle: room.listing != null
          ? Text(
              room.listing!.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            )
          : null,
      trailing: isForwarding
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }
}
