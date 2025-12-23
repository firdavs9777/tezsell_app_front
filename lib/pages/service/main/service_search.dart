import 'package:app/pages/service/main/services_list.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceSearch extends ConsumerStatefulWidget {
  final String regionName;
  final String districtName;

  const ServiceSearch({
    super.key,
    this.regionName = '',
    this.districtName = '',
  });

  @override
  ConsumerState<ServiceSearch> createState() => _ServiceSearchState();
}

class _ServiceSearchState extends ConsumerState<ServiceSearch> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Services> _allServices = [];
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isInitialLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData && _hasSearched) {
        _loadMoreServices();
      }
    }
  }

  Future<void> _searchServices(String _) async {
    if (_searchController.text.trim().isEmpty) return;

    // Unfocus keyboard after search
    _focusNode.unfocus();

    setState(() {
      _isInitialLoading = true;
      _hasSearched = true;
      _currentPage = 1;
      _allServices.clear();
      _hasMoreData = true;
    });

    try {
      final services = await ref.read(serviceMainProvider).getFilteredServices(
            serviceName: _searchController.text,
            regionName: widget.regionName,
            districtName: widget.districtName,
            currentPage: 1,
            pageSize: 12,
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
            content: Text('Error searching services: $error'),
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

  Future<void> _loadMoreServices() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newServices =
          await ref.read(serviceMainProvider).getFilteredServices(
                serviceName: _searchController.text,
                regionName: widget.regionName,
                districtName: widget.districtName,
                currentPage: nextPage,
                pageSize: 12,
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
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _hasSearched = false;
      _allServices.clear();
    });
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: _buildSearchBar(),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Divider under search bar
          Divider(height: 1, color: Colors.grey.shade200),

          // Show current location filter if active
          if (widget.regionName.isNotEmpty || widget.districtName.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16, color: Colors.grey.shade600),
                  SizedBox(width: 6),
                  Text(
                    '${widget.districtName.isNotEmpty ? widget.districtName : widget.regionName}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.searchServicePlaceholder ??
              "Search services",
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey.shade500,
            size: 22,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                  onPressed: _clearSearch,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
        onSubmitted: _searchServices,
        onChanged: (value) {
          setState(() {}); // Update to show/hide clear button
          if (value.isEmpty) {
            setState(() {
              _hasSearched = false;
              _allServices.clear();
            });
          }
        },
      ),
    );
  }

  Widget _buildSearchResults() {
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.service ?? "Search for services",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Find professionals in your neighborhood",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_allServices.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            SizedBox(height: 16),
            Text(
              "No services found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Try different keywords',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _allServices.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _allServices.length) {
          final service = _allServices[index];
          return ServiceList(
            service: service,
            refresh: () {},
          );
        }

        if (_hasMoreData) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: _isLoadingMore
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const SizedBox.shrink(),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              '—',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 18,
              ),
            ),
          ),
        );
      },
    );
  }
}
