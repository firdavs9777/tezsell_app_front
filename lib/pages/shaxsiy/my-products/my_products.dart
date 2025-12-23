import 'package:app/pages/shaxsiy/my-products/product_edit.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:app/l10n/app_localizations.dart';

class MyProducts extends ConsumerStatefulWidget {
  const MyProducts({super.key});

  @override
  ConsumerState<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends ConsumerState<MyProducts> {
  List<Products> _products = [];
  bool _isLoading = true;
  bool _hasChanges = false; // Track if any changes were made

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final products = await ref.read(profileServiceProvider).getUserProducts();

      if (mounted) {
        setState(() {
          _products = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading products: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _refreshProducts() async {
    await _loadProducts();
  }

  void _deleteProduct(int productId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final localizations = AppLocalizations.of(dialogContext);

        return AlertDialog(
          title: Text(localizations?.delete_product ?? 'Delete Product'),
          content: Text(localizations?.delete_confirmation ??
              'Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              child: Text(localizations?.cancel ?? 'Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text(localizations?.delete ?? 'Delete'),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // Close dialog first

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    // Auto close after 3 seconds
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.of(context).pop(true);
                    });

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                try {
                  // Call the delete API
                  final success = await ref
                      .read(productsServiceProvider)
                      .deleteProduct(productId: productId);
                  _refreshProducts();
                  // Close loading dialog
                  if (mounted) Navigator.of(context).pop();

                  if (success) {
                    _refreshProducts();
                    setState(() {
                      _hasChanges = true;
                    });

                    // Show success message
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product deleted successfully'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                } catch (e) {
                  // Close loading dialog
                  if (mounted) Navigator.of(context).pop();

                  // Show error message
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error deleting product: $e'),
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _editProduct(int productId) {
    // Find the product by ID
    final product = _products.firstWhere((p) => p.id == productId);

    // Navigate to the edit product screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEdit(product: product),
      ),
    ).then((updatedProduct) {
      // If the edit was successful and we got an updated product back
      if (updatedProduct != null && updatedProduct is Products) {
        setState(() {
          // Find and update the product in the local list
          final index = _products.indexWhere((p) => p.id == updatedProduct.id);
          if (index != -1) {
            _products[index] = updatedProduct;
            _hasChanges = true; // Mark that changes were made
          }
        });

        // Also invalidate the provider for future use
        ref.invalidate(profileServiceProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return WillPopScope(
      onWillPop: () async {
        // When user navigates back, return whether changes were made
        Navigator.pop(context, _hasChanges);
        return false; // Prevent default back navigation since we handled it
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations?.my_products ?? 'My Products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _refreshProducts,
              tooltip: localizations?.refresh ?? 'Refresh',
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations?.no_products_found ??
                              'No products found',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations?.add_first_product ??
                              'Start by adding your first product',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _refreshProducts,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          final formattedPrice = NumberFormat('#,##0', 'en_US')
                              .format(int.tryParse(
                                      product.price?.toString() ?? '0') ??
                                  0);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              key: ValueKey(product.id),
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
                                    child: product.images != null &&
                                            product.images!.isNotEmpty
                                        ? Image.network(
                                            product.images![0].image ?? '',
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
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
                                  const SizedBox(width: 12.0),
                                  // Product Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title ??
                                              (localizations?.no_title ??
                                                  'No title'),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          product.description ??
                                              (localizations?.no_description ??
                                                  'No description'),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12.0,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6.0),
                                        if (product.location != null) ...[
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on,
                                                size: 14.0,
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(width: 4.0),
                                              Expanded(
                                                child: Text(
                                                  '${product.location!.region ?? ''}, ${(product.location!.district ?? '').length > 7 ? '${product.location!.district!.substring(0, 7)}...' : product.location!.district ?? ''}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12.0,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                        const SizedBox(height: 4.0),
                                        // Status indicators
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6.0,
                                                vertical: 2.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: product.inStock == true
                                                    ? Colors.green.shade100
                                                    : Colors.red.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Text(
                                                product.inStock == true
                                                    ? (localizations
                                                            ?.in_stock ??
                                                        'In Stock')
                                                    : (localizations
                                                            ?.out_of_stock ??
                                                        'Out of Stock'),
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: product.inStock == true
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6.0),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 6.0,
                                                vertical: 2.0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              child: Text(
                                                product.condition
                                                        ?.toUpperCase() ??
                                                    (localizations
                                                            ?.new_condition ??
                                                        'NEW'),
                                                style: TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
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
                                      Text(
                                        '$formattedPrice ${product.currency ?? (localizations?.sum_currency ?? "So'm")}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0,
                                          color: Colors.green,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue, size: 20),
                                            onPressed: () =>
                                                _editProduct(product.id!),
                                            tooltip:
                                                localizations?.edit_product ??
                                                    'Edit Product',
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red, size: 20),
                                            onPressed: () =>
                                                _deleteProduct(product.id!),
                                            tooltip: localizations
                                                    ?.delete_product_tooltip ??
                                                'Delete Product',
                                            padding: const EdgeInsets.all(4),
                                            constraints: const BoxConstraints(
                                              minWidth: 32,
                                              minHeight: 32,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
      ),
    );
  }
}
