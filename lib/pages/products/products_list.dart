import 'package:app/pages/products/main_products.dart';
import 'package:app/pages/products/product_new.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsList extends ConsumerWidget {
  const ProductsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> refresh() async {
      ref.refresh(productsProvider);
    }

    final productsList = ref.watch(productsProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refresh,
        child: productsList.when(
          data: (item) {
            if (item.isEmpty) {
              return const Center(child: Text('No products available.'));
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
          error: (error, stack) => Center(child: Text('Error: $error $stack')),
        ),
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
          label: const Text(
            'Yuklash',
            style: TextStyle(fontSize: 18, color: Colors.black), // Black text
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
