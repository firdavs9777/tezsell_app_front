import 'package:app/pages/service/main/filtered_services.dart';
import 'package:app/providers/provider_models/category_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceFilter extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;
  const ServiceFilter({
    super.key,
    required this.regionName,
    required this.districtName,
  });

  @override
  ConsumerState<ServiceFilter> createState() => _ServiceFilterState();
}

class _ServiceFilterState extends ConsumerState<ServiceFilter> {
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
    'handyman': Icons.handyman,
    'cleaning_services': Icons.cleaning_services,
    'plumbing': Icons.plumbing,
    'electric_bolt': Icons.electric_bolt,
  };

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await ref.read(serviceMainProvider).getCategories();
      setState(() {
        availableCategories = categories;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading categories: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
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

  void _applyFilter(String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => FilteredServices(
          categoryName: categoryName,
          regionName: widget.regionName,
          districtName: widget.districtName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.categoryHeader ?? 'Categories',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black87,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: Colors.grey.shade200),
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
                    onTap: () => _applyFilter(category.nameEn),
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
                              iconData ?? Icons.handyman_rounded,
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
