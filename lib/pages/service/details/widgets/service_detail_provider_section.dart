import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceDetailProviderSection extends StatelessWidget {
  const ServiceDetailProviderSection({super.key, required this.service});

  final Services service;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final provider = service.userName;
    final providerId = provider.id;

    return InkWell(
      onTap:
          providerId > 0 ? () => context.push('/user/$providerId') : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImageWidget(
                        imageUrl: ImageUtils.buildImageUrl(
                            provider.profileImage.image),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.username ??
                        (localizations?.service_provider ?? 'Provider'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.location.region ??
                        (localizations?.searchLocation ?? 'Location'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
