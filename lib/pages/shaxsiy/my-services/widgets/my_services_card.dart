import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/utils/image_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _ServiceMenuAction { hide, unhide, edit, delete }

class MyServicesCard extends StatelessWidget {
  const MyServicesCard({
    super.key,
    required this.service,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onHide,
    required this.onUnhide,
  });

  final Services service;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onHide;
  final VoidCallback onUnhide;

  String _categoryName(BuildContext context, CategoryModel category) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'uz':
        return category.nameUz;
      case 'ru':
        return category.nameRu;
      case 'en':
      default:
        return category.nameEn;
    }
  }

  String _timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 30) return DateFormat('MMM d, y').format(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final imageUrl = service.images.isNotEmpty
        ? ImageUtils.buildImageUrl(service.images.first.image)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black12,
        child: InkWell(
          onTap: onView,
          child: Column(
            children: [
              Opacity(
                // Dim the whole row when hidden, mirroring the products
                // card's sold/inactive treatment.
                opacity: service.isActive ? 1.0 : 0.7,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: 'service-${service.id}',
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colorScheme.surfaceContainerHighest,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: imageUrl != null
                              ? CachedNetworkImageWidget(
                                  imageUrl: imageUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  errorWidget: _Placeholder(
                                    colorScheme: colorScheme,
                                  ),
                                )
                              : _Placeholder(colorScheme: colorScheme),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              service.description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            if (service.location.district.isNotEmpty)
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${service.location.district}, '
                                      '${service.location.region}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _CategoryBadge(
                                  text: _categoryName(
                                    context,
                                    service.category,
                                  ),
                                  color: colorScheme.primary,
                                ),
                                if (!service.isActive)
                                  _CategoryBadge(
                                    text: l?.hidden_badge ?? 'HIDDEN',
                                    color: Colors.grey,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _timeAgo(service.createdAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: onView,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: Text(l?.view ?? 'View'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                    PopupMenuButton<_ServiceMenuAction>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      tooltip: l?.more_options ?? 'More options',
                      onSelected: (action) {
                        switch (action) {
                          case _ServiceMenuAction.hide:
                            onHide();
                            break;
                          case _ServiceMenuAction.unhide:
                            onUnhide();
                            break;
                          case _ServiceMenuAction.edit:
                            onEdit();
                            break;
                          case _ServiceMenuAction.delete:
                            onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (service.isActive)
                          PopupMenuItem(
                            value: _ServiceMenuAction.hide,
                            child: _MenuRow(
                              icon: Icons.visibility_off_outlined,
                              label: l?.hide_listing ?? 'Hide',
                            ),
                          )
                        else
                          PopupMenuItem(
                            value: _ServiceMenuAction.unhide,
                            child: _MenuRow(
                              icon: Icons.visibility_outlined,
                              label: l?.unhide_listing ?? 'Unhide',
                            ),
                          ),
                        PopupMenuItem(
                          value: _ServiceMenuAction.edit,
                          child: _MenuRow(
                            icon: Icons.edit_outlined,
                            label: l?.edit ?? 'Edit',
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: _ServiceMenuAction.delete,
                          child: _MenuRow(
                            icon: Icons.delete_outline_rounded,
                            label: l?.delete ?? 'Delete',
                            color: colorScheme.error,
                          ),
                        ),
                      ],
                    ),
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

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        Icons.miscellaneous_services_outlined,
        size: 32,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

/// Icon + label row used inside [PopupMenuItem]s for the per-listing
/// overflow menu. [color] tints both the icon and label (e.g. for the
/// destructive "Delete" entry); defaults to the theme's body text color.
class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.icon, required this.label, this.color});

  final IconData icon;
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: color.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

class MyServicesEmptyState extends StatelessWidget {
  const MyServicesEmptyState({super.key, required this.onAddService});

  final VoidCallback onAddService;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.miscellaneous_services_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations?.no_services_found ?? 'No services yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations?.add_first_service ??
                  'Start by adding your first service',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onAddService,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Service'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
