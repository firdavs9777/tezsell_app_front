import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

/// Sort mode for browse screens (products/services/real estate).
/// `nearest` requires an active geo center (a verified neighborhood / map
/// pick with lat+lng) — the backend falls back to `fresh` otherwise.
enum ListingSort { fresh, nearest }

/// Compact "Fresh | Nearest" segmented toggle matching the app's existing
/// pill/chip pattern (see `_ProductBrowseModeToggle` in products_list.dart).
///
/// The nearest segment is disabled (but still visible) when [nearestEnabled]
/// is false, i.e. no geo center is currently active.
class FreshNearestToggle extends StatelessWidget {
  const FreshNearestToggle({
    super.key,
    required this.mode,
    required this.onChanged,
    this.nearestEnabled = true,
  });

  final ListingSort mode;
  final ValueChanged<ListingSort> onChanged;
  final bool nearestEnabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    Widget segment(String label, ListingSort value, {required bool enabled}) {
      final active = mode == value;
      final textColor = !enabled
          ? colorScheme.onSurface.withValues(alpha: 0.35)
          : active
              ? colorScheme.onPrimary
              : colorScheme.primary;
      return InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: enabled ? () => onChanged(value) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: active && enabled ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          segment(localizations?.sortFresh ?? 'Newest', ListingSort.fresh,
              enabled: true),
          segment(localizations?.sortNearest ?? 'Nearest', ListingSort.nearest,
              enabled: nearestEnabled),
        ],
      ),
    );
  }
}
