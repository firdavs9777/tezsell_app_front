import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter/material.dart';

class MessageOptionsSheet extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final VoidCallback onReply;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddReaction;

  const MessageOptionsSheet({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.onReply,
    required this.onEdit,
    required this.onDelete,
    required this.onAddReaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOwnMessage && message.messageType == MessageType.text)
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
          ListTile(
            leading: const Icon(Icons.reply),
            title: const Text('Reply'),
            onTap: () {
              Navigator.pop(context);
              onReply();
            },
          ),
          if (isOwnMessage)
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          if (isOwnMessage)
            ListTile(
              leading: const Icon(Icons.add_reaction),
              title: const Text('Add Reaction'),
              onTap: () {
                Navigator.pop(context);
                onAddReaction();
              },
            ),
        ],
      ),
    );
  }
}

