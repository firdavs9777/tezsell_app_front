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
    return Row(
      children: [
        _buildStatItem(Icons.bed, '$bedrooms',
            localizations?.property_card_bed ?? 'bed'),
        SizedBox(width: 24),
        _buildStatItem(Icons.bathroom, '$bathrooms',
            localizations?.property_card_bath ?? 'bath'),
        SizedBox(width: 24),
        _buildStatItem(Icons.square_foot, '${squareMeters}m²', 'area'),
        if (parkingSpaces > 0) ...[
          SizedBox(width: 24),
          _buildStatItem(Icons.local_parking, '$parkingSpaces',
              localizations?.property_card_parking ?? 'parking'),
        ],
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey[600]),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[900])),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

