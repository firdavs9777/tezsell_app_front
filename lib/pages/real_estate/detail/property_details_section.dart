import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyDetailsSection extends StatelessWidget {
  final RealEstate property;
  final int? yearBuilt;
  final AppLocalizations? localizations;

  const PropertyDetailsSection({
    Key? key,
    required this.property,
    this.yearBuilt,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.property_details_basic_information ??
              'Basic Information',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        _buildDetailRow(
          localizations?.property_details_property_type ?? 'Property Type:',
          property.propertyTypeDisplay,
        ),
        _buildDetailRow(
          localizations?.property_details_listing_type ?? 'Listing Type:',
          property.listingTypeDisplay,
        ),
        if (yearBuilt != null)
          _buildDetailRow(
            localizations?.property_details_year_built ?? 'Year Built:',
            yearBuilt.toString(),
          ),
      ],
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

