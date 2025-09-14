import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RealEstateMain extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const RealEstateMain(
      {super.key, required this.regionName, required this.districtName});

  @override
  ConsumerState<RealEstateMain> createState() => _RealEstateMainState();
}

class _RealEstateMainState extends ConsumerState<RealEstateMain> {
  final ScrollController _scrollController = ScrollController();
  List<RealEstate> _allProperties = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;

  String _selectedPropertyType = '';
  String _selectedListingType = '';

  // Property type options
  final List<Map<String, String>> _propertyTypes = [
    {'key': '', 'label': 'Barchasi'},
    {'key': 'apartment', 'label': 'Kvartira'},
    {'key': 'house', 'label': 'Uy'},
    {'key': 'office', 'label': 'Ofis'},
    {'key': 'land', 'label': 'Yer'},
    {'key': 'commercial', 'label': 'Boshqa'},
  ];

  @override
  void initState() {
    print(widget.regionName);
    print(widget.districtName);
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialProperties();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreProperties();
      }
    }
  }

  Future<void> _loadInitialProperties() async {
    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allProperties.clear();
      _hasMoreData = true;
    });

    try {
      final properties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: 1,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

      setState(() {
        _allProperties = properties;
        _currentPage = 1;
        _hasMoreData = properties.length >= 12;
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMoreProperties() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newProperties =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: nextPage,
                pageSize: 12,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

      setState(() {
        if (newProperties.isNotEmpty) {
          _allProperties.addAll(newProperties);
          _currentPage = nextPage;
          _hasMoreData = newProperties.length >= 12;
        } else {
          _hasMoreData = false;
        }
        _isLoadingMore = false;
      });
    } catch (error) {
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading more properties: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> refresh() async {
    await _loadInitialProperties();
  }

  @override
  void didUpdateWidget(RealEstateMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.regionName != widget.regionName ||
        oldWidget.districtName != widget.districtName) {
      _loadInitialProperties();
    }
  }

  void _onPropertyTypeChanged(String propertyType) {
    setState(() {
      _selectedPropertyType = propertyType;
    });
    _loadInitialProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          // Filter Categories
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _propertyTypes.length,
                    itemBuilder: (context, index) {
                      final type = _propertyTypes[index];
                      final isSelected = _selectedPropertyType == type['key'];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(
                            type['label']!,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) =>
                              _onPropertyTypeChanged(type['key']!),
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey.shade200,
                          checkmarkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                // Show current location filter
                if (widget.regionName.isNotEmpty ||
                    widget.districtName.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Text(
                      '📍 ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),

          // Properties List
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: _buildPropertiesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to add property page
            print('Add real estate pressed');
          },
          backgroundColor: const Color(0xFFFFA500),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
            size: 24,
          ),
          label: Text(
            AppLocalizations.of(context)?.upload ?? 'Yuklash',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildPropertiesList() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allProperties.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.apartment,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No properties available.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.regionName.isNotEmpty ||
                    widget.districtName.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'No properties found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: _allProperties.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _allProperties.length) {
          final property = _allProperties[index];
          return _buildRealEstateCard(property);
        }

        if (_hasMoreData) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: _isLoadingMore
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No more properties to load',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRealEstateCard(RealEstate property) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          // Navigate to property detail page
          print('Property ${property.id} tapped');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Property Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: 80,
                  height: 80,
                  child: property.mainImage.isNotEmpty
                      ? Image.network(
                          property.mainImage,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Icon(
                                Icons.apartment,
                                size: 40,
                                color: Colors.grey,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.apartment,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),

              const SizedBox(width: 12),

              // Property Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${property.bedrooms} bed, ${property.bathrooms} bath • ${property.squareMeters}m²',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${property.city}, ${property.district}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Price and Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${property.price} ${property.currency}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      property.listingTypeDisplay,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.visibility,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property.viewsCount}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
