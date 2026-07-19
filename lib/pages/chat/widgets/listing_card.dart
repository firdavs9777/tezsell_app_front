// lib/pages/chat/widgets/listing_card.dart
//
// Pinned card shown at the top of a listing-anchored chat room (and reused
// wherever a compact listing summary is needed). Mirrors the backend's
// `ChatRoomSerializer.get_listing` shape via `ChatListing`.

import 'package:app/providers/provider_models/message_model.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ListingCard extends StatelessWidget {
  final ChatListing listing;

  const ListingCard({super.key, required this.listing});

  String? _route() {
    switch (listing.type) {
      case 'product':
        return '/product/${listing.id}';
      case 'service':
        return '/service/${listing.id}';
      case 'property':
        return '/real-estate/${listing.id}';
      default:
        return null;
    }
  }

  String _priceLine() {
    if (listing.price == null || listing.price!.isEmpty) return '';
    final parsed = double.tryParse(listing.price!);
    final formatted = parsed != null
        ? parsed.toInt().toString().replaceAllMapped(
              RegExp(r'\B(?=(\d{3})+(?!\d))'),
              (match) => ',',
            )
        : listing.price!;
    final currency = listing.currency ?? '';
    return currency.isNotEmpty ? '$formatted $currency' : formatted;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final priceLine = _priceLine();
    final route = _route();

    return Material(
      color: colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: route != null ? () => context.push(route) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outlineVariant.withOpacity(0.4),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (listing.imageUrl != null && listing.imageUrl!.isNotEmpty)
                    ? CachedNetworkImageWidget(
                        imageUrl: listing.imageUrl,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 48,
                        height: 48,
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_outlined,
                          size: 22,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    if (priceLine.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        priceLine,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(status: listing.status),
              if (route != null) ...[
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String? status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == null || status!.isEmpty) return const SizedBox.shrink();
    final l = AppLocalizations.of(context)!;

    late final String label;
    late final Color color;
    switch (status) {
      case 'reserved':
        label = l.chatStatusReserved;
        color = const Color(0xFFF59E0B); // amber
        break;
      case 'sold':
        label = l.chatStatusSold;
        color = const Color(0xFF9CA3AF); // grey
        break;
      case 'available':
      default:
        label = l.chatStatusAvailable;
        color = const Color(0xFF22C55E); // green
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
