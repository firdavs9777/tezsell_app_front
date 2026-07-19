import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/service/main/main_service.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/tab_bar/tab_bar.dart' show NeighborhoodGate;
import 'package:app/pages/nearby/nearby_feed_strip.dart';

class NearbyHub extends ConsumerWidget {
  const NearbyHub({
    super.key,
    required this.regionName,
    required this.districtName,
    required this.districtId,
  });

  final String regionName;
  final String districtName;
  final int? districtId;

  void _open(BuildContext context, Widget page, String title) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: Text(title)), body: page),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    final services = _NearbyCard(
      icon: Icons.handyman,
      color: const Color(0xFFE8F5EC),
      title: l?.nearbyServices ?? 'Services',
      subtitle: l?.servicesTitle ?? 'Plumbers, tutors, cleaning…',
      onTap: () => _open(
        context,
        NeighborhoodGate(
          child: ServiceMain(
            regionName: regionName,
            districtName: districtName,
            districtId: districtId,
          ),
        ),
        l?.nearbyServices ?? 'Services',
      ),
    );

    final realEstate = _NearbyCard(
      icon: Icons.apartment,
      color: const Color(0xFFE9F0FB),
      title: l?.nearbyRealEstate ?? 'Real Estate',
      subtitle: l?.realEstate ?? 'Rentals & sales near you',
      onTap: () => _open(
        context,
        RealEstateMain(
          regionName: regionName,
          districtName: districtName,
          districtId: districtId,
        ),
        l?.nearbyRealEstate ?? 'Real Estate',
      ),
    );

    return RefreshIndicator(
      onRefresh: () => ref.refresh(nearbyFeedProvider.future),
      child: ListView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const NearbyFeedStrip(),
          services,
          const SizedBox(height: 12),
          realEstate,
          const SizedBox(height: 12),
          _NearbyCard(
            icon: Icons.work_outline,
            color: const Color(0xFFF3EEFB),
            title: l?.nearbyJobs ?? 'Jobs',
            subtitle: l?.nearbyComingSoon ?? 'Coming soon',
            onTap: null,
          ),
          const SizedBox(height: 12),
          _NearbyCard(
            icon: Icons.storefront,
            color: const Color(0xFFFDF0E8),
            title: l?.nearbyShops ?? 'Local shops',
            subtitle: l?.nearbyComingSoon ?? 'Coming soon',
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _NearbyCard extends StatelessWidget {
  const _NearbyCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Card(
        child: ListTile(
          onTap: onTap,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.black87),
          ),
          title: Text(title, style: theme.textTheme.titleMedium),
          subtitle: Text(subtitle),
          trailing: enabled ? const Icon(Icons.chevron_right) : null,
        ),
      ),
    );
  }
}
