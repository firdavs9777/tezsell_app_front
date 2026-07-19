import 'package:flutter/material.dart';

/// Circular cluster badge shared by every map browse surface (Plan B Task 5:
/// products/services `ItemsMapView` and `RealEstateMapView`). Rendered by a
/// `MarkerClusterLayerOptions.builder` from `flutter_map_marker_cluster`.
///
/// Sized by count tier: 1-9 small, 10-99 medium, 100+ large. Primary color
/// background, white count text (caps display at "99+").
class ClusterBadge extends StatelessWidget {
  const ClusterBadge({super.key, required this.count});

  final int count;

  /// Shared tier sizing so the badge's own rendering and each map's
  /// `MarkerClusterLayerOptions.computeSize` (which controls the actual
  /// tappable/layout bounds the badge is constrained into) can never drift
  /// apart. 1-9 small, 10-99 medium, 100+ large.
  static Size clusterSizeFor(int count) {
    if (count < 10) return const Size(36, 36);
    if (count < 100) return const Size(46, 46);
    return const Size(56, 56);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final Size boxSize = clusterSizeFor(count);
    final double size = boxSize.width;
    final double fontSize;
    if (count < 10) {
      fontSize = 13;
    } else if (count < 100) {
      fontSize = 14;
    } else {
      fontSize = 15;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.primary,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: TextStyle(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
