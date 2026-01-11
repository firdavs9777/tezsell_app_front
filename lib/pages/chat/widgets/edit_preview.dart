import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class EditPreview extends StatelessWidget {
  final VoidCallback onCancel;

  const EditPreview({
    super.key,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.3),
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
                return Text(
                  l.editing_message,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
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

