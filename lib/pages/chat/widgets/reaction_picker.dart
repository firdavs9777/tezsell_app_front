import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_models/message_model.dart';

class ReactionPicker extends ConsumerWidget {
  final ChatMessage message;
  final Function(String) onReactionSelected;

  const ReactionPicker({
    super.key,
    required this.message,
    required this.onReactionSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commonReactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];
    final currentUserId = ref.read(chatProvider).currentUserId;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Add Reaction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: commonReactions.map((emoji) {
              final hasReaction = message.reactions.containsKey(emoji) &&
                  message.reactions[emoji]!.contains(currentUserId);
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onReactionSelected(emoji);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: hasReaction ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

