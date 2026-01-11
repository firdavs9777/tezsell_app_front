import 'package:app/constants/constants.dart';

import 'package:app/providers/provider_models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FavoriteProducts extends ConsumerStatefulWidget {
  final List<Products> products;

  const FavoriteProducts({super.key, required this.products});

  @override
  ConsumerState<FavoriteProducts> createState() => _FavoriteProductsState();
}

class _FavoriteProductsState extends ConsumerState<FavoriteProducts> {
  late List<Products> _products;

  @override
  void initState() {
    super.initState();
    _products = List.from(widget.products);
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _editProduct(int index) {
    // Navigate to the edit product screen (implement ProductEdit page)
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEdit(product: _products[index])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _products.length,
          itemBuilder: (context, index) {
            final product = _products[index];
            final formattedPrice =
                NumberFormat('#,##0', 'en_US').format(int.parse(product.price));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                key: ValueKey(product.id),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
                      spreadRadius: 4,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Text(baseUrl),
                    // // Product Image
                    // Text(product.images[0].image.toString()),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: product.images.isNotEmpty
                          ? Image.network(
                              product.images[0].image.startsWith('http://') ||
                                      product.images[0].image.startsWith('https://')
                                  ? product.images[0].image
                                  : '$baseUrl/products${product.images[0].image}',
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
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            product.description,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: 4.0),
                              Text(
                                '${product.location.region}, ${product.location.district.substring(0, 7)}...',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontSize: 12.0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    // Price and Actions
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Builder(
                          builder: (context) {
                            final isDark = Theme.of(context).brightness == Brightness.dark;
                            return Text(
                              '$formattedPrice ${product.currency}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0,
                                color: isDark ? Theme.of(context).colorScheme.primary : const Color(0xFF43A047),
                              ),
                            );
                          }
                        ),
                        const SizedBox(height: 8.0),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
