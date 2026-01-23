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
  List<CategoryModel> filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

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
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCategories);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredCategories = List.from(availableCategories);
      } else {
        filteredCategories = availableCategories.where((category) {
          final name = getCategoryName(category).toLowerCase();
          final nameUz = category.nameUz.toLowerCase();
          final nameRu = category.nameRu.toLowerCase();
          final nameEn = category.nameEn.toLowerCase();
          return name.contains(query) ||
              nameUz.contains(query) ||
              nameRu.contains(query) ||
              nameEn.contains(query);
        }).toList();
      }
    });
  }

  Future<void> _fetchCategories() async {
    setState(() => _isLoading = true);
    try {
      final categories =
          await ref.read(productsServiceProvider).getCategories();
      setState(() {
        availableCategories = categories;
        filteredCategories = List.from(categories);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
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
    final theme = Theme.of(context);

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
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations?.searchCategory ?? 'Search categories...',
                hintStyle: TextStyle(
                  color: colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: colorScheme.onSurface.withOpacity(0.5),
                          size: 20,
                        ),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                filled: true,
                fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.outline.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: colorScheme.primary,
                    width: 1.5,
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Categories List
          Expanded(
            child: _isLoading
                ? _buildSkeletonLoader(colorScheme)
                : filteredCategories.isEmpty
                    ? _buildEmptyState(colorScheme, localizations)
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 8),
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          IconData? iconData = iconMap[category.icon];

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

                                    // Category name with highlighted search text
                                    Expanded(
                                      child: _buildHighlightedText(
                                        getCategoryName(category),
                                        _searchController.text,
                                        colorScheme,
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
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, ColorScheme colorScheme) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase().trim();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
      );
    }

    final endIndex = startIndex + lowerQuery.length;
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurface,
        ),
        children: [
          TextSpan(text: text.substring(0, startIndex)),
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: TextStyle(
              backgroundColor: colorScheme.primary.withOpacity(0.2),
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: text.substring(endIndex)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme, AppLocalizations? localizations) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No matching categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader(ColorScheme colorScheme) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 8),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Skeleton circle for icon
              _SkeletonBox(
                width: 48,
                height: 48,
                borderRadius: 24,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 14),
              // Skeleton for text
              Expanded(
                child: _SkeletonBox(
                  width: double.infinity,
                  height: 16,
                  borderRadius: 4,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 14),
              // Skeleton for arrow
              _SkeletonBox(
                width: 24,
                height: 24,
                borderRadius: 4,
                colorScheme: colorScheme,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ColorScheme colorScheme;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.colorScheme,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.colorScheme.onSurface.withOpacity(_animation.value),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        );
      },
    );
  }
}
