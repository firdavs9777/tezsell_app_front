import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductSearch extends ConsumerStatefulWidget {
  const ProductSearch({super.key});

  @override
  ConsumerState<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends ConsumerState<ProductSearch> {
  final TextEditingController _searchController = TextEditingController();
  Future<List<Products>>? _searchResults;

  void _searchProducts(String _) {
    setState(() {
      _searchResults = ref
          .read(productsServiceProvider)
          .getFilteredProducts(productTitle: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "Search for products...",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.search,
          style: TextStyle(color: Colors.white),
          onSubmitted: (_) => _searchProducts(_),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _searchProducts,
          ),
        ],
      ),
      body: _searchResults == null
          ? const Center(child: Text("Enter a search term to find products"))
          : FutureBuilder<List<Products>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No products found"));
                }
                final filteredProducts = snapshot.data!;
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductMain(product: product);
                  },
                );
              },
            ),
    );
  }
}
