import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_category.dart';
import 'package:app/pages/products/product_new.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductsList extends ConsumerStatefulWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  ConsumerState<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends ConsumerState<ProductsList> {
  Future<void> refresh() async {
    ref.refresh(productsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final productsList = ref.watch(productsProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, bottom: 10.0, top: 8.0, right: 10.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                GestureDetector(
                    onTap: () {
                      // Navigate to category filter screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => const ProductFilter(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.filter_list_sharp,
                        size: 30,
                        color: Colors.black,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: productsList.when(
                data: (item) {
                  if (item.isEmpty) {
                    return Center(
                        child: Text(
                            AppLocalizations.of(context)?.productError ??
                                'No products available.'));
                  }
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (context, index) {
                      final product = item[index];

                      return ProductMain(product: product);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    Center(child: Text('Error: $error $stack')),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to product creation or perform desired action
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => const ProductNew(),
            ));
          },
          backgroundColor: const Color(0xFFFFA500),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 24,
          ), // Black icon
          label: Text(
            AppLocalizations.of(context)?.upload ?? 'Yuklash',
            style: TextStyle(fontSize: 18, color: Colors.black), // Black text
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
