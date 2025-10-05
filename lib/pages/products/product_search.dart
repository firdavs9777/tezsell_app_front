import 'package:app/pages/products/main_products.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/theme_provider.dart';
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
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText:
                    AppLocalizations.of(context)?.searchProductPlaceholder ??
                        "Search for products..."),
            textInputAction: TextInputAction.search,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            onSubmitted: (_) => _searchProducts(_),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => _searchProducts,
          ),
        ],
      ),
      body: _searchResults == null
          ? Center(
              child: Text(
                  AppLocalizations.of(context)?.product_search_placeholder ??
                      "Enter a search term to find products"))
          : FutureBuilder<List<Products>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context)?.productError ??
                          "No products found"));
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
