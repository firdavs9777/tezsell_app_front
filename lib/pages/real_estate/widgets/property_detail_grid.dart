import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/widgets/property_form_widgets.dart';
import 'package:flutter/material.dart';

class PropertyDetailGrid extends StatelessWidget {
  const PropertyDetailGrid({
    super.key,
    required this.squareMetersController,
    required this.bedroomsController,
    required this.bathroomsController,
    required this.floorController,
    required this.totalFloorsController,
    required this.parkingSpacesController,
    required this.yearBuiltController,
  });

  final TextEditingController squareMetersController;
  final TextEditingController bedroomsController;
  final TextEditingController bathroomsController;
  final TextEditingController floorController;
  final TextEditingController totalFloorsController;
  final TextEditingController parkingSpacesController;
  final TextEditingController yearBuiltController;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PropertyFormDetailInputField(
                controller: squareMetersController,
                label: l?.property_create_square_meters ?? 'Sq. Meters *',
                icon: Icons.square_foot,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PropertyFormDetailInputField(
                controller: bedroomsController,
                label: l?.property_create_bedrooms ?? 'Bedrooms *',
                icon: Icons.bed,
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PropertyFormDetailInputField(
                controller: bathroomsController,
                label: l?.property_create_bathrooms ?? 'Bathrooms *',
                icon: Icons.bathroom,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PropertyFormDetailInputField(
                controller: floorController,
                label: l?.property_create_floor ?? 'Floor',
                icon: Icons.layers,
                isRequired: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PropertyFormDetailInputField(
                controller: totalFloorsController,
                label: l?.property_create_total_floors ?? 'Total Floors',
                icon: Icons.business,
                isRequired: false,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: PropertyFormDetailInputField(
                controller: parkingSpacesController,
                label: l?.property_create_parking ?? 'Parking',
                icon: Icons.local_parking,
                isRequired: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: PropertyFormDetailInputField(
                controller: yearBuiltController,
                label: l?.property_create_year_built ?? 'Year Built',
                icon: Icons.calendar_today,
                isRequired: false,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
