import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class PropertyDescriptionSection extends StatelessWidget {
  final String? description;
  final AppLocalizations? localizations;

  const PropertyDescriptionSection({
    Key? key,
    this.description,
    this.localizations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (description == null || description!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.sections_description ?? 'Description',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
        ),
        SizedBox(height: 12),
        Text(description!,
            style: textTheme.bodyLarge?.copyWith(height: 1.5, color: colorScheme.onSurface)),
      ],
    );
  }
}

