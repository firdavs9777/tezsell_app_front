import 'package:app/pages/products/filtered_products.dart';
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
  final String selectedCategory = '';
  Map<String, IconData> iconMap = {
    'phone_android': Icons.phone_android,
    'weekend': Icons.weekend,
    'directions_walk': Icons.directions_walk,
    'child_care': Icons.child_care,
    'toys': Icons.toys,
    'directions_car': Icons.directions_car,
    'kitchen': Icons.kitchen,
    'home': Icons.home,
    'apartment': Icons.apartment,
    'fastfood': Icons.fastfood,
    'checkroom': Icons.checkroom,
    'shopping_bag': Icons.shopping_bag,
    'spa': Icons.spa,
    'local_florist': Icons.local_florist,
    'medical_services': Icons.medical_services,
    'health_and_safety': Icons.health_and_safety,
    'build': Icons.build,
    'sports_baseball': Icons.sports_baseball,
    'restaurant': Icons.restaurant,
    'music_note': Icons.music_note,
    'book': Icons.book,
    'pets': Icons.pets,
    'more_horiz': Icons.more_horiz,
    'car_repair': Icons.car_repair,
    'laptop_mac': Icons.laptop_mac,
    'bed': Icons.bed,
    'school': Icons.school,
    'motorcycle': Icons.motorcycle,
    'desktop_windows': Icons.desktop_windows,
    'tablet': Icons.tablet,
    'tv': Icons.tv,
  };

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

  void _applyFilter(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => FilteredProducts(categoryName: categoryName),
      ),
    );
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
              'Select Category to filter',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of items per row
                  crossAxisSpacing: 15, // Horizontal space between items
                  mainAxisSpacing: 10, // Vertical space between items
                ),
                itemCount: availableCategories.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  IconData? iconData = iconMap[availableCategories[index].icon];

                  return GestureDetector(
                    onTap: () {
                      // Handle item tap if necessary
                    },
                    child: GestureDetector(
                      onTap: () =>
                          _applyFilter(availableCategories[index].name),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            iconData ?? Icons.help_outline,
                            color: Theme.of(context)
                                .primaryColor, // Default to a fallback icon
                            size: 30, // Adjust the icon size as needed
                          ),
                          SizedBox(height: 5), // Space between icon and text
                          Text(
                            availableCategories[index].name,
                            textAlign: TextAlign.center, // Center the text
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
