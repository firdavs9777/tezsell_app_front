import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMediaOption(
            icon: Icons.photo_library,
            label: 'Gallery',
            color: Colors.purple,
            onTap: onGalleryTap,
          ),
          _buildMediaOption(
            icon: Icons.camera_alt,
            label: 'Camera',
            color: Colors.blue,
            onTap: onCameraTap,
          ),
          _buildMediaOption(
            icon: Icons.mic,
            label: 'Voice',
            color: Colors.red,
            onTap: onVoiceTap,
          ),
          _buildMediaOption(
            icon: Icons.emoji_emotions,
            label: 'Emoji',
            color: Colors.orange,
            onTap: onEmojiTap,
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
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}

