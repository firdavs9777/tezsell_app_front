import 'package:app/pages/products/filtered_products.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ProductFilter extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;
  const ProductFilter({
    super.key,
    required this.regionName,
    required this.districtName,
  });

  @override
  ConsumerState<ProductFilter> createState() => _ProductFilterState();
}

class _ProductFilterState extends ConsumerState<ProductFilter> {
  List<CategoryModel> availableCategories = [];
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${localizations?.loadingCategoryError ?? "Error loading categories:"} $e',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _applyFilter(String categoryName) {
    final encodedCategory = Uri.encodeComponent(categoryName);
    final encodedRegion = Uri.encodeComponent(widget.regionName);
    final encodedDistrict = Uri.encodeComponent(widget.districtName);
    context.push('/products?category=$encodedCategory&region=$encodedRegion&district=$encodedDistrict');
  }

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.categoryHeader ?? 'Categories',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: colorScheme.outlineVariant),
        ),
      ),
      body: availableCategories.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: availableCategories.length,
              itemBuilder: (context, index) {
                final category = availableCategories[index];
                IconData? iconData = iconMap[category.icon];

                final theme = Theme.of(context);
                final colorScheme = theme.colorScheme;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _applyFilter(category.nameUz),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Icon with circular background
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              iconData ?? Icons.category_rounded,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Category name
                          Expanded(
                            child: Text(
                              getCategoryName(category),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),

                          // Arrow icon
                          Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurface.withOpacity(0.4),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
