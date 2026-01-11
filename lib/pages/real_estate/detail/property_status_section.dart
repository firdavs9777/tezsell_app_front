import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyStatusSection extends StatelessWidget {
  final RealEstate property;
  final bool isActive;
  final AppLocalizations? localizations;

  const PropertyStatusSection({
    Key? key,
    required this.property,
    required this.isActive,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.property_status_title ?? 'Property Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            localizations?.property_status_availability ?? 'Availability:',
            isActive
                ? (localizations?.property_status_available ?? 'Available')
                : (localizations?.property_status_not_available ??
                    'Not Available'),
            colorScheme,
          ),
          _buildDetailRow(
            localizations?.property_status_property_id ?? 'Property ID:',
            property.id,
            colorScheme,
          ),
          _buildDetailRow(
            localizations?.property_info_listed ?? 'Listed:',
            property.createdAt.toString().split(' ')[0],
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}

