import 'package:app/pages/products/filtered_products.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    'settings': Icons.settings,
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
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${localizations?.loadingCategoryError ?? "Error loading categories:"} $e'),
        ),
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

  // Function to get the appropriate category name based on current locale
  String getCategoryName(CategoryModel category) {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return category.nameUz;
      case 'ru':
        return category.nameRu;
      case 'en':
      default:
        return category.nameEn;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
        title: Text(localizations?.categoryHeader ?? 'Filter Products',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              localizations?.categoryPlaceholder ?? 'Select Category to filter',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: availableCategories.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio:
                            0.85, // Slightly taller to accommodate text
                      ),
                      itemCount: availableCategories.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final category = availableCategories[index];
                        IconData? iconData = iconMap[category.icon];

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _applyFilter(category.nameUz),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.shade200,
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade100,
                                    blurRadius: 2,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Icon section - fixed height
                                  SizedBox(
                                    height: 40,
                                    child: Icon(
                                      iconData ?? Icons.help_outline,
                                      color: Theme.of(context).primaryColor,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Text section - flexible but constrained
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        getCategoryName(category),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          height: 1.2,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
