// lib/widgets/connection_banner.dart
//
// Thin reconnect banner for chat screens. Listens directly to
// [ConnectionStateController.shouldShowBanner] (already debounced 3s there),
// so this widget stays a dumb StreamBuilder with no extra timing logic.
import 'package:app/l10n/app_localizations.dart';
import 'package:app/service/connection_state_controller.dart';
import 'package:flutter/material.dart';

class ConnectionBanner extends StatelessWidget {
  const ConnectionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: ConnectionStateController.instance.shouldShowBanner,
      initialData: false,
      builder: (context, snapshot) {
        final show = snapshot.data ?? false;
        return AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: !show
              ? const SizedBox(width: double.infinity, height: 0)
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.chatConnecting,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
