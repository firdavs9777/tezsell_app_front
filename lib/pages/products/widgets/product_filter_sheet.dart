import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/l10n/app_localizations.dart';

/// Plan D Task 4 — price range + condition filter state for the products
/// list. Immutable; the list screen (`ProductsList`) holds a single instance
/// in memory and re-fetches through `ProductsService.getFilteredProducts`
/// whenever it changes. Not persisted — resets on navigation away, mirroring
/// the in-memory sort mode from Plan B Task 3.
class ProductFilter {
  const ProductFilter({this.priceMin, this.priceMax, this.condition});

  /// No filters applied — the default state.
  static const empty = ProductFilter();

  final double? priceMin;
  final double? priceMax;

  /// One of `new`/`like_new`/`used`/`refurbished`, or null for "any".
  final String? condition;

  bool get isActive =>
      priceMin != null || priceMax != null || (condition?.isNotEmpty ?? false);

  int get activeCount {
    var count = 0;
    if (priceMin != null) count++;
    if (priceMax != null) count++;
    if (condition != null && condition!.isNotEmpty) count++;
    return count;
  }

  ProductFilter copyWith({
    double? priceMin,
    bool clearPriceMin = false,
    double? priceMax,
    bool clearPriceMax = false,
    String? condition,
    bool clearCondition = false,
  }) {
    return ProductFilter(
      priceMin: clearPriceMin ? null : (priceMin ?? this.priceMin),
      priceMax: clearPriceMax ? null : (priceMax ?? this.priceMax),
      condition: clearCondition ? null : (condition ?? this.condition),
    );
  }

  /// Query params matching the backend's product-list filter contract
  /// (`price_min`/`price_max` as fixed-2dp decimal strings, `condition`
  /// passed through as-is). Used by tests to verify serialization; the
  /// provider builds the equivalent params itself from the raw fields.
  Map<String, String> toQueryParams() {
    final params = <String, String>{};
    if (priceMin != null) params['price_min'] = priceMin!.toStringAsFixed(2);
    if (priceMax != null) params['price_max'] = priceMax!.toStringAsFixed(2);
    if (condition != null && condition!.isNotEmpty) {
      params['condition'] = condition!;
    }
    return params;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductFilter &&
          other.priceMin == priceMin &&
          other.priceMax == priceMax &&
          other.condition == condition);

  @override
  int get hashCode => Object.hash(priceMin, priceMax, condition);
}

/// The 4 backend-recognized `condition` values, in display order.
const List<String> kProductConditions = [
  'new',
  'like_new',
  'used',
  'refurbished',
];

/// Localized label for a condition value; falls back to the raw value for
/// anything unrecognized.
String productConditionLabel(AppLocalizations? l, String condition) {
  switch (condition) {
    case 'new':
      return l?.condition_new ?? 'New';
    case 'like_new':
      return l?.condition_like_new ?? 'Like New';
    case 'used':
      return l?.condition_used ?? 'Used';
    case 'refurbished':
      return l?.condition_refurbished ?? 'Refurbished';
    default:
      return condition;
  }
}

/// Modal bottom sheet for the products list' price range + condition
/// filters. Returns the applied [ProductFilter] via `Navigator.pop`, or null
/// if dismissed without applying — the caller should treat null as "no
/// change" (see `ProductsList._openFilterSheet`).
class ProductFilterSheet extends StatefulWidget {
  const ProductFilterSheet({super.key, required this.initialFilter});

  final ProductFilter initialFilter;

  @override
  State<ProductFilterSheet> createState() => _ProductFilterSheetState();
}

class _ProductFilterSheetState extends State<ProductFilterSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _condition;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.initialFilter.priceMin != null
          ? _trimZeros(widget.initialFilter.priceMin!)
          : '',
    );
    _maxController = TextEditingController(
      text: widget.initialFilter.priceMax != null
          ? _trimZeros(widget.initialFilter.priceMax!)
          : '',
    );
    _condition = widget.initialFilter.condition;
  }

  static String _trimZeros(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _reset() {
    HapticFeedback.selectionClick();
    setState(() {
      _minController.clear();
      _maxController.clear();
      _condition = null;
    });
  }

  void _apply() {
    HapticFeedback.selectionClick();
    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());
    Navigator.of(context).pop(ProductFilter(
      priceMin: min,
      priceMax: max,
      condition: _condition,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l?.productFiltersTitle ?? 'Filters',
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          Text(
            l?.productFilterPriceRange ?? 'Price range',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: l?.productFilterPriceMin ?? 'Min',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  ],
                  decoration: InputDecoration(
                    labelText: l?.productFilterPriceMax ?? 'Max',
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            l?.productFilterCondition ?? 'Condition',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in kProductConditions)
                ChoiceChip(
                  label: Text(productConditionLabel(l, c)),
                  selected: _condition == c,
                  onSelected: (selected) {
                    HapticFeedback.selectionClick();
                    setState(() => _condition = selected ? c : null);
                  },
                  selectedColor: colorScheme.primary,
                  labelStyle: TextStyle(
                    color: _condition == c
                        ? colorScheme.onPrimary
                        : colorScheme.onSurfaceVariant,
                    fontWeight:
                        _condition == c ? FontWeight.w600 : FontWeight.w400,
                  ),
                  backgroundColor:
                      colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  side: BorderSide.none,
                ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: Text(l?.productFilterReset ?? 'Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _apply,
                  child: Text(l?.productFilterApply ?? 'Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
