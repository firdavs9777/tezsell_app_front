import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/real_estate_detail.dart';
import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/utils/category_locale_utils.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/distance_chip.dart';
import 'package:app/widgets/service_rating_badge.dart';
import 'package:app/widgets/skeleton_loader.dart';

/// Plan B Task 7 — "Near you now" strip: latest ~10 items merged from
/// services + real estate within the active geo center/radius, sorted by
/// distance (nulls last). See `nearby_hub.dart` for placement.

enum NearbyFeedItemType { service, property }

class NearbyFeedItem {
  const NearbyFeedItem.service(Services s)
      : type = NearbyFeedItemType.service,
        service = s,
        property = null;

  const NearbyFeedItem.property(RealEstate p)
      : type = NearbyFeedItemType.property,
        service = null,
        property = p;

  final NearbyFeedItemType type;
  final Services? service;
  final RealEstate? property;

  double? get distanceKm =>
      type == NearbyFeedItemType.service ? service!.distanceKm : property!.distanceKm;

  /// Stable key for widget/list identity — not a cross-type unique id (a
  /// service and a property could share a numeric id), only used as a
  /// `ValueKey` scoped by [type].
  String get key => '${type.name}_${type == NearbyFeedItemType.service ? service!.id : property!.id}';
}

/// Mirrors `NeighborhoodGate`'s semantics (`tab_bar.dart`): the child (here,
/// the services fetch) is only allowed through when the user has at least
/// one non-expired verified neighborhood. Real estate stays city-scale and
/// is always fetched (per NeighborhoodGate's own doc comment: "Real estate
/// is intentionally NOT wrapped"). Pure — extracted for unit testing, see
/// `test/nearby_feed_strip_test.dart`.
bool canFetchServices(List<VerifiedNeighborhood> verified) {
  return verified.isNotEmpty && verified.any((v) => !v.isExpired);
}

/// Merges two already-fetched feed lists into one, sorted ascending by
/// `distanceKm` (nulls sort last), capped at 10 items. Pure and side-effect
/// free — extracted for unit testing, see `test/nearby_feed_strip_test.dart`.
List<NearbyFeedItem> mergeNearbyItems(
  List<NearbyFeedItem> a,
  List<NearbyFeedItem> b,
) {
  final merged = [...a, ...b];
  merged.sort((x, y) {
    final dx = x.distanceKm;
    final dy = y.distanceKm;
    if (dx == null && dy == null) return 0;
    if (dx == null) return 1;
    if (dy == null) return -1;
    return dx.compareTo(dy);
  });
  return merged.take(10).toList();
}

/// Fetches the two vertical feeds in parallel and merges them. Reactive to
/// `activeNeighborhoodProvider`/`radiusProvider`/`verifiedNeighborhoodsProvider`
/// via `ref.watch` (Riverpod re-runs this provider whenever any of those
/// change — equivalent to keying on lat/lng/radius).
final nearbyFeedProvider = FutureProvider.autoDispose<List<NearbyFeedItem>>((ref) async {
  final activeNbhd = ref.watch(activeNeighborhoodProvider);
  if (activeNbhd == null) return const [];

  final radius = ref.watch(radiusProvider);
  final verified = ref.watch(verifiedNeighborhoodsProvider);
  final servicesAllowed = canFetchServices(verified);

  final lat = activeNbhd.neighborhood.centroidLat;
  final lng = activeNbhd.neighborhood.centroidLng;

  final serviceProvider = ref.read(serviceMainProvider);
  final realEstateService = ref.read(realEstateServiceProvider);

  Future<List<NearbyFeedItem>> fetchServices() async {
    if (!servicesAllowed) return const [];
    try {
      final results = await serviceProvider.getFilteredServices(
        pageSize: 5,
        centerLat: lat,
        centerLng: lng,
        radiusKm: radius,
        sort: 'nearest',
      );
      return results.map((s) => NearbyFeedItem.service(s)).toList();
    } catch (_) {
      // Fail silent — the strip simply omits this vertical.
      return const [];
    }
  }

  Future<List<NearbyFeedItem>> fetchProperties() async {
    try {
      final results = await realEstateService.getFilteredProperties(
        pageSize: 5,
        centerLat: lat,
        centerLng: lng,
        radiusKm: radius,
        ordering: 'nearest',
      );
      return results.map((p) => NearbyFeedItem.property(p)).toList();
    } catch (_) {
      return const [];
    }
  }

  final fetched = await Future.wait([fetchServices(), fetchProperties()]);
  return mergeNearbyItems(fetched[0], fetched[1]);
});

class NearbyFeedStrip extends ConsumerWidget {
  const NearbyFeedStrip({super.key});

  static const _cardHeight = 100.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // No active geo center at all — nothing to show, and no point fetching.
    final hasCenter = ref.watch(activeNeighborhoodProvider) != null;
    if (!hasCenter) return const SizedBox.shrink();

    final feedAsync = ref.watch(nearbyFeedProvider);
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return feedAsync.when(
      loading: () => _Shell(
        title: l?.nearYouNow ?? 'Near you now',
        theme: theme,
        child: SizedBox(
          height: _cardHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, __) => const SkeletonBox(
              width: 150,
              height: _cardHeight,
              borderRadius: 14,
            ),
          ),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return _Shell(
          title: l?.nearYouNow ?? 'Near you now',
          theme: theme,
          child: SizedBox(
            height: _cardHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) =>
                  _NearbyFeedCard(key: ValueKey(items[index].key), item: items[index]),
            ),
          ),
        );
      },
    );
  }
}

class _Shell extends StatelessWidget {
  const _Shell({required this.title, required this.theme, required this.child});

  final String title;
  final ThemeData theme;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _NearbyFeedCard extends StatelessWidget {
  const _NearbyFeedCard({super.key, required this.item});

  final NearbyFeedItem item;

  String _categoryName(BuildContext context, Services service) =>
      CategoryLocaleUtils.localizedName(context, service.category);

  void _onTap(BuildContext context) {
    if (item.type == NearbyFeedItemType.service) {
      context.push('/service/${item.service!.id}');
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PropertyDetail(propertyId: item.property!.id),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final service = item.service;
    final property = item.property;

    final title = service?.name ?? property?.title ?? '';
    final thumbnailUrl = service != null
        ? (service.images.isNotEmpty
            ? ImageUtils.buildImageUrl(service.images.first.image)
            : null)
        : (property != null && property.mainImage.isNotEmpty ? property.mainImage : null);

    final Widget subtitle;
    if (service != null) {
      subtitle = service.ratingCount > 0
          ? ServiceRatingBadge(
              ratingAvg: service.ratingAvg,
              ratingCount: service.ratingCount,
            )
          : Text(
              _categoryName(context, service),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
    } else {
      subtitle = Text(
        '${property!.price} ${property.currency}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: colorScheme.primary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _onTap(context),
        child: Container(
          width: 150,
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImageWidget(
                  imageUrl: thumbnailUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle,
                    if (item.distanceKm != null)
                      DistanceChip(distanceKm: item.distanceKm!, pill: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

