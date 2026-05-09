import 'dart:io';

import 'package:app/constants/constants.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileEditAvatar extends StatelessWidget {
  const ProfileEditAvatar({
    super.key,
    required this.user,
    required this.selectedImage,
    required this.onTap,
  });

  final UserInfo? user;
  final File? selectedImage;
  final VoidCallback onTap;

  ImageProvider? _resolveProvider() {
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    }
    final image = user?.profileImage.image;
    if (image == null || image.isEmpty) return null;
    final url = image.startsWith('http://') || image.startsWith('https://')
        ? image
        : '$baseUrl$image';
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final imageProvider = _resolveProvider();

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.surfaceContainerHighest,
                backgroundImage: imageProvider,
                child: imageProvider == null
                    ? Icon(
                        Icons.person,
                        size: 60,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          localizations?.tap_change_profile ?? 'Tap to change photo',
          style: TextStyle(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

Widget? buildLoadingSuffix(BuildContext context, bool isLoading) {
  if (!isLoading) return null;
  final colorScheme = Theme.of(context).colorScheme;
  return SizedBox(
    width: 20,
    height: 20,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
      ),
    ),
  );
}
