import 'package:flutter/material.dart';

/// Shared "⭐ 4.8 (12)" rating row, used on both the services list card
/// (`services_list.dart`) and the service detail header
/// (`service_detail_content.dart`), Plan B Task 7. Renders nothing when
/// there are zero visible reviews — callers should still gate on
/// `ratingCount > 0` before instantiating, but this widget is defensive too.
class ServiceRatingBadge extends StatelessWidget {
  const ServiceRatingBadge({
    super.key,
    required this.ratingAvg,
    required this.ratingCount,
    this.compact = true,
  });

  /// Seller's aggregate rating (1dp). Expected non-null when [ratingCount] > 0.
  final double? ratingAvg;
  final int ratingCount;

  /// `true` renders a small pill (fits inline in a card's badge row).
  /// `false` renders a slightly larger inline row (detail header).
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (ratingCount <= 0 || ratingAvg == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final iconSize = compact ? 12.0 : 16.0;
    final fontSize = compact ? 11.0 : 14.0;
    final label = '${ratingAvg!.toStringAsFixed(1)} ($ratingCount)';

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber, size: iconSize),
        const SizedBox(width: 3.0),
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );

    if (!compact) return content;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: content,
    );
  }
}
