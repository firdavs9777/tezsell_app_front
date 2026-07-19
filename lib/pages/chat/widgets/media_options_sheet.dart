import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class MediaOptionsSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onVoiceTap;
  final VoidCallback onEmojiTap;

  /// 🔥 NEW: Task 19 — opens the quick-replies panel. Null hides the option
  /// (kept optional so existing call sites that don't wire it still compile).
  final VoidCallback? onQuickRepliesTap;

  const MediaOptionsSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onVoiceTap,
    required this.onEmojiTap,
    this.onQuickRepliesTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildMediaOption(
              context: context,
              icon: Icons.photo_library,
              label: l.gallery,
              color: colorScheme.secondary,
              onTap: onGalleryTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              context: context,
              icon: Icons.camera_alt,
              label: l.camera,
              color: colorScheme.primary,
              onTap: onCameraTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              context: context,
              icon: Icons.mic,
              label: l.voice,
              color: colorScheme.error,
              onTap: onVoiceTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              context: context,
              icon: Icons.emoji_emotions,
              label: l.emoji,
              color: colorScheme.tertiary,
              onTap: onEmojiTap,
            ),
          ),
          // 🔥 NEW: Task 19 — quick replies panel entry point.
          if (onQuickRepliesTap != null)
            Expanded(
              child: _buildMediaOption(
                context: context,
                icon: Icons.bolt,
                label: l.chatQuickReplies,
                color: colorScheme.primary,
                onTap: onQuickRepliesTap!,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaOption({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
