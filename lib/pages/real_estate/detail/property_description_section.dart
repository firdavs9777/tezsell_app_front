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
    if (description == null || description!.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.sections_description ?? 'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text(description!,
            style:
                TextStyle(fontSize: 16, height: 1.5, color: Colors.grey[700])),
      ],
    );
  }
}

