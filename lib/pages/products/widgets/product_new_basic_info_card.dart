import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_card.dart';
import 'package:flutter/material.dart';

class ProductNewBasicInfoCard extends StatelessWidget {
  const ProductNewBasicInfoCard({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.isUploading,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final fillColor = colorScheme.surfaceContainerHighest.withOpacity(0.3);

    return ProductNewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductNewSectionHeader(
            title: localizations?.newProductTitle ?? 'Product Information',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            enabled: !isUploading,
            decoration: InputDecoration(
              labelText:
                  '${localizations?.newProductTitle ?? 'Product Name'} *',
              hintText:
                  localizations?.newProductTitle ?? 'Enter product name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.shopping_bag),
              filled: true,
              fillColor: fillColor,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return localizations?.pleaseFillAllRequired ??
                    'Please enter product name';
              }
              if (value.trim().length < 3) {
                return 'Product name must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: descriptionController,
            enabled: !isUploading,
            maxLines: 4,
            decoration: InputDecoration(
              labelText:
                  '${localizations?.newProductDescription ?? 'Description'} *',
              hintText: localizations?.newProductDescription ??
                  'Describe your product in detail...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: fillColor,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return localizations?.pleaseFillAllRequired ??
                    'Please enter description';
              }
              if (value.trim().length < 10) {
                return 'Description must be at least 10 characters';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
