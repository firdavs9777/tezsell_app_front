import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/l10n/app_localizations.dart';
import 'property_map_widget.dart';

class PropertyLocationSection extends StatelessWidget {
  final RealEstate property;
  final int? floor;
  final int? totalFloors;
  final VoidCallback onFullscreenMap;
  final AppLocalizations? localizations;

  const PropertyLocationSection({
    Key? key,
    required this.property,
    this.floor,
    this.totalFloors,
    required this.onFullscreenMap,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red[400]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${property.address}, ${property.city}, ${property.district}',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (floor != null && totalFloors != null) ...[
                SizedBox(height: 8),
                Text(
                  '${localizations?.property_details_floor ?? "Floor"}: $floor ${localizations?.property_details_of ?? "of"} $totalFloors',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: onFullscreenMap,
                    icon: Icon(Icons.fullscreen, size: 16),
                    label:
                        Text('View Fullscreen', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              PropertyMapWidget(
                property: property,
                height: 250,
                showControls: true,
                onFullscreenToggle: onFullscreenMap,
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red[400], size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(property.address,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14, color: colorScheme.onSurface)),
                          Text('${property.district}, ${property.city}',
                              style: TextStyle(
                                  color: colorScheme.onSurfaceVariant, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

