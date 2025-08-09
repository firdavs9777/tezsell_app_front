import 'package:app/constants/constants.dart';
import 'package:app/pages/products/product_detail.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductMain extends ConsumerWidget {
  final Products product;

  const ProductMain({super.key, required this.product});

  // Cache the number formatter to avoid recreating it
  static final _priceFormatter = NumberFormat('#,##0', 'en_US');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cache the formatted price to avoid recalculating
    final formattedPrice = _getFormattedPrice();

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetail page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(product: product)),
        ).then((_) => ref.invalidate(productsProvider));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 4,
              blurRadius: 4,
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Product Image - Fast loading
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: product.images.isNotEmpty
                      ? Image.network(
                          '${baseUrl}${product.images[0].image}',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/logo/logo_no_background.png',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/logo/logo_no_background.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12.0),

              // Product Details - Flexible to prevent overflow
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title - Prevent overflow
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4.0),

                    // Description - Prevent overflow
                    Text(
                      product.description,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6.0),

                    // Location row with proper overflow handling
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 4.0),
                        Expanded(
                          child: Text(
                            _getLocationText(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
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

              const SizedBox(width: 8.0),

              // Price and Likes - Fixed width to prevent overflow
              SizedBox(
                width: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price - Prevent overflow
                    Text(
                      formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8.0),

                    // Super fast likes - no API calls!
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.favorite_border, // Static heart for speed
                          color: Colors.grey,
                          size: 22.0,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          '${product.likeCount}',
                          style: const TextStyle(fontSize: 12.0),
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

  String _getFormattedPrice() {
    try {
      final priceValue = int.tryParse(product.price) ?? 0;
      final formattedPrice = _priceFormatter.format(priceValue);
      return '$formattedPrice ${product.currency}';
    } catch (e) {
      return '${product.price} ${product.currency}';
    }
  }

  String _getLocationText() {
    final region = product.location.region ?? '';
    final district = product.location.district ?? '';
    final fullLocation = '$region, $district';

    // Smart truncation - keep your original logic but make it safer
    final maxLength = 15;
    if (fullLocation.length <= maxLength) {
      return fullLocation;
    }

    return '${fullLocation.substring(0, maxLength)}...';
  }
}
