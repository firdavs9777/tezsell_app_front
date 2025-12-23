import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyFeaturesSection extends StatelessWidget {
  final bool hasBalcony;
  final bool hasGarage;
  final bool hasGarden;
  final bool hasPool;
  final bool hasElevator;
  final bool isFurnished;
  final AppLocalizations? localizations;

  const PropertyFeaturesSection({
    Key? key,
    required this.hasBalcony,
    required this.hasGarage,
    required this.hasGarden,
    required this.hasPool,
    required this.hasElevator,
    required this.isFurnished,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final features = <String, bool>{
      localizations?.property_card_balcony ?? 'Balcony': hasBalcony,
      localizations?.property_card_garage ?? 'Garage': hasGarage,
      localizations?.property_card_garden ?? 'Garden': hasGarden,
      localizations?.property_card_pool ?? 'Pool': hasPool,
      localizations?.property_card_elevator ?? 'Elevator': hasElevator,
      localizations?.property_card_furnished ?? 'Furnished': isFurnished,
    };

    final availableFeatures = features.entries.where((e) => e.value).toList();

    if (availableFeatures.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.property_details_features_amenities ??
              'Features & Amenities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableFeatures.map((feature) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Text(
                feature.key,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

