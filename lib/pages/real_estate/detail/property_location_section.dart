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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red[400]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${property.address}, ${property.city}, ${property.district}',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              if (floor != null && totalFloors != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${localizations?.property_details_floor ?? "Floor"}: $floor ${localizations?.property_details_of ?? "of"} $totalFloors',
                  style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location',
                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                  TextButton.icon(
                    onPressed: onFullscreenMap,
                    icon: const Icon(Icons.fullscreen, size: 16),
                    label:
                        Text('View Fullscreen', style: textTheme.bodySmall),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PropertyMapWidget(
                property: property,
                height: 250,
                showControls: true,
                onFullscreenToggle: onFullscreenMap,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red[400], size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(property.address,
                              style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500, color: colorScheme.onSurface)),
                          Text('${property.district}, ${property.city}',
                              style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant)),
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

