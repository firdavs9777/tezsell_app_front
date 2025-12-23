import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/l10n/app_localizations.dart';
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
          // Report option (for messages from others)
          if (!isOwnMessage && message.id != null)
            ListTile(
              leading: Icon(Icons.flag, color: Theme.of(context).colorScheme.error),
              title: Text(
                AppLocalizations.of(context)?.reportMessage ?? 'Report Message',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showReportDialog(context);
              },
            ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    if (message.id == null) return;
    
    showDialog(
      context: context,
      builder: (dialogContext) => ReportContentDialog(
        contentType: 'message',
        contentId: message.id!,
        contentTitle: message.content?.substring(0, message.content!.length > 50 ? 50 : message.content!.length) ?? 'Message',
      ),
    );
  }
}

