import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'chat_helpers.dart';

class MessageOptionsSheet extends StatelessWidget {
  final ChatMessage message;
  final bool isOwnMessage;
  final VoidCallback onReply;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onCopy; // Add copy functionality

  /// 🔥 NEW: Task 15 — BananaTalk-pattern quick-react row rendered at the
  /// TOP of the sheet. Tapping an emoji reacts (toggling it, per the
  /// backend's one-per-user-replace semantics) and closes the sheet.
  final Function(String)? onReact;

  /// 🔥 NEW: Task 15 — emoji offered by the quick-react row.
  static const List<String> quickReactions = ['❤️', '👍', '😂', '😮', '😢', '🙏'];

  /// 🔥 NEW: Task 14 — skeleton hooks for Tasks 15/16/18. Each row only
  /// renders when its callback is non-null, so this sheet ships fully
  /// functional with just Reply/Copy (plus the already-wired Edit/Delete/
  /// React above) until those tasks fill the callbacks in from chat_room.
  final VoidCallback? onPin;
  final VoidCallback? onForward;
  final VoidCallback? onTranslate;

  const MessageOptionsSheet({
    super.key,
    required this.message,
    required this.isOwnMessage,
    required this.onReply,
    this.onEdit,
    required this.onDelete,
    this.onCopy,
    this.onReact,
    this.onPin,
    this.onForward,
    this.onTranslate,
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

            // 🔥 NEW: Task 15 — BananaTalk-pattern quick-react row at the top
            // of the sheet: tap an emoji to react and close the sheet.
            if (onReact != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: quickReactions.map((emoji) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () {
                        Navigator.pop(context);
                        onReact!(emoji);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(emoji, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
              ),

            if (onReact != null) const Divider(height: 1),

            // Message preview (optional)
            if (message.content != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOwnMessage ? theme.primaryColor.withValues(alpha: 0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
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
              label: l.chatReply,
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
                label: l.chatCopy,
                onTap: () {
                  Navigator.pop(context);
                  onCopy!();
                },
              ),

            if (onForward != null)
              _buildOption(
                context,
                icon: Icons.forward,
                label: l.chatForward,
                onTap: () {
                  Navigator.pop(context);
                  onForward!();
                },
              ),

            // Translate never applies to your own messages — you already
            // know what you wrote.
            if (!isOwnMessage && onTranslate != null)
              _buildOption(
                context,
                icon: Icons.translate,
                label: message.translation != null
                    ? l.chatShowOriginal
                    : l.chatTranslate,
                onTap: () {
                  Navigator.pop(context);
                  onTranslate!();
                },
              ),

            if (onPin != null)
              _buildOption(
                context,
                icon: message.isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                label: message.isPinned ? l.chatUnpin : l.chatPin,
                onTap: () {
                  Navigator.pop(context);
                  onPin!();
                },
              ),

            if (isOwnMessage &&
                message.messageType == MessageType.text &&
                onEdit != null &&
                ChatHelpers.canEditMessage(message.timestamp))
              _buildOption(
                context,
                icon: Icons.edit,
                label: l.chatEdit,
                onTap: () {
                  Navigator.pop(context);
                  onEdit!();
                },
              ),

            if (isOwnMessage)
              _buildOption(
                context,
                icon: Icons.delete_outline,
                label: l.chatDelete,
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