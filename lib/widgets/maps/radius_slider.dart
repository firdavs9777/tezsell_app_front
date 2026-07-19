import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/widgets/maps/radius_picker_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RadiusSlider extends ConsumerWidget {
  static const _presets = [1.0, 3.0, 5.0, 10.0];
  const RadiusSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(radiusProvider);
    final notifier = ref.read(radiusProvider.notifier);
    final l = AppLocalizations.of(context);
    final isCustom = current != double.infinity && !_presets.contains(current);
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: [
          for (final p in _presets)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(l?.radius_slider_km(p.toStringAsFixed(0)) ??
                    '${p.toStringAsFixed(0)} km'),
                selected: current == p,
                onSelected: (_) => notifier.set(p),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(l?.radius_slider_city ?? 'City'),
              selected: current == double.infinity,
              onSelected: (_) => notifier.set(double.infinity),
            ),
          ),
          if (isCustom)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ChoiceChip(
                label: Text(
                    '${l?.radius_slider_km(current.toStringAsFixed(1)) ?? '${current.toStringAsFixed(1)} km'} ▾'),
                selected: true,
                onSelected: (_) => RadiusPickerSheet.show(context),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Tooltip(
              message: l?.radiusPickerTitle ?? 'Search radius',
              child: IconButton.filledTonal(
                key: const Key('RadiusSlider.tuneButton'),
                icon: const Icon(Icons.tune, size: 20),
                onPressed: () => RadiusPickerSheet.show(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
