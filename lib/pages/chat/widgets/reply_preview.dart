import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ReplyPreview extends StatelessWidget {
  final ChatMessage replyToMessage;
  final VoidCallback onCancel;

  const ReplyPreview({
    super.key,
    required this.replyToMessage,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context)!;
                    return Text(
                      l.replying_to(replyToMessage.sender.username),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context)!;
                    return Text(
                      replyToMessage.content ?? 
                      (replyToMessage.messageType == MessageType.image 
                          ? l.photo
                          : replyToMessage.messageType == MessageType.voice 
                              ? l.voice_message
                              : ''),
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

