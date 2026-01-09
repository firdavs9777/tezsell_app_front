import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final int? currentlyPlayingMessageId;
  final PlayerState audioPlayerState;
  final VoidCallback? onAudioTap;
  final int? currentUserId;
  final Function(String)? onReactionTap;
  final Function(int)?
  onReplyTap; // Callback when reply preview is tapped, receives message ID

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    this.currentlyPlayingMessageId,
    this.audioPlayerState = PlayerState.stopped,
    this.onAudioTap,
    this.currentUserId,
    this.onReactionTap,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    // Show deleted message differently (Telegram style)
    if (message.isDeleted) {
      return Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Builder(
                builder: (context) {
                  final l = AppLocalizations.of(context)!;
                  return Text(
                    l.this_message_was_deleted,
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
          maxHeight: MediaQuery.of(context).size.height * 0.4, // Max 40% of screen height to prevent overflow
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: isOwnMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                // Reply preview (clickable to scroll to original message) - Telegram style
                if (message.replyTo != null && message.replyTo!.id != null)
                  GestureDetector(
                    onTap: () => onReplyTap?.call(message.replyTo!.id!),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      width: double.infinity, // Ensure full width
                      decoration: BoxDecoration(
                        // Telegram-style reply background
                        color: isOwnMessage
                            ? Colors.white.withOpacity(0.9) // Light background for dark text
                            : Colors.grey[200]!, // Light grey for received messages
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: isOwnMessage
                                ? Colors.white // White vertical bar
                                : const Color(0xFF3390EC), // Telegram blue
                            width: 2.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.replyTo!.sender.username,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isOwnMessage
                                  ? const Color(0xFF3390EC) // Telegram blue for own messages
                                  : const Color(0xFF3390EC), // Telegram blue
                            ),
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (context) {
                              final l = AppLocalizations.of(context)!;
                              final replyContent =
                                  message.replyTo!.content ??
                                  (message.replyTo!.messageType ==
                                          MessageType.image
                                      ? l.photo
                                      : message.replyTo!.messageType ==
                                            MessageType.voice
                                      ? l.voice_message
                                      : '');
                              if (replyContent.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                replyContent,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: isOwnMessage
                                      ? Colors.grey[900]! // Dark text for own messages
                                      : Colors.grey[900]!, // Very dark for maximum contrast
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                // Main message bubble (Telegram-style)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    // Telegram green for own messages, white for others
                    color: isOwnMessage
                        ? const Color(0xFF3390EC) // Telegram blue-green
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: Radius.circular(isOwnMessage ? 12 : 4),
                      bottomRight: Radius.circular(isOwnMessage ? 4 : 12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Sender name (for group chats) - Telegram style
                      if (!isOwnMessage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            message.sender.username,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3390EC), // Telegram blue
                            ),
                          ),
                        ),

                      // Message content
                      _buildMessageContent(context),

                      const SizedBox(height: 6),

                      // Timestamp and read receipts
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(message.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOwnMessage
                                  ? Colors.white.withOpacity(0.7)
                                  : Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (message.isEdited) ...[
                            const SizedBox(width: 4),
                            Text(
                              'edited',
                              style: TextStyle(
                                fontSize: 11,
                                fontStyle: FontStyle.italic,
                                color: isOwnMessage
                                    ? Colors.white.withOpacity(0.6)
                                    : Colors.grey[500],
                              ),
                            ),
                          ],
                          // Read receipts (only for own messages)
                          if (isOwnMessage) ...[
                            const SizedBox(width: 4),
                            _buildReadReceipt(),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Add spacing for reactions if they exist
                if (message.reactions.isNotEmpty) const SizedBox(height: 16),
              ],
            ),
          ),

            // Reactions (overlapping bottom-right/left - Telegram-style)
            if (message.reactions.isNotEmpty)
              Positioned(
                bottom: -8,
                right: isOwnMessage ? 12 : null,
                left: !isOwnMessage ? 12 : null,
                child: _buildReactions(context),
              ),
          ],
        ),
      ),
    );
  }

  // 🔥 NEW: Build reactions widget (Telegram-style)
  Widget _buildReactions(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: message.reactions.entries.map((entry) {
        final emoji = entry.key;
        final userIds = entry.value;
        final hasMyReaction =
            currentUserId != null && userIds.contains(currentUserId);

        return GestureDetector(
          onTap: () => onReactionTap?.call(emoji),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: hasMyReaction ? Colors.blue[100] : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              border: hasMyReaction
                  ? Border.all(color: Colors.blue, width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                if (userIds.length > 1) ...[
                  const SizedBox(width: 6),
                  Text(
                    '${userIds.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: hasMyReaction
                          ? Colors.blue[900]
                          : Colors.grey[700],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🔥 NEW: Read receipt widget (Telegram-style)
  Widget _buildReadReceipt() {
    // Use actual ChatMessage properties: isRead and readBy
    final readCount = message.readBy.length;
    final hasBeenRead = message.isRead || readCount > 0;
    final isDelivered =
        message.id != null; // If message has ID, it was sent to server

    if (hasBeenRead) {
      // Read by someone (blue double check - Telegram style)
      return Icon(Icons.done_all, size: 16, color: const Color(0xFF3390EC));
    } else if (isDelivered) {
      // Delivered but not read (grey double check)
      return Icon(
        Icons.done_all,
        size: 16,
        color: Colors.white.withOpacity(0.6),
      );
    } else {
      // Sent but not delivered (single grey check)
      return Icon(Icons.done, size: 16, color: Colors.white.withOpacity(0.6));
    }
  }

  // Check if message contains only emojis
  bool _isEmojiOnly(String text) {
    if (text.trim().isEmpty) return false;

    // Remove whitespace and check if all characters are emojis
    final cleanText = text.replaceAll(RegExp(r'\s+'), '');
    if (cleanText.isEmpty) return false;

    // Check if all characters are emojis (Unicode ranges for emojis)
    final emojiRegex = RegExp(
      r'^[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]+$',
      unicode: true,
    );

    // Also check for common emoji patterns
    final hasOnlyEmojis = cleanText.runes.every((rune) {
      return (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
          (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
          (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
          (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
          (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
          (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
          (rune >= 0x1FA00 && rune <= 0x1FA6F); // Chess Symbols
    });

    return hasOnlyEmojis &&
        cleanText.length <= 10; // Only if 10 or fewer emojis
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        // Check if message is mostly emoji - make it larger (Telegram style)
        final content = message.content!;
        final isEmojiMessage = _isEmojiOnly(content);

        return Text(
          content,
          style: TextStyle(
            color: isOwnMessage ? Colors.white : Colors.black87,
            fontSize: isEmojiMessage
                ? 48
                : 16, // Large emoji for emoji-only messages
            height: isEmojiMessage ? 1.0 : 1.4,
            letterSpacing: 0.1,
          ),
          textAlign: isEmojiMessage ? TextAlign.center : TextAlign.start,
          maxLines: isEmojiMessage ? null : 50, // Limit text messages to 50 lines
          overflow: isEmojiMessage ? null : TextOverflow.ellipsis,
        );

      case MessageType.image:
        return _buildImageMessage(context);

      case MessageType.voice:
        return _buildVoiceMessage(context, onAudioTap);
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    final imageUrl = message.fileUrl ?? message.file;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final l = AppLocalizations.of(context)!;
                return Text(
                  l.image_unavailable,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                );
              },
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ImageViewer(imageUrl: imageUrl)),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          8,
        ), // Telegram-style rounded corners
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
            maxHeight: MediaQuery.of(context).size.height * 0.4, // Max 40% of screen height
          ),
          child: CachedNetworkImageWidget(
            imageUrl: imageUrl,
            width: 250, // Default size
            height: 250,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(BuildContext context, VoidCallback? onTap) {
    final duration = message.duration ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final isPlaying =
        currentlyPlayingMessageId == message.id &&
        audioPlayerState == PlayerState.playing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isOwnMessage
                    ? Colors.white.withOpacity(0.25)
                    : const Color(0xFF3390EC).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isOwnMessage ? Colors.white : const Color(0xFF3390EC),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(20, (index) {
                      final height = (index % 3 + 1) * 4.0;
                      return Container(
                        width: 3,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: isOwnMessage
                              ? Colors.white.withOpacity(0.7)
                              : const Color(0xFF3390EC).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isOwnMessage
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black87,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.mic,
              color: isOwnMessage
                  ? Colors.white.withOpacity(0.7)
                  : Colors.grey[600],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
