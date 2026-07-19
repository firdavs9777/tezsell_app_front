import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class EditPreview extends StatelessWidget {
  final VoidCallback onCancel;

  /// 🔥 NEW: Task 15 — a one-line preview of the message being edited,
  /// shown under the "Edit" label so the user can see what they're
  /// changing without scrolling back up to the bubble.
  final String? snippet;

  const EditPreview({
    super.key,
    required this.onCancel,
    this.snippet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.edit, size: 16, color: Theme.of(context).colorScheme.tertiary),
          const SizedBox(width: 8),
          Expanded(
            child: Builder(
              builder: (context) {
                final l = AppLocalizations.of(context)!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.chatEdit,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    if (snippet != null && snippet!.trim().isNotEmpty)
                      Text(
                        snippet!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                );
              },
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
