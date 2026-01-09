import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class MediaOptionsSheet extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onVoiceTap;
  final VoidCallback onEmojiTap;

  const MediaOptionsSheet({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onVoiceTap,
    required this.onEmojiTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildMediaOption(
              icon: Icons.photo_library,
              label: l.gallery,
              color: Colors.purple,
              onTap: onGalleryTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              icon: Icons.camera_alt,
              label: l.camera,
              color: Colors.blue,
              onTap: onCameraTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              icon: Icons.mic,
              label: l.voice,
              color: Colors.red,
              onTap: onVoiceTap,
            ),
          ),
          Expanded(
            child: _buildMediaOption(
              icon: Icons.emoji_emotions,
              label: l.emoji,
              color: Colors.orange,
              onTap: onEmojiTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaOption({
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
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
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
