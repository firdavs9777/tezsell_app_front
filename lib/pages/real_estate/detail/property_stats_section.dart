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
        _buildStatItem(Icons.bed, '$bedrooms',
            localizations?.property_card_bed ?? 'bed', colorScheme),
        SizedBox(width: 24),
        _buildStatItem(Icons.bathroom, '$bathrooms',
            localizations?.property_card_bath ?? 'bath', colorScheme),
        SizedBox(width: 24),
        _buildStatItem(Icons.square_foot, '${squareMeters}m²', 'area', colorScheme),
        if (parkingSpaces > 0) ...[
          SizedBox(width: 24),
          _buildStatItem(Icons.local_parking, '$parkingSpaces',
              localizations?.property_card_parking ?? 'parking', colorScheme),
        ],
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label, ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(icon, size: 24, color: colorScheme.onSurfaceVariant),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface)),
        Text(label, style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

