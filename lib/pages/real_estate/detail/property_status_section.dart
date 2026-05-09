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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
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
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            context,
            localizations?.property_status_availability ?? 'Availability:',
            isActive
                ? (localizations?.property_status_available ?? 'Available')
                : (localizations?.property_status_not_available ??
                    'Not Available'),
            colorScheme,
          ),
          _buildDetailRow(
            context,
            localizations?.property_status_property_id ?? 'Property ID:',
            property.id,
            colorScheme,
          ),
          _buildDetailRow(
            context,
            localizations?.property_info_listed ?? 'Listed:',
            property.createdAt.toString().split(' ')[0],
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, ColorScheme colorScheme) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, color: colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            child: Text(value, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
          ),
        ],
      ),
    );
  }
}

