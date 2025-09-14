import 'package:app/pages/service/service-filter.dart';
import 'package:app/pages/service/service_new.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceMain extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const ServiceMain(
      {super.key, required this.regionName, required this.districtName});

  @override
  _ServiceMainState createState() => _ServiceMainState();
}

class _ServiceMainState extends ConsumerState<ServiceMain> {
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
            regionName: widget.regionName,
            districtName: widget.districtName,
          );

      setState(() {
        _allServices = services;
        _currentPage = 1;
        _hasMoreData =
            services.length >= 12; // If less than pageSize, no more data
        _isInitialLoading = false;
      });
    } catch (error) {
      setState(() {
        _isInitialLoading = false;
      });
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
                currentPage:
                    nextPage, // Fixed: was using page 1 instead of nextPage
                pageSize: 12,
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
      // Show error snackbar
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
  void didUpdateWidget(ServiceMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload services if location changed
    if (oldWidget.regionName != widget.regionName ||
        oldWidget.districtName != widget.districtName) {
      _loadInitialServices();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 8.0, bottom: 10.0, top: 8.0, right: 10.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    // Navigate to category filter screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const ServiceFilter(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.filter_list_sharp,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Spacer(),
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
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: _buildServicesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => const ServiceNew(),
            ));
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
                  Icons.design_services_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)?.serviceError ??
                      'No services available.',
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
                    'No services found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
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
      itemCount: _allServices.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        // Show services
        if (index < _allServices.length) {
          final service = _allServices[index];
          return ServiceList(service: service, refresh: refresh);
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
