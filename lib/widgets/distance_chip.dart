import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Shared "📍 {km} km" chip shown on cards/list rows when a geo distance is
/// known (`distance_km` present on the model).
///
/// Two visual variants are used across the app, both preserved exactly as
/// they existed before this widget was extracted (see Plan B Task 9
/// cleanup — this used to be three/four near-identical private widgets:
/// `_DistanceChip` in `main_products.dart`, `_ServiceDistanceChip` in
/// `services_list.dart`, `_buildDistanceChip` in
/// `real_estate_property_card.dart`, and `_DistanceChip` in
/// `nearby_feed_strip.dart`):
/// - [pill] (default `true`): a boxed pill with a `primaryContainer`
///   background — used on product/service/real-estate list cards.
/// - `pill: false`: a bare icon+text row, smaller and without a background —
///   used in the compact "near you now" feed-strip cards.
class DistanceChip extends StatelessWidget {
  const DistanceChip({
    super.key,
    required this.distanceKm,
    this.pill = true,
    this.margin,
  });

  final double distanceKm;
  final bool pill;

  /// Only meaningful when [pill] is true (e.g. the real-estate card needs a
  /// `left: 6` margin since it sits next to a text row rather than inside a
  /// `Row` with its own spacing).
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = AppLocalizations.of(context)
            ?.distanceKm(distanceKm.toStringAsFixed(1)) ??
        '${distanceKm.toStringAsFixed(1)} km';

    if (!pill) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on_rounded, size: 11, color: colorScheme.primary),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
        ],
      );
    }

    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on_rounded,
            color: colorScheme.primary,
            size: 12.0,
          ),
          const SizedBox(width: 3.0),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
