import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/l10n/app_localizations.dart';

class EmptyMessageState extends ConsumerWidget {
  final String? error;
  final int chatRoomId;

  const EmptyMessageState({
    super.key,
    this.error,
    required this.chatRoomId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Builder(
            builder: (context) {
              final l = AppLocalizations.of(context)!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l.no_messages_yet,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Say hi! 👋',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(chatProvider.notifier).loadChatMessages(chatRoomId);
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(l.cancel),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

