import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/products/widgets/product_filter_sheet.dart'
    show kProductConditions, productConditionLabel;
import 'package:app/pages/products/widgets/product_new_card.dart';
import 'package:flutter/material.dart';

/// Condition selector for the product-create form. This is a second-hand
/// marketplace, so every app-created listing needs a real condition instead
/// of the backend model default ('new') — the caller defaults the selection
/// to 'used'. Reuses the same `kProductConditions` values and localized
/// labels as the products-list filter sheet for consistency.
class ProductNewConditionCard extends StatelessWidget {
  const ProductNewConditionCard({
    super.key,
    required this.selectedCondition,
    required this.isUploading,
    required this.onConditionChanged,
  });

  final String selectedCondition;
  final bool isUploading;
  final ValueChanged<String> onConditionChanged;

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
            title: localizations?.newProductCondition ?? 'Condition',
            icon: Icons.sell_outlined,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in kProductConditions)
                ChoiceChip(
                  label: Text(
                    productConditionLabel(localizations, c),
                    overflow: TextOverflow.ellipsis,
                  ),
                  selected: selectedCondition == c,
                  onSelected: isUploading
                      ? null
                      : (selected) {
                          if (selected) onConditionChanged(c);
                        },
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: selectedCondition == c
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.onSurfaceVariant,
                    fontWeight: selectedCondition == c
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                  selectedColor: colorScheme.secondaryContainer,
                  backgroundColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  side: BorderSide(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
