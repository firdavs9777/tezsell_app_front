import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_new_card.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:flutter/material.dart';

class ProductNewCategoryCard extends StatelessWidget {
  const ProductNewCategoryCard({
    super.key,
    required this.availableCategories,
    required this.selectedCategoryId,
    required this.isUploading,
    required this.getCategoryName,
    required this.onCategoryChanged,
  });

  final List<CategoryModel> availableCategories;
  final int? selectedCategoryId;
  final bool isUploading;
  final String Function(CategoryModel) getCategoryName;
  final ValueChanged<CategoryModel> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final fillColor = colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    return ProductNewCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductNewSectionHeader(
            title: localizations?.newProductCategory ?? 'Category',
            icon: Icons.category,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<CategoryModel>(
            initialValue: selectedCategoryId != null && availableCategories.isNotEmpty
                ? availableCategories.firstWhere(
                    (cat) => cat.id == selectedCategoryId,
                    orElse: () => availableCategories.first,
                  )
                : null,
            isExpanded: true,
            decoration: InputDecoration(
              labelText:
                  '${localizations?.newProductCategory ?? 'Select Category'} *',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.category),
              filled: true,
              fillColor: fillColor,
            ),
            hint: Text(
              localizations?.selectCategory ?? 'Select a category',
              overflow: TextOverflow.ellipsis,
            ),
            items: availableCategories
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                      getCategoryName(category),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: isUploading
                ? null
                : (CategoryModel? value) {
                    if (value != null) {
                      onCategoryChanged(value);
                    }
                  },
            validator: (value) {
              if (value == null) {
                return localizations?.categoryRequiredMessage ??
                    'Please select a category';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
