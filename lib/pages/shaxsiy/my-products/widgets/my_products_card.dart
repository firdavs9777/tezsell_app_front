import 'package:app/constants/constants.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/utils/currency_utils.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _ProductMenuAction {
  markSold,
  backToAvailable,
  hide,
  unhide,
  edit,
  delete,
}

class MyProductsCard extends StatelessWidget {
  const MyProductsCard({
    super.key,
    required this.product,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
    required this.onMarkSold,
    required this.onBackToAvailable,
    required this.onHide,
    required this.onUnhide,
  });

  final Products product;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onMarkSold;
  final VoidCallback onBackToAvailable;
  final VoidCallback onHide;
  final VoidCallback onUnhide;

  String? get _imageUrl {
    if (product.images.isEmpty) return null;
    final first = product.images.first.image;
    return first.startsWith('http') ? first : '$baseUrl$first';
  }

  String _formatPrice() {
    final priceValue = double.tryParse(product.price) ?? 0;
    if (priceValue == 0) return 'Price not set';

    final config = CurrencyUtils.getConfig(product.currency);
    final formatted = NumberFormat('#,##0', 'en_US').format(priceValue.toInt());
    return '${config?.symbol ?? ''} $formatted ${product.currency}';
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
    final imageUrl = _imageUrl;

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
                // Dim the whole row (mirrors main_products.dart's sold/
                // inactive treatment) so sold/hidden items visually recede
                // without hiding the action row below.
                opacity: (product.isSold || !product.isActive) ? 0.7 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Hero(
                            tag: 'product-${product.id}',
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
                          if (product.isSold)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: colorScheme.scrim.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.error,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      l?.sold_badge ?? 'SOLD',
                                      style: TextStyle(
                                        color: colorScheme.onError,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (product.isReserved)
                            Positioned(
                              left: 6,
                              top: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  l?.reserved_badge ?? 'RESERVED',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _formatPrice(),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (product.location.district.isNotEmpty)
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
                                      '${product.location.district}, '
                                      '${product.location.region}',
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
                                _StatusBadge(
                                  text: product.inStock
                                      ? (l?.in_stock ?? 'In Stock')
                                      : (l?.out_of_stock ?? 'Out of Stock'),
                                  color: product.inStock
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                _StatusBadge(
                                  text: product.condition.toUpperCase(),
                                  color: Colors.blue,
                                ),
                                if (product.isSold)
                                  _StatusBadge(
                                    text: l?.sold_badge ?? 'SOLD',
                                    color: Colors.orange,
                                  ),
                                if (!product.isSold && !product.isActive)
                                  _StatusBadge(
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
                        _timeAgo(product.updatedAt),
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
                    PopupMenuButton<_ProductMenuAction>(
                      icon: Icon(
                        Icons.more_vert_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      tooltip: l?.more_options ?? 'More options',
                      onSelected: (action) {
                        switch (action) {
                          case _ProductMenuAction.markSold:
                            onMarkSold();
                            break;
                          case _ProductMenuAction.backToAvailable:
                            onBackToAvailable();
                            break;
                          case _ProductMenuAction.hide:
                            onHide();
                            break;
                          case _ProductMenuAction.unhide:
                            onUnhide();
                            break;
                          case _ProductMenuAction.edit:
                            onEdit();
                            break;
                          case _ProductMenuAction.delete:
                            onDelete();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (!product.isSold)
                          PopupMenuItem(
                            value: _ProductMenuAction.markSold,
                            child: _MenuRow(
                              icon: Icons.sell_outlined,
                              label: l?.mark_as_sold ?? 'Mark as sold',
                            ),
                          ),
                        if (product.isSold || product.isReserved)
                          PopupMenuItem(
                            value: _ProductMenuAction.backToAvailable,
                            child: _MenuRow(
                              icon: Icons.replay_rounded,
                              label:
                                  l?.back_to_available ?? 'Back to available',
                            ),
                          ),
                        if (product.isActive)
                          PopupMenuItem(
                            value: _ProductMenuAction.hide,
                            child: _MenuRow(
                              icon: Icons.visibility_off_outlined,
                              label: l?.hide_listing ?? 'Hide',
                            ),
                          )
                        else
                          PopupMenuItem(
                            value: _ProductMenuAction.unhide,
                            child: _MenuRow(
                              icon: Icons.visibility_outlined,
                              label: l?.unhide_listing ?? 'Unhide',
                            ),
                          ),
                        PopupMenuItem(
                          value: _ProductMenuAction.edit,
                          child: _MenuRow(
                            icon: Icons.edit_outlined,
                            label: l?.edit ?? 'Edit',
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: _ProductMenuAction.delete,
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
        Icons.image_outlined,
        size: 32,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});

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

class MyProductsEmptyState extends StatelessWidget {
  const MyProductsEmptyState({super.key, required this.onAddProduct});

  final VoidCallback onAddProduct;

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
                Icons.inventory_2_outlined,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations?.no_products_found ?? 'No products yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              localizations?.add_first_product ??
                  'Start selling by adding your first product',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: onAddProduct,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Product'),
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
