import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/widgets/property_form_widgets.dart';
import 'package:flutter/material.dart';

class PropertyImagePicker extends StatelessWidget {
  const PropertyImagePicker({
    super.key,
    required this.images,
    required this.onAddTap,
    required this.onRemove,
  });

  final List<File> images;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return PropertyFormCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PropertyFormSectionHeader(
            title:
                localizations?.property_create_images ?? 'Property Images',
            icon: Icons.photo_library,
          ),
          const SizedBox(height: 16),
          if (images.isEmpty)
            _EmptyState(
              theme: theme,
              colorScheme: colorScheme,
              localizations: localizations,
              onTap: onAddTap,
            )
          else
            _ImageList(
              images: images,
              theme: theme,
              colorScheme: colorScheme,
              localizations: localizations,
              onAddTap: onAddTap,
              onRemove: onRemove,
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.theme,
    required this.colorScheme,
    required this.localizations,
    required this.onTap,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations? localizations;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_photo_alternate,
                size: 56, color: colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              localizations?.property_create_tap_to_add_images ??
                  'Tap to add images',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localizations?.property_create_at_least_one_image ??
                  'At least 1 image required',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageList extends StatelessWidget {
  const _ImageList({
    required this.images,
    required this.theme,
    required this.colorScheme,
    required this.localizations,
    required this.onAddTap,
    required this.onRemove,
  });

  final List<File> images;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations? localizations;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == images.length) {
            return _AddMoreTile(
              theme: theme,
              colorScheme: colorScheme,
              localizations: localizations,
              onTap: onAddTap,
            );
          }
          return _ImageTile(
            file: images[index],
            indexLabel: '${index + 1}/${images.length}',
            theme: theme,
            colorScheme: colorScheme,
            onRemove: () => onRemove(index),
          );
        },
      ),
    );
  }
}

class _AddMoreTile extends StatelessWidget {
  const _AddMoreTile({
    required this.theme,
    required this.colorScheme,
    required this.localizations,
    required this.onTap,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final AppLocalizations? localizations;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 36, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              localizations?.property_create_add_more ?? 'Add More',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({
    required this.file,
    required this.indexLabel,
    required this.theme,
    required this.colorScheme,
    required this.onRemove,
  });

  final File file;
  final String indexLabel;
  final ThemeData theme;
  final ColorScheme colorScheme;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              file,
              fit: BoxFit.cover,
              height: 200,
              width: 160,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color: colorScheme.onError,
                  size: 18,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                indexLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
