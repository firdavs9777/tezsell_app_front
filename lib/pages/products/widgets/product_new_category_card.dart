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
    this.isLoading = false,
    this.hasError = false,
    this.onRetry,
  });

  final List<CategoryModel> availableCategories;
  final int? selectedCategoryId;
  final bool isUploading;
  final String Function(CategoryModel) getCategoryName;
  final ValueChanged<CategoryModel> onCategoryChanged;

  /// Whether categories are still being fetched.
  final bool isLoading;

  /// Whether the last fetch attempt failed. When true and no categories are
  /// cached, an inline retry affordance is shown instead of the dropdown so
  /// the user isn't stuck with a required field they can't fill in.
  final bool hasError;

  /// Retries the category fetch. Required when [hasError] can be true.
  final VoidCallback? onRetry;

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
          if (isLoading)
            _buildLoadingState(theme, colorScheme, localizations)
          else if (hasError && availableCategories.isEmpty)
            _buildErrorState(theme, colorScheme, localizations)
          else
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

  Widget _buildLoadingState(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
  ) {
    return Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          localizations?.loadingCategories ?? 'Loading...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
  ) {
    return Row(
      children: [
        Icon(Icons.error_outline, size: 20, color: colorScheme.error),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            localizations?.errorLoadingCategories ?? 'Error loading categories',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh, size: 18),
          label: Text(localizations?.retry ?? 'Retry'),
        ),
      ],
    );
  }
}
