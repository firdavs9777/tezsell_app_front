import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductFilter extends ConsumerStatefulWidget {
  const ProductFilter({super.key});

  @override
  ConsumerState<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends ConsumerState<ProductFilter> {
  List<CategoryModel> availableCategories = [];
  List<int> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories =
          await ref.read(productsServiceProvider).getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading categories: $e')),
      );
    }
  }

  void _applyFilter() {
    // Navigate back with selected categories
    Navigator.pop(context, selectedCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Select Categories to Filter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: availableCategories.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(availableCategories[index].name),
                    value: selectedCategories
                        .contains(availableCategories[index].id),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedCategories.add(availableCategories[index].id);
                        } else {
                          selectedCategories
                              .remove(availableCategories[index].id);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _applyFilter,
                child: const Text('Apply Filter'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
