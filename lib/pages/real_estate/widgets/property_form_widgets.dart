import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PropertyFormCard extends StatelessWidget {
  const PropertyFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class PropertyFormSectionHeader extends StatelessWidget {
  const PropertyFormSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class PropertyFormDropdownField extends StatelessWidget {
  const PropertyFormDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<Map<String, String>> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  String _localizedLabel(
    AppLocalizations? l,
    String value,
    String fallback,
  ) {
    if (l == null) return fallback;
    switch (value) {
      case 'apartment':
        return l.property_types_apartment;
      case 'house':
        return l.property_types_house;
      case 'townhouse':
        return l.property_types_townhouse;
      case 'villa':
        return l.property_types_villa;
      case 'commercial':
        return l.property_types_commercial;
      case 'office':
        return l.property_types_office;
      case 'land':
        return l.property_types_land;
      case 'warehouse':
        return l.property_types_warehouse;
      case 'sale':
        return l.listing_types_for_sale;
      case 'rent':
        return l.listing_types_for_rent;
      default:
        return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor:
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item['value'],
          child: Text(
            _localizedLabel(localizations, item['value']!, item['label']!),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class PropertyFormDetailInputField extends StatelessWidget {
  const PropertyFormDetailInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.isRequired,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor:
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: isRequired
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return localizations?.property_create_required ?? 'Required';
              }
              return null;
            }
          : null,
    );
  }
}

class PropertyFeatureChip extends StatelessWidget {
  const PropertyFeatureChip({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: value,
      onSelected: onChanged,
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: value
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurface,
        fontWeight: value ? FontWeight.w600 : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: value
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.3),
          width: value ? 1.5 : 1,
        ),
      ),
    );
  }
}
