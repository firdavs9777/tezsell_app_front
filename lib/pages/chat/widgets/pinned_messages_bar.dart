import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔥 NEW: Task 16 — slim bar under the app bar shown whenever the loaded
/// message list contains at least one pinned message.
///
/// - Shows a pin icon + a one-line snippet of the "current" pinned message
///   (most recently pinned first).
/// - TAP scrolls to (and flash-highlights, via [onTapMessage] → the
///   chat room's Task-14 scroll-to-message mechanism) the current pinned
///   message, then cycles to the next one.
/// - LONG-PRESS asks for confirmation and unpins the currently shown one.
///
/// Reads pin state live from [chatProvider], so pins/unpins from this
/// client, the actions sheet, or the `message_pinned` WS relay all update
/// the bar immediately.
class PinnedMessagesBar extends ConsumerStatefulWidget {
  /// Called with the pinned message's id on tap — the chat room wires this
  /// to its scroll-to-message + flash-highlight mechanism.
  final void Function(int messageId) onTapMessage;

  const PinnedMessagesBar({super.key, required this.onTapMessage});

  @override
  ConsumerState<PinnedMessagesBar> createState() => _PinnedMessagesBarState();
}

class _PinnedMessagesBarState extends ConsumerState<PinnedMessagesBar> {
  /// Index into the most-recent-first pinned list of the message the bar is
  /// currently showing. Clamped in build() so live unpins can't leave it
  /// dangling past the end of a shrunken list.
  int _cycleIndex = 0;

  /// Pinned messages in the loaded list, most recently pinned first.
  List<ChatMessage> _pinnedMessages(List<ChatMessage> messages) {
    final pinned = messages.where((m) => m.isPinned && m.id != null).toList();
    pinned.sort((a, b) {
      final aTime = a.pinnedAt ?? a.timestamp;
      final bTime = b.pinnedAt ?? b.timestamp;
      return bTime.compareTo(aTime);
    });
    return pinned;
  }

  String _snippet(BuildContext context, ChatMessage message) {
    final l = AppLocalizations.of(context)!;
    if (message.messageType == MessageType.image) return l.photo;
    if (message.messageType == MessageType.voice) return l.voice_message;
    return message.content ?? '';
  }

  void _handleTap(List<ChatMessage> pinned) {
    if (pinned.isEmpty) return;
    final current = pinned[_cycleIndex];
    widget.onTapMessage(current.id!);
    // Advance to the next pinned message (wrapping) for the next tap.
    setState(() => _cycleIndex = (_cycleIndex + 1) % pinned.length);
  }

  Future<void> _handleLongPress(List<ChatMessage> pinned) async {
    if (pinned.isEmpty) return;
    final current = pinned[_cycleIndex];
    final l = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.chatUnpin),
        content: Text(
          _snippet(dialogContext, current),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l.chatUnpin),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(chatProvider.notifier).togglePinMessage(current.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider).messages;
    final pinned = _pinnedMessages(messages);

    if (pinned.isEmpty) return const SizedBox.shrink();

    // Live updates (unpins from anywhere) can shrink the list under us.
    if (_cycleIndex >= pinned.length) _cycleIndex = 0;

    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final current = pinned[_cycleIndex];

    return Material(
      color: colorScheme.surface,
      child: InkWell(
        onTap: () => _handleTap(pinned),
        onLongPress: () => _handleLongPress(pinned),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.push_pin, size: 16, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pinned.length > 1
                          ? '${l.chatPinnedMessages} (${_cycleIndex + 1}/${pinned.length})'
                          : l.chatPinnedMessages,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      _snippet(context, current),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
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
}
