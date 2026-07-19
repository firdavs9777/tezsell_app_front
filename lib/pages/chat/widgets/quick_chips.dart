// lib/pages/chat/widgets/quick_chips.dart
//
// Horizontal row of Karrot-style quick-reply chips shown above the message
// input in a listing-anchored chat room, before the buyer has said much.
// Visibility (listing present, not the seller, own-message-count < 2) is
// decided by the caller (ChatRoomScreen) — this widget just renders the row.

import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class QuickChips extends StatelessWidget {
  final ValueChanged<String> onChipTap;

  const QuickChips({super.key, required this.onChipTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final chips = [
      l.chatQuickAvailable,
      l.chatQuickPrice,
      l.chatQuickMeet,
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final text = chips[index];
          return ActionChip(
            label: Text(text),
            backgroundColor: colorScheme.surfaceContainerHighest,
            side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
            labelStyle: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            onPressed: () => onChipTap(text),
          );
        },
      ),
    );
  }
}
