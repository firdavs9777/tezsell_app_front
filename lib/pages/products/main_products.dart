import 'package:app/constants/constants.dart';
import 'package:app/pages/products/product_detail.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductMain extends ConsumerWidget {
  final Products product;
  const ProductMain({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedPrice =
        NumberFormat('#,##0', 'en_US').format(int.parse(product.price));

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetail page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(product: product)),
        );
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
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: product.images.isNotEmpty
                  ? Image.network(
                      '${baseUrl}/products${product.images[0].image}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/logo/logo_no_background.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12.0),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Category
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4.0),
                  // Description and Location
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
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.0,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${product.location.region}, ${product.location.district}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            // Price and Likes
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$formattedPrice ${product.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Icon(
                      Icons.thumb_up,
                      color: product.likeCount > 0 ? Colors.red : Colors.grey,
                      size: 16.0,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '${product.likeCount}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                    const SizedBox(width: 12.0),
                    // Icon(
                    //   Icons.comment,
                    //   color: Colors.grey,
                    //   size: 16.0,
                    // ),
                    // const SizedBox(width: 4.0),
                    // Text(
                    //   '${product.commentCount}',
                    //   style: const TextStyle(fontSize: 12.0),
                    // ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
