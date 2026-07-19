import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/pages/chat/widgets/chat_shimmer.dart';
import 'package:app/pages/chat/widgets/swipeable_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'message_bubble.dart';
import 'date_separator.dart';
import 'chat_helpers.dart';

class MessageList extends ConsumerWidget {
  final ScrollController scrollController;
  final int? currentlyPlayingMessageId;
  final PlayerState audioPlayerState;
  final Function(ChatMessage) onAudioTap;
  final Function(ChatMessage, int) onMessageLongPress;
  final Function(int)? onReplyTap; // Callback when reply preview is tapped
  final Function(ChatMessage)? onMessageSwipeReply; // Callback when message is swiped right to reply

  /// 🔥 NEW: Task 13 — anchored listing's seller id, forwarded to
  /// [MessageBubble] so it can tell whether the current user is the buyer
  /// for a `review_cta` system message.
  final int? listingSellerId;

  const MessageList({
    super.key,
    required this.scrollController,
    required this.currentlyPlayingMessageId,
    required this.audioPlayerState,
    required this.onAudioTap,
    required this.onMessageLongPress,
    this.onReplyTap,
    this.onMessageSwipeReply,
    this.listingSellerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final isLoadingMessages = chatState.isLoadingMessages;
    final currentUserId = chatState.currentUserId;
    // Use cached sorted provider to avoid O(n log n) sort on every rebuild
    final sortedMessages = ref.watch(sortedMessagesProvider);

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
          onAudioTap: message.messageType == MessageType.voice
              ? () => onAudioTap(message)
              : null,
          currentUserId: currentUserId,
          onReactionTap: (emoji) {
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
        );

        final messageWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDateSeparator)
              DateSeparator(date: message.timestamp),
            if (isSystemMessage)
              bubble
            else
              GestureDetector(
                onLongPress: () => onMessageLongPress(message, currentUserId!),
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

