import 'package:app/pages/service/main/service_search.dart';
import 'package:app/pages/service/main/services_list.dart';
import 'package:app/pages/tab_bar/tab_bar.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilteredServices extends ConsumerStatefulWidget {
  final String categoryName;
  final String regionName;
  final String districtName;

  const FilteredServices({
    super.key,
    this.categoryName = '',
    this.regionName = '',
    this.districtName = '',
  });

  @override
  ConsumerState<FilteredServices> createState() => _FilteredServicesState();
}

class _FilteredServicesState extends ConsumerState<FilteredServices> {
  final ScrollController _scrollController = ScrollController();
  List<Services> _allServices = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialServices();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200 pixels from bottom
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreServices();
      }
    }
  }

  Future<void> _loadInitialServices() async {
    setState(() {
      _isInitialLoading = true;
      _currentPage = 1;
      _allServices.clear();
      _hasMoreData = true;
    });

    try {
      final services = await ref.read(serviceMainProvider).getFilteredServices(
            currentPage: 1,
            pageSize: 12,
            categoryName: widget.categoryName,
            regionName: widget.regionName,
            districtName: widget.districtName,
          );

      setState(() {
        _allServices = services;
        _currentPage = 1;
        _hasMoreData = services.length >= 12;
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading services: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMoreServices() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newServices =
          await ref.read(serviceMainProvider).getFilteredServices(
                currentPage: nextPage,
                pageSize: 12,
                categoryName: widget.categoryName,
                regionName: widget.regionName,
                districtName: widget.districtName,
              );

      setState(() {
        if (newServices.isNotEmpty) {
          _allServices.addAll(newServices);
          _currentPage = nextPage;
          _hasMoreData = newServices.length >= 12;
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
            content: Text('Error loading more services: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> refresh() async {
    await _loadInitialServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (ctx) => const TabsScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const ServiceSearch(),
                ),
              );
            },
          ),
        ],
        title: Text("Filtered Services"),
      ),
      body: Column(
        children: [
          if (widget.categoryName.isNotEmpty || widget.districtName.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.blue.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                  SizedBox(width: 8),
                  if (widget.categoryName.isNotEmpty)
                    Text(
                      'Category: ${widget.categoryName}',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  if (widget.categoryName.isNotEmpty &&
                      widget.districtName.isNotEmpty) ...[
                    SizedBox(width: 8),
                    Text('|', style: TextStyle(color: Colors.blue)),
                    SizedBox(width: 8),
                  ],
                  if (widget.districtName.isNotEmpty)
                    Text(
                      '📍 ${widget.districtName} ',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: _buildServicesList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allServices.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.post_add_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No services available.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Try changing your filters',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _allServices.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show services
        if (index < _allServices.length) {
          final service = _allServices[index];
          return ServiceList(
            service: service,
            refresh: refresh,
          );
        }

        // Show loading indicator at the bottom
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

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No more services to load',
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
}
