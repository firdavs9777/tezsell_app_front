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
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.property_status_title ?? 'Property Status',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _buildDetailRow(
            localizations?.property_status_availability ?? 'Availability:',
            isActive
                ? (localizations?.property_status_available ?? 'Available')
                : (localizations?.property_status_not_available ??
                    'Not Available'),
          ),
          _buildDetailRow(
            localizations?.property_status_property_id ?? 'Property ID:',
            property.id,
          ),
          _buildDetailRow(
            localizations?.property_info_listed ?? 'Listed:',
            property.createdAt.toString().split(' ')[0],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.grey[600])),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[900])),
          ),
        ],
      ),
    );
  }
}

