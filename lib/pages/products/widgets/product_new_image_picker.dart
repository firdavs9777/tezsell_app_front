import 'dart:io';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_card.dart';
import 'package:flutter/material.dart';

class ProductNewImagePicker extends StatelessWidget {
  const ProductNewImagePicker({
    super.key,
    required this.images,
    required this.isUploading,
    required this.onAddTap,
    required this.onRemove,
  });

  final List<File> images;
  final bool isUploading;
  final VoidCallback onAddTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return ProductNewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductNewSectionHeader(
            title: localizations?.newProductImages ?? 'Product Images',
            icon: Icons.photo_library,
          ),
          const SizedBox(height: 16),
          if (images.isEmpty)
            _buildEmptyState(context, theme, colorScheme, localizations)
          else
            _buildImageList(context, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
  ) {
    return GestureDetector(
      onTap: isUploading ? null : onAddTap,
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
            Icon(
              Icons.add_photo_alternate,
              size: 56,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              localizations?.imageInstructions ?? 'Tap to add images',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              localizations?.oneImageConfirmMessage ??
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

  Widget _buildImageList(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        itemBuilder: (context, index) {
          if (index == images.length) {
            return _buildAddMoreTile(theme, colorScheme);
          }
          return _buildImageTile(context, theme, colorScheme, index);
        },
      ),
    );
  }

  Widget _buildAddMoreTile(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: isUploading ? null : onAddTap,
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
              'Add More',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    int index,
  ) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
              height: 200,
              width: 160,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: isUploading ? null : () => onRemove(index),
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
                '${index + 1}/${images.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
