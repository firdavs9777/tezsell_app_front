import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NeighborhoodSwitcherSheet extends ConsumerWidget {
  const NeighborhoodSwitcherSheet({super.key});

  String _displayName(neighborhood) {
    return neighborhood.city.isNotEmpty ? neighborhood.city : neighborhood.name;
  }

  String _verifiedLabel(AppLocalizations? l, DateTime verifiedAt) {
    final days = DateTime.now().difference(verifiedAt).inDays;
    if (days == 0) return l?.verified_today ?? 'Verified today';
    if (days == 1) return l?.verified_yesterday ?? 'Verified yesterday';
    return l?.verified_n_days_ago(days) ?? 'Verified $days days ago';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final verified = ref.watch(verifiedNeighborhoodsProvider);
    final activeIdx = ref.watch(activeNeighborhoodIndexProvider);

    void switchTo(int idx) {
      ref.read(activeNeighborhoodIndexProvider.notifier).state = idx;
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
      Navigator.of(context).pop();
    }

    void openMap() {
      final router = GoRouter.of(context);
      Navigator.of(context).pop();
      router.push('/location/manage');
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l?.my_neighborhoods ?? 'My Neighborhoods',
                  style: tt.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: openMap,
                  child: Text(l?.manage_on_map ?? 'Manage on map →'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (verified.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Text(
                      l?.no_neighborhoods_yet ??
                          'No verified neighborhoods yet. Open the map to verify where you are.',
                      textAlign: TextAlign.center,
                      style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: openMap,
                      child: Text(l?.open_map_to_verify ?? 'Open map'),
                    ),
                  ],
                ),
              )
            else
              ...List.generate(verified.length, (i) {
                final v = verified[i];
                final isActive = i == activeIdx;
                final name = _displayName(v.neighborhood);
                return ListTile(
                  tileColor: isActive
                      ? cs.primaryContainer.withValues(alpha: 0.15)
                      : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  leading: CircleAvatar(
                    backgroundColor: isActive
                        ? cs.primaryContainer
                        : cs.surfaceContainerHighest,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: isActive
                            ? cs.onPrimaryContainer
                            : cs.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    name,
                    style: TextStyle(
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.normal),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    _verifiedLabel(l, v.verifiedAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isActive
                      ? Icon(Icons.check_circle_rounded, color: cs.primary)
                      : null,
                  onTap: () => switchTo(i),
                );
              }),
            const SizedBox(height: 12),
            if (verified.isNotEmpty)
              OutlinedButton.icon(
                onPressed: openMap,
                icon: const Icon(Icons.map_outlined),
                label: Text(
                  l?.open_map_to_verify ?? 'Open map to verify new location',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
