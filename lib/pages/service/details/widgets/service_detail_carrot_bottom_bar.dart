import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ServiceDetailCarrotBottomBar extends StatelessWidget {
  const ServiceDetailCarrotBottomBar({
    super.key,
    required this.isLiked,
    required this.isLiking,
    required this.onToggleLike,
    required this.onStartChat,
    this.isOwnListing = false,
  });

  final bool isLiked;
  final bool isLiking;
  final VoidCallback onToggleLike;
  final VoidCallback onStartChat;
  // 🔥 NEW: Hides the "Chat" button when viewing your own listing
  final bool isOwnListing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: isLiking ? null : onToggleLike,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: isLiking
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(
                          isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLiked
                              ? Colors.red
                              : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 36,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations?.service_provider ?? 'Service',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
              ),
              if (!isOwnListing) ...[
                const SizedBox(width: 12),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: onStartChat,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6F0F),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      '\u{1F4AC} ${localizations?.chatWithSeller ?? 'Chat with seller'}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
