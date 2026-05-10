import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
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
        ],
      ),
    );
  }
}
