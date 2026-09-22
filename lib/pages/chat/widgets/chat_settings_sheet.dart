import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/auto_translate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Per-conversation chat settings, opened from the room's overflow menu.
///
/// Currently holds the auto-translate preference. Kept as its own sheet rather
/// than a single menu item so the setting can carry an explanation — a toggle
/// labelled only "Auto-translate" doesn't convey that it applies to incoming
/// messages and costs a translation call per message.
class ChatSettingsSheet extends ConsumerWidget {
  const ChatSettingsSheet({super.key, required this.currentUserId});

  final int? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final autoTranslate = ref.watch(autoTranslateProvider(currentUserId));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(
                l?.chatSettingsTitle ?? 'Chat settings',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            SwitchListTile(
              value: autoTranslate,
              onChanged: (value) async {
                await ref
                    .read(autoTranslateProvider(currentUserId).notifier)
                    .set(value);
                if (!context.mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? (l?.chatAutoTranslateEnabled ?? 'Auto-translate on')
                          : (l?.chatAutoTranslateDisabled ??
                              'Auto-translate off'),
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              secondary: Icon(Icons.translate, color: colorScheme.primary),
              title: Text(
                l?.chatAutoTranslateTitle ?? 'Auto-translate to my language',
              ),
              subtitle: Text(
                l?.chatAutoTranslateSubtitle ??
                    'Messages from others are translated as they arrive',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
