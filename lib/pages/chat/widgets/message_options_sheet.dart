import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MessageOptionsSheet extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final VoidCallback onReply;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onAddReaction;
  final VoidCallback? onCopy; // Add copy functionality

  const MessageOptionsSheet({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.onReply,
    this.onEdit,
    required this.onDelete,
    this.onAddReaction,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Message preview (optional)
            if (message.content != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOwnMessage ? theme.primaryColor.withOpacity(0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.content!.length > 100
                    ? '${message.content!.substring(0, 100)}...'
                    : message.content!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            
            const Divider(height: 1),
            
            // Options
            _buildOption(
              context,
              icon: Icons.reply,
              label: l.reply,
              onTap: () {
                Navigator.pop(context);
                // Small delay to ensure bottom sheet is fully closed
                Future.delayed(const Duration(milliseconds: 100), () {
                  onReply();
                });
              },
            ),
            
            if (message.messageType == MessageType.text && onCopy != null)
              _buildOption(
                context,
                icon: Icons.copy,
                label: l.copy,
                onTap: () {
                  Navigator.pop(context);
                  onCopy!();
                },
              ),
            
            if (isOwnMessage && message.messageType == MessageType.text && onEdit != null)
              _buildOption(
                context,
                icon: Icons.edit,
                label: l.edit,
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),
            
            if (onAddReaction != null)
              _buildOption(
                context,
                icon: Icons.add_reaction_outlined,
                label: l.add_reaction,
                onTap: () {
                  Navigator.pop(context);
                  onAddReaction!();
                },
              ),
            
            if (isOwnMessage)
              _buildOption(
                context,
                icon: Icons.delete_outline,
                label: l.delete,
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
            
            // Report option (for messages from others)
            if (!isOwnMessage && message.id != null)
              _buildOption(
                context,
                icon: Icons.flag_outlined,
                label: l.reportMessage,
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),
            
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: iconColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
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
        contentTitle: message.content?.substring(
          0, 
          message.content!.length > 50 ? 50 : message.content!.length
        ) ?? AppLocalizations.of(context)?.message ?? 'Message',
      ),
    );
  }
}