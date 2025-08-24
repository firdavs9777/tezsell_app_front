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

  static final _priceFormatter = NumberFormat('#,##0', 'ko_KR');

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
        padding: const EdgeInsets.all(12.0),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image - Left side like Carrot
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: SizedBox(
                width: 100,
                height: 100,
                child: product.images.isNotEmpty
                    ? Image.network(
                        '${baseUrl}${product.images[0].image}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/logo/logo_no_background.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/logo/logo_no_background.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top section: Title and Location
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title - Top priority like Carrot
                        Text(
                          product.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4.0),

                        // Location - Second line like Carrot
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 2.0),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price - Bottom left like Carrot
                        Expanded(
                          child: Text(
                            formattedPrice,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.favorite_border,
                              color: Colors.grey,
                              size: 18.0,
                            ),
                            const SizedBox(width: 4.0),
                            Text(
                              '${product.likeCount}',
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
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
    );
  }

  String _getFormattedPrice() {
    try {
      final priceValue = int.tryParse(product.price) ?? 0;
      final formattedPrice = _priceFormatter.format(priceValue);
      return '$formattedPrice${product.currency}';
    } catch (e) {
      return '${product.price}${product.currency}';
    }
  }

  String _getLocationText() {
    final region = product.location.region ?? '';
    final district = product.location.district ?? '';
    final fullLocation = '$region $district';
    final maxLength = 20;
    if (fullLocation.length <= maxLength) {
      return fullLocation;
    }

    return '${fullLocation.substring(0, maxLength)}...';
  }
}
