import 'package:app/constants/constants.dart';
import 'package:app/pages/service/details/service_detail.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceList extends ConsumerWidget {
  final Services service;
  final VoidCallback refresh;

  const ServiceList({super.key, required this.service, required this.refresh});

  String _getLocationText() {
    final region = service.location.region ?? '';
    final district = service.location.district ?? '';
    final fullLocation = '$region, $district';
    final maxLength = 25;
    if (fullLocation.length <= maxLength) {
      return fullLocation;
    }
    return '${fullLocation.substring(0, maxLength)}...';
  }

  String getCategoryName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return service.category.nameUz;
      case 'ru':
        return service.category.nameRu;
      case 'en':
      default:
        return service.category.nameEn;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () async {
        final Services singleService = await ref
            .watch(serviceMainProvider)
            .getSingleService(serviceId: service.id.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceDetail(service: singleService),
          ),
        ).then((_) => ref.refresh(servicesProvider));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            onTap: () async {
              final Services singleService = await ref
                  .watch(serviceMainProvider)
                  .getSingleService(serviceId: service.id.toString());
              context.push('/service/${service.id}').then((_) => ref.refresh(servicesProvider));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  Hero(
                    tag: 'service_image_${service.id}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: CachedNetworkImageWidget(
                          imageUrl: service.images.isNotEmpty
                              ? service.images[0].image
                              : null,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14.0),
                  Expanded(
                    child: SizedBox(
                      height: 110,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top section: Name and Category
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6.0),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    getCategoryName(context),
                                    style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.primary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Bottom section: Location and Stats
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_rounded,
                                    size: 13,
                                    color: colorScheme.primary,
                                  ),
                                  const SizedBox(width: 3.0),
                                  Expanded(
                                    child: Text(
                                      _getLocationText(),
                                      style: TextStyle(
                                        color:
                                            colorScheme.onSurface.withOpacity(0.6),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 3.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.comment_rounded,
                                          color: colorScheme.onSurface
                                              .withOpacity(0.7),
                                          size: 12.0,
                                        ),
                                        const SizedBox(width: 3.0),
                                        Text(
                                          '${service.comments.length}',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 3.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.surfaceVariant
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.favorite_rounded,
                                          color: colorScheme.error,
                                          size: 12.0,
                                        ),
                                        const SizedBox(width: 3.0),
                                        Text(
                                          '${service.likeCount}',
                                          style: TextStyle(
                                            fontSize: 11.0,
                                            fontWeight: FontWeight.w500,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
