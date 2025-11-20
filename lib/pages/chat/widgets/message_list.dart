import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
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

  const MessageList({
    super.key,
    required this.scrollController,
    required this.currentlyPlayingMessageId,
    required this.audioPlayerState,
    required this.onAudioTap,
    required this.onMessageLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.messages;
    final isLoadingMessages = chatState.isLoadingMessages;
    final currentUserId = chatState.currentUserId;

    if (isLoadingMessages) {
      return const Center(child: CircularProgressIndicator());
    }

    if (messages.isEmpty) {
      return const SizedBox.shrink(); // Empty state is handled by parent
    }

    final sortedMessages = List<ChatMessage>.from(messages)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDateSeparator)
              DateSeparator(date: message.timestamp),
            GestureDetector(
              onLongPress: () => onMessageLongPress(message, currentUserId!),
              child: MessageBubble(
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
              ),
            ),
          ],
        );
      },
    );
  }
}

