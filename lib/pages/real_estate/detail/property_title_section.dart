import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyTitleSection extends StatelessWidget {
  final RealEstate property;
  final AppLocalizations? localizations;

  const PropertyTitleSection({
    Key? key,
    required this.property,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  property.title,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                      height: 1.2),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${property.price} ${property.currency}',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600]),
                    ),
                    if (property.pricePerSqm != null &&
                        property.pricePerSqm.isNotEmpty) ...[
                      SizedBox(height: 4),
                      Text(
                        '${property.pricePerSqm} ${property.currency}${localizations?.property_info_price_per_sqm ?? "/m²"}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.visibility, size: 16, color: Colors.blue[700]),
                    SizedBox(width: 6),
                    Text(
                      '${property.viewsCount}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

