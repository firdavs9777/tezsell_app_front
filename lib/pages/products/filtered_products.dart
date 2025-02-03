import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_category.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredProducts extends ConsumerStatefulWidget {
  final String categoryName;
  const FilteredProducts({super.key, required this.categoryName});

  @override
  ConsumerState<FilteredProducts> createState() => _FilteredProductsState();
}

class _FilteredProductsState extends ConsumerState<FilteredProducts> {
  Future<List<Products>> getFilteredProducts() async {
    // Assuming you have a method to fetch filtered products based on category
    return ref
        .read(productsServiceProvider)
        .getFilteredProducts(categoryName: widget.categoryName);
  }

  Future<void> refresh() async {
    // To trigger the refresh logic when pulled down
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close), // X icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => const TabsScreen()),
            ); // Close the screen or navigate back
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search), // Search icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ProductSearch(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.category), // Category icon
            onPressed: () {
              // Implement category selection functionality
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ProductFilter(),
                ),
              );
            },
          ),
        ],
        title: Text("Filtered Products"), // Title for the AppBar
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: FutureBuilder<List<Products>>(
                future: getFilteredProducts(), // Trigger the future here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.hasData) {
                    final productsList = snapshot.data!;
                    if (productsList.isEmpty) {
                      return const Center(
                          child: Text('No products available.'));
                    }

                    return ListView.builder(
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        final product = productsList[index];
                        return ProductMain(product: product);
                      },
                    );
                  }

                  return const Center(child: Text('No products available.'));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
