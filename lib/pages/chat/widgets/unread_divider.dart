import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// 🔥 NEW: Task 20 — a single row shown once, above the first unread message
/// at the moment a room is opened (computed once from the read state at
/// open time by `ChatRoomScreen`, not recomputed as messages get marked
/// read live — see `_unreadDividerMessageId`).
class UnreadDivider extends StatelessWidget {
  const UnreadDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Divider(color: color.withOpacity(0.4), thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              l.chatUnreadDivider,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Divider(color: color.withOpacity(0.4), thickness: 1)),
        ],
      ),
    );
  }
}
