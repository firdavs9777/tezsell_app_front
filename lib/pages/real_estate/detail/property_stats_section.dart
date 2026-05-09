import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyStatsSection extends StatelessWidget {
  final int bedrooms;
  final int bathrooms;
  final int squareMeters;
  final int parkingSpaces;
  final AppLocalizations? localizations;

  const PropertyStatsSection({
    Key? key,
    required this.bedrooms,
    required this.bathrooms,
    required this.squareMeters,
    required this.parkingSpaces,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        _buildStatItem(context, Icons.bed, '$bedrooms',
            localizations?.property_card_bed ?? 'bed', colorScheme),
        const SizedBox(width: 24),
        _buildStatItem(context, Icons.bathroom, '$bathrooms',
            localizations?.property_card_bath ?? 'bath', colorScheme),
        const SizedBox(width: 24),
        _buildStatItem(context, Icons.square_foot, '${squareMeters}m²', 'area', colorScheme),
        if (parkingSpaces > 0) ...[
          const SizedBox(width: 24),
          _buildStatItem(context, Icons.local_parking, '$parkingSpaces',
              localizations?.property_card_parking ?? 'parking', colorScheme),
        ],
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String value, String label, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(value,
            style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        Text(label, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

