import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

  /// 🔥 NEW: Reliability core — tap-to-retry for a `failed` bubble. Receives
  /// the message's `localId`.
  final Function(String)? onRetry;

  /// 🔥 NEW: Task 15 — double-tap the bubble's content region to toggle a
  /// quick ❤️ reaction. Scoped to just the main bubble container (text/
  /// image/voice content) below, NOT the reply-preview block, the reaction
  /// chips, or the delivery-tick/retry icon, so double-tapping those areas
  /// doesn't also register as a bubble double-tap and — more importantly —
  /// so the DoubleTap gesture arena doesn't delay their single-tap
  /// recognition by ~300ms.
  final VoidCallback? onDoubleTap;

  /// 🔥 NEW: Task 13 — the anchored listing's seller id, used to decide
  /// whether the current user is the buyer for a `review_cta` system
  /// message (the CTA button is buyer-only). Null when the room has no
  /// product listing or the seller id wasn't resolved.
  final int? listingSellerId;

  /// 🔥 NEW: Task 14 — true for a brief window after the user taps a
  /// quoted-reply block that scrolled the list to this message; renders a
  /// fading background flash so the target is easy to spot.
  final bool isHighlighted;

  // Memoization cache for emoji detection (LRU-style with max size)
  static final Map<String, bool> _emojiCache = {};
  static const int _maxCacheSize = 100;

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
    this.onRetry,
    this.listingSellerId,
    this.isHighlighted = false,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 NEW: Task 13 — system messages (transaction reserve/sold/available,
    // plus the sold-only review CTA) render as a centered pill, never a
    // chat bubble, and aren't interactive (no reply/react/long-press).
    if (message.messageType == MessageType.system) {
      return _buildSystemMessage(context);
    }

    // Show deleted message differently (Telegram style)
    if (message.isDeleted) {
      return _wrapHighlight(
        context,
        Align(
          alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context)!;
                    return Text(
                      l.chatMessageDeleted,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _wrapHighlight(context, Align(
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
                        color: isOwnMessage
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        ),
                        border: Border(
                          left: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message.replyTo!.sender.username,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary,
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
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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

                // Main message bubble (Modern WhatsApp/iMessage style)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    // Modern gradient for own messages, subtle surface for others
                    gradient: isOwnMessage
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primary.withOpacity(0.85),
                            ],
                          )
                        : null,
                    color: isOwnMessage
                        ? null
                        : Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isOwnMessage ? 18 : 4),
                      bottomRight: Radius.circular(isOwnMessage ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 🔥 FIX: Task 15 — double-tap scoped to just the
                      // sender-name + text-content block, as a SIBLING of
                      // the timestamp/delivery-tick row below (not an
                      // ancestor), and only registered for text messages —
                      // image/voice bubbles keep their own single-tap-to-
                      // open/play gesture as the sole recognizer so neither
                      // it nor the retry tick ever has to wait out the
                      // DoubleTap recognizer's ~300ms disambiguation window.
                      GestureDetector(
                        onDoubleTap: message.messageType == MessageType.text
                            ? onDoubleTap
                            : null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sender name (for group chats) - Modern style
                            if (!isOwnMessage)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  message.sender.username,
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),

                            // Message content
                            _buildMessageContent(context),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Timestamp and read receipts
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(message.timestamp),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: isOwnMessage
                                  ? Colors.white.withOpacity(0.7)
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (message.isEdited) ...[
                            const SizedBox(width: 4),
                            Builder(
                              builder: (context) {
                                final l = AppLocalizations.of(context)!;
                                return Text(
                                  l.chatEdited,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                    color: isOwnMessage
                                        ? Colors.white.withOpacity(0.6)
                                        : Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                );
                              },
                            ),
                          ],
                          // Delivery ticks (only for own messages)
                          if (isOwnMessage) ...[
                            const SizedBox(width: 4),
                            _buildDeliveryTick(context),
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
    ));
  }

  /// 🔥 NEW: Task 14 — wraps a message bubble with a background flash that
  /// fades in/out when [isHighlighted] toggles, used after a tap on a
  /// quoted-reply block scrolls the list to the original message.
  Widget _wrapHighlight(BuildContext context, Widget child) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      color: isHighlighted
          ? Theme.of(context).colorScheme.primary.withOpacity(0.16)
          : Colors.transparent,
      child: child,
    );
  }

  /// 🔥 NEW: Task 13 — centered pill for `message_type == 'system'` messages
  /// (transaction reserve/sold/available). Text is localized client-side
  /// from `metadata['transaction']`, falling back to the raw message content
  /// for any system message this client doesn't recognize. When
  /// `metadata['review_cta'] == true`, a "Leave a review" button is shown
  /// below the pill — buyer-only (never shown to the seller themselves).
  Widget _buildSystemMessage(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final transactionType = message.metadata['transaction'] as String?;
    String label;
    switch (transactionType) {
      case 'reserve':
        label = l.chatSysReserved;
        break;
      case 'sold':
        label = l.chatSysSold;
        break;
      case 'available':
        label = l.chatSysAvailable;
        break;
      default:
        label = message.content ?? '';
    }

    final isReviewCta = message.metadata['review_cta'] == true;
    final isBuyer = currentUserId != null &&
        listingSellerId != null &&
        currentUserId != listingSellerId;
    final showReviewButton = isReviewCta && isBuyer;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showReviewButton) ...[
            const SizedBox(height: 8),
            FilledButton(
              style: FilledButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () {
                final productId = message.metadata['product_id'];
                if (productId == null) return;
                // TODO(plan-e): route to a dedicated write-review screen
                // once one exists — grepping the app found `submitReview`/
                // `reviewsProvider` (lib/providers/provider_root/reviews_provider.dart)
                // but no UI wired up to call them, so send the buyer to the
                // product detail page for now.
                context.push('/product/$productId');
              },
              child: Text(l.chatLeaveReview),
            ),
          ],
        ],
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
              color: hasMyReaction ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: hasMyReaction
                  ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 6),
                Text(
                  '${userIds.length}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: hasMyReaction
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // 🔥 Delivery tick widget — reflects [ChatMessage.deliveryStatus] for the
  // client-only lifecycle (sending/failed), falling back to the readBy-based
  // read/delivered/sent logic for messages the server has already persisted.
  Widget _buildDeliveryTick(BuildContext context) {
    switch (message.deliveryStatus) {
      case DeliveryStatus.sending:
      case DeliveryStatus.queued:
        return Icon(
          Icons.schedule,
          size: 14,
          color: Colors.white.withValues(alpha: 0.7),
        );

      case DeliveryStatus.failed:
        return GestureDetector(
          onTap: message.localId != null
              ? () => onRetry?.call(message.localId!)
              : null,
          child: Icon(
            Icons.error_outline,
            size: 16,
            color: Theme.of(context).colorScheme.error,
          ),
        );

      case DeliveryStatus.sent:
      case DeliveryStatus.delivered:
      case DeliveryStatus.read:
        break;
    }

    // Use actual ChatMessage properties: isRead and readBy
    // 🔥 FIX: Only count readers OTHER than the sender
    final senderId = message.sender.id;
    final otherReaders = message.readBy.where((id) => id != senderId).toList();
    final hasBeenReadByOthers = message.isRead ||
        otherReaders.isNotEmpty ||
        message.deliveryStatus == DeliveryStatus.read;
    final isDelivered = message.id != null ||
        message.deliveryStatus == DeliveryStatus.delivered; // If message has ID, it was sent to server

    if (hasBeenReadByOthers) {
      // Read - double tick, primary-colored to stand out
      return Icon(
        Icons.done_all,
        size: 16,
        color: Theme.of(context).colorScheme.primary,
      );
    } else if (isDelivered) {
      // Delivered but unread - double tick (dimmed)
      return Icon(
        Icons.done_all,
        size: 16,
        color: Colors.white.withOpacity(0.55),
      );
    } else {
      // Sent but not delivered - single tick (dimmed)
      return Icon(
        Icons.done,
        size: 16,
        color: Colors.white.withOpacity(0.55),
      );
    }
  }

  // Check if message contains only emojis (with memoization for performance)
  bool _isEmojiOnly(String text) {
    if (text.trim().isEmpty) return false;

    // Check cache first
    if (_emojiCache.containsKey(text)) {
      return _emojiCache[text]!;
    }

    // Remove whitespace and check if all characters are emojis
    final cleanText = text.replaceAll(RegExp(r'\s+'), '');
    if (cleanText.isEmpty) {
      _cacheResult(text, false);
      return false;
    }

    // Check if all characters are emojis (Unicode ranges for emojis)
    final hasOnlyEmojis = cleanText.runes.every((rune) {
      return (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
          (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
          (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
          (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
          (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
          (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
          (rune >= 0x1FA00 && rune <= 0x1FA6F) || // Extended symbols
          (rune >= 0xFE00 && rune <= 0xFE0F) || // Variation selectors
          (rune >= 0x200D && rune <= 0x200D); // Zero-width joiner
    });

    // Only if 6 or fewer emoji characters (excluding variation selectors)
    final emojiCount = cleanText.runes.where((rune) =>
      (rune >= 0x1F600 && rune <= 0x1F64F) ||
      (rune >= 0x1F300 && rune <= 0x1F5FF) ||
      (rune >= 0x1F680 && rune <= 0x1F6FF) ||
      (rune >= 0x2600 && rune <= 0x26FF) ||
      (rune >= 0x2700 && rune <= 0x27BF) ||
      (rune >= 0x1F900 && rune <= 0x1F9FF) ||
      (rune >= 0x1FA00 && rune <= 0x1FA6F)
    ).length;

    final result = hasOnlyEmojis && emojiCount <= 6;
    _cacheResult(text, result);
    return result;
  }

  // Helper to cache results with LRU eviction
  static void _cacheResult(String text, bool result) {
    if (_emojiCache.length >= _maxCacheSize) {
      // Remove oldest entries (first 20%)
      final keysToRemove = _emojiCache.keys.take(_maxCacheSize ~/ 5).toList();
      for (final key in keysToRemove) {
        _emojiCache.remove(key);
      }
    }
    _emojiCache[text] = result;
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        // Check if message is mostly emoji - make it larger (Telegram style)
        final content = message.content!;
        final isEmojiMessage = _isEmojiOnly(content);

        return Text(
          content,
          style: isEmojiMessage
              ? const TextStyle(fontSize: 48, height: 1.0)
              : Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isOwnMessage ? Colors.white : Theme.of(context).colorScheme.onSurface,
                  height: 1.4,
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

      case MessageType.system:
        // Unreachable: `build()` returns `_buildSystemMessage` before ever
        // reaching this switch for system messages.
        return const SizedBox.shrink();
    }
  }

  Widget _buildImageMessage(BuildContext context) {
    final imageUrl = message.fileUrl ?? message.file;

    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Builder(
              builder: (context) {
                final l = AppLocalizations.of(context)!;
                return Text(
                  l.image_unavailable,
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                    : Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isOwnMessage ? Colors.white : Theme.of(context).colorScheme.primary,
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
                              : Theme.of(context).colorScheme.primary.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isOwnMessage
                          ? Colors.white.withOpacity(0.8)
                          : Theme.of(context).colorScheme.onSurface,
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
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
