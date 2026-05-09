import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UserProfileProductsGrid extends ConsumerWidget {
  const UserProfileProductsGrid({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(userProductsProvider(profile.id));
    final colorScheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => UserProfileEmptyState(
        icon: Icons.error_outline,
        title: l?.profile_error_occurred ?? 'Error occurred',
        subtitle:
            l?.profile_error_loading_products ?? 'Error loading products',
      ),
      data: (products) {
        if (products.isEmpty) {
          return UserProfileEmptyState(
            icon: Icons.inventory_2_outlined,
            title: l?.profile_no_products ?? 'No products',
            subtitle: l?.profile_user_no_products ??
                "This user hasn't posted any products yet",
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: product.images.isNotEmpty
                    ? CachedNetworkImageWidget(
                        imageUrl: product.images[0].image,
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class UserProfileServicesGrid extends ConsumerWidget {
  const UserProfileServicesGrid({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(userServicesProvider(profile.id));
    final colorScheme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context);

    return servicesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => UserProfileEmptyState(
        icon: Icons.error_outline,
        title: l?.profile_error_occurred ?? 'Error occurred',
        subtitle:
            l?.profile_error_loading_services ?? 'Error loading services',
      ),
      data: (services) {
        if (services.isEmpty) {
          return UserProfileEmptyState(
            icon: Icons.handyman_outlined,
            title: l?.profile_no_services ?? 'No services',
            subtitle: l?.profile_user_no_services ??
                "This user hasn't posted any services yet",
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () => context.push('/service/${service.id}'),
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: service.images.isNotEmpty
                    ? CachedNetworkImageWidget(
                        imageUrl: service.images[0].image,
                        fit: BoxFit.cover,
                        errorWidget: Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Icon(
                        Icons.handyman_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}

class UserProfilePropertiesGrid extends StatelessWidget {
  const UserProfilePropertiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return UserProfileEmptyState(
      icon: Icons.home_work_outlined,
      title: l?.profile_no_properties ?? 'No properties',
      subtitle: l?.profile_user_no_properties ??
          "This user hasn't posted any properties yet",
    );
  }
}

class UserProfileEmptyState extends StatelessWidget {
  const UserProfileEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
