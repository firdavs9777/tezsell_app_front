// Create this file: lib/pages/real_estate/real_estate_search.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RealEstateSearch extends ConsumerStatefulWidget {
  const RealEstateSearch({super.key});

  @override
  ConsumerState<RealEstateSearch> createState() => _RealEstateSearchState();
}

class _RealEstateSearchState extends ConsumerState<RealEstateSearch> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPropertyType = 'Barchasi';
  String _selectedPriceRange = 'Barchasi';
  String _selectedRooms = 'Barchasi';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ko\'chmas Mulk Qidirish'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Header
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Ko\'chmas mulk qidirish...',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant),
                      onPressed: () {
                        _searchController.clear();
                      },
                    ),
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    // Handle search
                    setState(() {});
                  },
                ),

                const SizedBox(height: 16),

                // Quick Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildQuickFilter(
                        'Tur',
                        _selectedPropertyType,
                        ['Barchasi', 'Uy-joy', 'Kvartira', 'Ofis', 'Yer'],
                        (value) =>
                            setState(() => _selectedPropertyType = value),
                      ),
                      const SizedBox(width: 12),
                      _buildQuickFilter(
                        'Narx',
                        _selectedPriceRange,
                        ['Barchasi', '\$0-50k', '\$50k-100k', '\$100k+'],
                        (value) => setState(() => _selectedPriceRange = value),
                      ),
                      const SizedBox(width: 12),
                      _buildQuickFilter(
                        'Xonalar',
                        _selectedRooms,
                        ['Barchasi', '1', '2', '3', '4+'],
                        (value) => setState(() => _selectedRooms = value),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Search Results
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildEmptyState()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilter(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.onPrimary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.onPrimary.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          icon:
              Icon(Icons.arrow_drop_down, color: colorScheme.onPrimary, size: 20),
          style: TextStyle(color: colorScheme.onPrimary, fontSize: 12),
          dropdownColor: colorScheme.primaryContainer,
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          items: options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(fontSize: 12, color: colorScheme.onPrimaryContainer),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: colorScheme.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Ko\'chmas mulk qidiring',
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Yuqoridagi qidiruv maydoniga\nkalit so\'zlarni kiriting',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    // This is where you would show actual search results
    // For now, showing sample results
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Replace with actual search results count
      itemBuilder: (context, index) {
        return _buildSearchResultCard(index);
      },
    );
  }

  Widget _buildSearchResultCard(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to detail page
          Navigator.pop(context); // Go back to main page
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 70,
                  height: 70,
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.apartment,
                    size: 35,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Property Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Result ${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Property description matching search...',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          'Tashkent, Uzbekistan',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${(50 + index * 10)}k',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? colorScheme.primary : const Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Ijara',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
