import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/pages/chat/widgets/chat_shimmer.dart';
import 'package:app/pages/chat/widgets/swipeable_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'message_bubble.dart';
import 'date_separator.dart';
import 'chat_helpers.dart';
import 'unread_divider.dart';

class MessageList extends ConsumerWidget {
  final ScrollController scrollController;
  final int? currentlyPlayingMessageId;
  final PlayerState audioPlayerState;

  /// 🔥 NEW: Task 17 — forwarded to [MessageBubble]/`VoiceBubble` for the
  /// played-progress waveform fill on the currently-playing voice bubble.
  final Duration playbackPosition;
  final Function(ChatMessage) onAudioTap;
  final Function(ChatMessage, int) onMessageLongPress;
  final Function(int)? onReplyTap; // Callback when reply preview is tapped
  final Function(ChatMessage)? onMessageSwipeReply; // Callback when message is swiped right to reply

  /// 🔥 NEW: Task 13 — anchored listing's seller id, forwarded to
  /// [MessageBubble] so it can tell whether the current user is the buyer
  /// for a `review_cta` system message.
  final int? listingSellerId;

  /// 🔥 NEW: E4 — forwarded to [MessageBubble] to pre-fill the write-review
  /// screen's counterparty/item context for a `review_cta` system message.
  final String? reviewCounterpartyName;
  final String? reviewItemTitle;
  final String? reviewItemImage;

  /// 🔥 NEW: Task 14 — id of the message currently flashed after a
  /// tap-to-scroll from a quoted reply block, forwarded to [MessageBubble]
  /// so it can render a brief highlight.
  final int? highlightedMessageId;

  /// 🔥 NEW: Task 20 — id of the first unread message, computed once by
  /// `ChatRoomScreen` when the room's messages first finish loading. An
  /// [UnreadDivider] row is rendered directly above this message; null once
  /// there was nothing unread at open (or after the room has no messages).
  final int? unreadDividerMessageId;

