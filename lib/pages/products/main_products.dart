import 'package:app/constants/constants.dart';
import 'package:app/pages/products/product_detail.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ProductMain extends ConsumerStatefulWidget {
  final Products product;
  const ProductMain({super.key, required this.product});

  @override
  ConsumerState<ProductMain> createState() => _ProductMainState();
}

class _ProductMainState extends ConsumerState<ProductMain> {
  @override
  Widget build(BuildContext context) {
    final formattedPrice =
        NumberFormat('#,##0', 'en_US').format(int.parse(widget.product.price));

    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetail page
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetail(product: widget.product)),
        ).then((_) => ref.refresh(productsProvider));
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
              child: widget.product.images.isNotEmpty
                  ? Image.network(
                      '${baseUrl}${widget.product.images[0].image}',
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
                    widget.product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4.0),
                  // Description and Location
                  Text(
                    widget.product.description,
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
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        '${('${widget.product.location.region}, ${widget.product.location.district}').substring(0, ('${widget.product.location.region}, ${widget.product.location.district}').length > 10 ? 10 : '${widget.product.location.region}, ${widget.product.location.district}'.length)}',
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
                  '$formattedPrice ${widget.product.currency}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    FutureBuilder(
                        future: ref
                            .watch(profileServiceProvider)
                            .getUserFavoriteItems(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading favorite items'));
                          }
                          if (snapshot.hasData) {
                            final likedItems = snapshot.data!;
                            bool isLiked = likedItems.likedProducts
                                .any((item) => item.id == widget.product.id);
                            return Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                              size: 22.0,
                            );
                          }
                          return const Center(
                              child: Text('No favorite items found.'));
                        }),
                    const SizedBox(width: 4.0),
                    Text(
                      '${widget.product.likeCount}',
                      style: const TextStyle(fontSize: 12.0),
                    ),
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
