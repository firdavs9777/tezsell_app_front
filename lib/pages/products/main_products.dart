import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/config/app_router.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/utils/currency_utils.dart';
import 'package:app/utils/image_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductMain extends ConsumerWidget {
  final Products product;

  const ProductMain({super.key, required this.product});

  static final _priceFormatter = NumberFormat('#,##0', 'ko_KR');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Use the model's formatted price (now uses proper UZS spacing)
    final formattedPrice = product.formattedPrice;

    return Opacity(
      // Dim the card if product is sold or inactive
      opacity: (product.isSold || !product.isActive) ? 0.7 : 1.0,
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
            onTap: () {
              // Navigate to ProductDetail page using router from provider
              final router = ref.read(routerProvider);
              router.push('/product/${product.id}').then((_) => ref.invalidate(productsProvider));
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image - Left side with sold badge overlay
                  Stack(
                    children: [
                      Hero(
                        tag: 'product_image_${product.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: SizedBox(
                            width: 110,
                            height: 110,
                            child: CachedNetworkImageWidget(
                              imageUrl: product.images.isNotEmpty
                                  ? ImageUtils.buildImageUrl(product.images[0].image)
                                  : null,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                      ),
                      // Sold badge overlay
                      if (product.isSold)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: colorScheme.scrim.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SOTILGAN',
                                  style: TextStyle(
                                    color: colorScheme.onError,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: SizedBox(
                    height: 110,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top section: Title and Location
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                product.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  color: colorScheme.onSurface,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6.0),

                              // Location
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
                                        color: colorScheme.onSurface.withOpacity(0.6),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Bottom section: Price and Likes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Price
                            Flexible(
                              child: Text(
                                formattedPrice,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17.0,
                                  color: colorScheme.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Likes
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0,
                                vertical: 3.0,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceVariant.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite_rounded,
                                    color: colorScheme.error,
                                    size: 14.0,
                                  ),
                                  const SizedBox(width: 3.0),
                                  Text(
                                    '${product.likeCount}',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                    ),
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
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  String _getFormattedPrice() {
    // Now using CurrencyUtils for proper formatting
    return CurrencyUtils.formatPrice(product.price, currency: product.currency);
  }

  String _getLocationText() {
    // Use the new shortAddress getter from Location model
    final shortAddr = product.location.shortAddress;
    if (shortAddr.isEmpty) {
      return product.location.region;
    }
    const maxLength = 25;
    if (shortAddr.length <= maxLength) {
      return shortAddr;
    }
    return '${shortAddr.substring(0, maxLength)}...';
  }
}
