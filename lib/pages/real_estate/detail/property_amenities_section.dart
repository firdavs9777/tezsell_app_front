import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyAmenitiesSection extends StatelessWidget {
  final int? metroDistance;
  final int? schoolDistance;
  final int? hospitalDistance;
  final int? shoppingDistance;
  final AppLocalizations? localizations;

  const PropertyAmenitiesSection({
    Key? key,
    this.metroDistance,
    this.schoolDistance,
    this.hospitalDistance,
    this.shoppingDistance,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final amenities = <String, int?>{};

    if (metroDistance != null) {
      amenities[localizations?.amenities_metro ?? 'Metro'] = metroDistance;
    }
    if (schoolDistance != null) {
      amenities[localizations?.amenities_school ?? 'School'] = schoolDistance;
    }
    if (hospitalDistance != null) {
      amenities[localizations?.amenities_hospital ?? 'Hospital'] =
          hospitalDistance;
    }
    if (shoppingDistance != null) {
      amenities[localizations?.amenities_shopping ?? 'Shopping'] =
          shoppingDistance;
    }

    final availableAmenities = amenities.entries
        .where((e) => e.value != null && e.value! > 0)
        .toList();

    if (availableAmenities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.sections_nearby_amenities ?? 'Nearby Amenities',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: availableAmenities.map((amenity) {
              IconData amenityIcon;
              Color amenityColor;

              if (amenity.key.toLowerCase().contains('metro')) {
                amenityIcon = Icons.train;
                amenityColor = Colors.blue;
              } else if (amenity.key.toLowerCase().contains('school')) {
                amenityIcon = Icons.school;
                amenityColor = Colors.green;
              } else if (amenity.key.toLowerCase().contains('hospital')) {
                amenityIcon = Icons.local_hospital;
                amenityColor = Colors.red;
              } else if (amenity.key.toLowerCase().contains('shopping')) {
                amenityIcon = Icons.shopping_cart;
                amenityColor = Colors.orange;
              } else {
                amenityIcon = Icons.location_on;
                amenityColor = Colors.grey;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: amenityColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(amenityIcon, color: amenityColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        amenity.key,
                        style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${amenity.value}m ${localizations?.amenities_away ?? "away"}',
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

