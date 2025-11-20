import 'package:app/providers/provider_models/message_model.dart';
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

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwnMessage,
    this.currentlyPlayingMessageId,
    this.audioPlayerState = PlayerState.stopped,
    this.onAudioTap,
    this.currentUserId,
    this.onReactionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Show deleted message differently
    if (message.isDeleted) {
      return Align(
        alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.delete_outline, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 8),
              Text(
                'This message was deleted',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Column(
          crossAxisAlignment: isOwnMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Reply preview
            if (message.replyTo != null)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isOwnMessage 
                      ? Colors.blue.withOpacity(0.2)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border(
                    left: BorderSide(
                      color: isOwnMessage ? Colors.blue : Colors.grey[400]!,
                      width: 3,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.replyTo!.sender.username,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOwnMessage ? Colors.blue[900] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message.replyTo!.content ?? 
                      (message.replyTo!.messageType == MessageType.image 
                          ? '📷 Photo' 
                          : message.replyTo!.messageType == MessageType.voice 
                              ? '🎤 Voice message'
                              : ''),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOwnMessage ? Colors.blue[800] : Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isOwnMessage ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isOwnMessage)
                    Text(
                      message.sender.username,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  _buildMessageContent(context),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isOwnMessage ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (message.isEdited) ...[
                        const SizedBox(width: 4),
                        Text(
                          'edited',
                          style: TextStyle(
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            color: isOwnMessage ? Colors.white60 : Colors.grey[500],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Reactions
            if (message.reactions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 4,
                  children: message.reactions.entries.map((entry) {
                    final emoji = entry.key;
                    final userIds = entry.value;
                    final hasMyReaction = currentUserId != null && userIds.contains(currentUserId);
                    return GestureDetector(
                      onTap: () => onReactionTap?.call(emoji),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: hasMyReaction 
                              ? Colors.blue[100] 
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: hasMyReaction
                              ? Border.all(color: Colors.blue, width: 1)
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 14)),
                            if (userIds.length > 1) ...[
                              const SizedBox(width: 4),
                              Text(
                                '${userIds.length}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: hasMyReaction ? Colors.blue[900] : Colors.grey[700],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    switch (message.messageType) {
      case MessageType.text:
        return Text(
          message.content!,
          style: TextStyle(
            color: isOwnMessage ? Colors.white : Colors.black87,
            fontSize: 16,
          ),
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
        color: Colors.grey[300],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text('Image unavailable', style: TextStyle(fontSize: 12)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              body: Center(
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.broken_image, size: 64, color: Colors.white),
                            SizedBox(height: 16),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 200,
          height: 200,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 200,
              height: 200,
              color: Colors.grey[300],
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Failed to load', style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVoiceMessage(BuildContext context, VoidCallback? onTap) {
    final duration = message.duration ?? 0;
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    final isPlaying = currentlyPlayingMessageId == message.id && 
                      audioPlayerState == PlayerState.playing;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isOwnMessage 
                    ? Colors.white.withOpacity(0.3)
                    : Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: isOwnMessage ? Colors.white : Colors.blue,
                size: 28,
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
                      final height = (index % 3 + 1) * 3.0;
                      return Container(
                        width: 2.5,
                        height: height,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: isOwnMessage 
                              ? Colors.white.withOpacity(0.7)
                              : Colors.blue.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: isOwnMessage ? Colors.white70 : Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.mic,
              color: isOwnMessage ? Colors.white70 : Colors.grey[600],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