  const MessageList({
    super.key,
    required this.scrollController,
    required this.currentlyPlayingMessageId,
    required this.audioPlayerState,
    this.playbackPosition = Duration.zero,
    required this.onAudioTap,
    required this.onMessageLongPress,
    this.onReplyTap,
    this.onMessageSwipeReply,
    this.listingSellerId,
    this.reviewCounterpartyName,
    this.reviewItemTitle,
    this.reviewItemImage,
    this.highlightedMessageId,
    this.unreadDividerMessageId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final isLoadingMessages = chatState.isLoadingMessages;
    final currentUserId = chatState.currentUserId;
    // Use cached sorted provider to avoid O(n log n) sort on every rebuild
    final sortedMessages = ref.watch(sortedMessagesProvider);
    // 🔥 FIX: Task 18 review — ids currently displaying original text
    // instead of their cached translation (see showingOriginalTranslationsProvider).
    final showingOriginalIds = ref.watch(showingOriginalTranslationsProvider);

    if (isLoadingMessages) {
      return const MessageListShimmer();
    }

    if (sortedMessages.isEmpty) {
      return const SizedBox.shrink(); // Empty state is handled by parent
    }

    return ListView.builder(
      controller: scrollController,
      reverse: false,
      padding: const EdgeInsets.all(16),
      itemCount: sortedMessages.length + (chatState.isLoadingOlderMessages ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at top when loading older messages
        if (index == 0 && chatState.isLoadingOlderMessages) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final messageIndex = chatState.isLoadingOlderMessages ? index - 1 : index;
        final message = sortedMessages[messageIndex];
        final isOwnMessage = message.sender.id == currentUserId;
        // 🔥 NEW: Task 13 — system messages (pill style) aren't interactive:
        // no long-press options sheet, no swipe-to-reply.
        final isSystemMessage = message.messageType == MessageType.system;
        // 🔥 FIX: deleted-for-everyone bubbles show only the italic
        // placeholder — no options sheet (which would still preview stale
        // content) and no double-tap react on content that no longer exists.
        final isInteractive = !isSystemMessage && !message.isDeleted;

        // Determine if we should show date separator
        bool showDateSeparator = false;
        if (messageIndex == 0) {
          showDateSeparator = true;
        } else {
          final prevMessage = sortedMessages[messageIndex - 1];
          showDateSeparator = !ChatHelpers.isSameDay(
            message.timestamp,
            prevMessage.timestamp,
          );
        }

        final bubble = MessageBubble(
          message: message,
          isOwnMessage: isOwnMessage,
          currentlyPlayingMessageId: currentlyPlayingMessageId,
          audioPlayerState: audioPlayerState,
          playbackPosition: playbackPosition,
          onAudioTap: message.messageType == MessageType.voice
              ? () => onAudioTap(message)
              : null,
          currentUserId: currentUserId,
          onReactionTap: (emoji) {
            // 🔥 NEW: Task 20 — light haptic on tapping an existing
            // reaction chip (toggling your own reaction), matching the
            // double-tap-to-react haptic below.
            HapticFeedback.lightImpact();
            ref.read(chatProvider.notifier).toggleReaction(
              message.id!,
              emoji,
            );
          },
          onReplyTap: onReplyTap,
          onRetry: (localId) {
            ref.read(chatProvider.notifier).retryMessage(localId);
          },
          listingSellerId: listingSellerId,
          reviewCounterpartyName: reviewCounterpartyName,
          reviewItemTitle: reviewItemTitle,
          reviewItemImage: reviewItemImage,
          isHighlighted: message.id != null && message.id == highlightedMessageId,
          // 🔥 NEW: Task 20 — grouped-bubble corner treatment for
          // consecutive same-sender messages.
          position: ChatHelpers.bubblePosition(sortedMessages, messageIndex),
          // 🔥 NEW: Task 15 — double-tap the bubble's content region to
          // toggle a quick ❤️ reaction (Karrot/Instagram pattern), with a
          // light haptic. Scoped inside MessageBubble to the background
          // content container only, so it doesn't steal the gesture arena
          // from nested taps (reaction chips, reply-preview scroll, retry,
          // image) — see MessageBubble's onDoubleTap wiring.
          onDoubleTap: isInteractive && message.id != null
              ? () {
                  HapticFeedback.lightImpact();
                  ref
                      .read(chatProvider.notifier)
                      .toggleReaction(message.id!, '❤️');
                }
              : null,
          // 🔥 FIX: Task 18 review — "Show original" row under a translated
          // bubble now toggles the client-side display set instead of
          // destroying the cached translation (no re-fetch to undo).
          showOriginal: message.translation == null ||
              (message.id != null && showingOriginalIds.contains(message.id)),
          onShowOriginal: message.id != null
              ? () => ref
                  .read(showingOriginalTranslationsProvider.notifier)
                  .update((ids) => {...ids, message.id!})
              : null,
        );

        // 🔥 NEW: Task 20 — the unread divider is computed once at open and
        // never recomputed as messages get marked read, so this is a plain
        // id match, not a live "isRead" check.
        final showUnreadDivider =
            unreadDividerMessageId != null && message.id == unreadDividerMessageId;

        final messageWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDateSeparator)
              DateSeparator(date: message.timestamp),
            if (showUnreadDivider) const UnreadDivider(),
            if (!isInteractive)
              bubble
            else
              GestureDetector(
                onLongPress: () {
                  HapticFeedback.mediumImpact();
                  onMessageLongPress(message, currentUserId!);
                },
                child: bubble,
              ),
          ],
        );

        // Wrap in SwipeableMessage for swipe-to-reply (Telegram/WhatsApp
        // style) — system messages skip this, they're not repliable.
        if (!isSystemMessage &&
            onMessageSwipeReply != null &&
            message.id != null) {
          return SwipeableMessage(
            key: Key('swipe_message_${message.id}'),
            onSwipeReply: () => onMessageSwipeReply!(message),
            child: messageWidget,
          );
        }

        return messageWidget;
      },
    );
  }
}

