import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/service/main/service-filter.dart';
import 'package:app/pages/service/new/service_new.dart';
import 'package:app/pages/service/main/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

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

  Future<void> _navigateToLocationChange() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyHomeTown(),
        settings: RouteSettings(name: '/location-change'),
      ),
    );

    if (result == true) {
      ref.invalidate(servicesProvider);
      ref.invalidate(profileServiceProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    // Listen for refresh trigger from service creation
    ref.listen<int>(servicesRefreshProvider, (previous, next) {
      if (previous != null && previous != next) {
        _loadInitialServices();
      }
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Enhanced Header
          Container(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
              top: 8.0,
              bottom: 12.0,
            ),
            decoration: BoxDecoration(
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Row(
                children: [
                  // Filter Button
                  Material(
                    color: colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => ServiceFilter(
                                regionName: widget.regionName,
                                districtName: widget.districtName),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Icon(
                          Icons.tune_rounded,
                          size: 22,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Location Badge
                  if (widget.regionName.isNotEmpty ||
                      widget.districtName.isNotEmpty)
                    Expanded(
                      child: Material(
                        color: colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _navigateToLocationChange,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    widget.districtName.isNotEmpty
                                        ? widget.districtName
                                        : widget.regionName,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colorScheme.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refresh,
              color: colorScheme.primary,
              child: _buildServicesList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => const ServiceNew(),
          ));
        },
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: Text(
          localizations?.upload ?? 'Yuklash',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildServicesList() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    if (_isInitialLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: colorScheme.primary,
        ),
      );
    }

    if (_allServices.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
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
                      Icons.design_services_outlined,
                      size: 64,
                      color: colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    localizations?.serviceError ?? 'No services available.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (widget.regionName.isNotEmpty ||
                      widget.districtName.isNotEmpty)
                    Text(
                      'No services found in ${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
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
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: _isLoadingMore
                  ? CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }

        // Show "end of list" indicator
        return Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              'No more services to load',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }
}
