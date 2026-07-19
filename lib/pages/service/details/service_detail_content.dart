import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/utils/category_locale_utils.dart';
import 'package:app/widgets/maps/map_view.dart';
import 'package:app/widgets/service_rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/constants/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class ServiceDetailsSection extends StatefulWidget {
  const ServiceDetailsSection({
    super.key,
    required this.service,
    this.onChatPressed,
  });

  final Services service;
  final VoidCallback? onChatPressed;

  @override
  State<ServiceDetailsSection> createState() => _ServiceDetailsSectionState();
}

class _ServiceDetailsSectionState extends State<ServiceDetailsSection> {
  String _maskedLocation(String region, String district) {
    // Show only first part safely, e.g. "Seoul, ****"
    return '$region, ****';
  }


  String getCategoryName() =>
      CategoryLocaleUtils.localizedName(context, widget.service.category);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.category_rounded,
                  size: 16,
                  color: colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 6),
                Text(
                  getCategoryName().isNotEmpty
                      ? getCategoryName()
                      : (localizations?.newProductCategory ?? 'No Category'),
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Service Title
          Text(
            widget.service.name,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
          if (widget.service.ratingCount > 0) ...[
            const SizedBox(height: 8),
            ServiceRatingBadge(
              ratingAvg: widget.service.ratingAvg,
              ratingCount: widget.service.ratingCount,
              compact: false,
            ),
          ],
          const SizedBox(height: 20),

          // Service Description
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.description_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizations?.newProductDescription ?? 'Description',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.service.description,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.6,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Service Provider Card - tappable to navigate to profile
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tappable profile section
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    onTap: widget.service.userName.id > 0
                        ? () => context.push('/user/${widget.service.userName.id}')
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                localizations?.service_provider ?? 'Service Provider',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                                  letterSpacing: 0.1,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                                size: 20,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              // Avatar with border and hero animation
                              Hero(
                                tag: 'profile_image_${widget.service.userName.id}',
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(alpha: 0.2),
                                      width: 2,
                                    ),
                                  ),
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                            child: Image.network(
                                              widget.service.userName.profileImage.image.startsWith('http://') ||
                                                      widget.service.userName.profileImage.image.startsWith('https://')
                                                  ? widget.service.userName.profileImage.image
                                                  : '$baseUrl${widget.service.userName.profileImage.image}',
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Icon(
                                                Icons.person_rounded,
                                                color: colorScheme.primary,
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Provider Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Username
                                    Text(
                                      widget.service.userName.username ?? (localizations?.service_provider ?? 'Service Provider'),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.onSurface,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Location with icon
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          size: 16,
                                          color: colorScheme.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            _maskedLocation(
                                              widget.service.userName.location.region,
                                              widget.service.userName.location.district,
                                            ),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: colorScheme.onSurface.withValues(alpha: 0.7),
                                              fontWeight: FontWeight.w400,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.service.latitude != null &&
                    widget.service.longitude != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: MapView(
                        center: LatLng(
                          widget.service.latitude!,
                          widget.service.longitude!,
                        ),
                        mode: widget.service.showExactPin
                            ? MapViewMode.exact
                            : MapViewMode.approximate,
                      ),
                    ),
                  ),
                // Chat Button Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: widget.onChatPressed ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations?.opening_chat ?? 'Opening chat...'),
                                backgroundColor: colorScheme.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(16),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                      icon: const Icon(Icons.chat_bubble_outline_rounded, size: 20),
                      label: Text(localizations?.chat ?? 'Chat'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
