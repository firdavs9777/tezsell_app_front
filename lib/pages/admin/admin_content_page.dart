import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/admin_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';

class AdminContentPage extends ConsumerStatefulWidget {
  const AdminContentPage({super.key});

  @override
  ConsumerState<AdminContentPage> createState() => _AdminContentPageState();
}

class _AdminContentPageState extends ConsumerState<AdminContentPage> {
  Map<String, dynamic>? _contentData;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String? _selectedContentType;
  bool? _isActiveFilter;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _contentTypeOptions = ['product', 'service', 'property'];

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContent() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final adminService = ref.read(adminServiceProvider);
      final data = await adminService.getContent(
        contentType: _selectedContentType,
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        isActive: _isActiveFilter,
        page: _currentPage,
        pageSize: 20,
      );
      setState(() {
        _contentData = data;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading content: $e');
      
      // Check if it's a 404 or backend not implemented error
      final errorString = e.toString().toLowerCase();
      final isBackendNotReady = errorString.contains('failed to load') || 
                                 errorString.contains('404') ||
                                 errorString.contains('not found');
      
      setState(() {
        _error = isBackendNotReady 
            ? 'backend_not_implemented' 
            : e.toString();
        _isLoading = false;
      });
      
      // Only show error snackbar if it's not a backend implementation issue
      if (mounted && !isBackendNotReady) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> _removeContent(int contentId, String contentType) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove ${contentType.toUpperCase()}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to remove this content? This action cannot be undone.'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason *',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        final adminService = ref.read(adminServiceProvider);
        await adminService.removeContent(
          contentId: contentId,
          contentType: contentType,
          reason: reasonController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${contentType.toUpperCase()} removed successfully')),
          );
          _loadContent();
        }
      } catch (e) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Content Management', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadContent,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(localizations, colorScheme),
          // Content List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState(localizations, colorScheme)
                    : _buildContentList(localizations, theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(AppLocalizations? localizations, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      child: Column(
        children: [
          // Search
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search content',
              hintText: 'Enter title or description',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _loadContent();
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            onSubmitted: (_) => _loadContent(),
          ),
          const SizedBox(height: 12),
          // Filters Row
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedContentType,
                  decoration: InputDecoration(
                    labelText: 'Content Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Types')),
                    ..._contentTypeOptions.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedContentType = value;
                      _currentPage = 1;
                    });
                    _loadContent();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<bool>(
                  value: _isActiveFilter,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: true, child: Text('Active')),
                    DropdownMenuItem(value: false, child: Text('Inactive')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isActiveFilter = value;
                      _currentPage = 1;
                    });
                    _loadContent();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(AppLocalizations? localizations, ColorScheme colorScheme) {
    final isBackendNotReady = _error == 'backend_not_implemented';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isBackendNotReady ? Icons.build_outlined : Icons.error_outline,
              size: 64,
              color: isBackendNotReady ? colorScheme.primary : colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isBackendNotReady
                  ? 'Backend API Not Implemented Yet'
                  : 'Error loading content',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isBackendNotReady
                  ? 'The admin content API endpoint needs to be implemented on the backend.\n\n'
                      'Please implement: GET /api/admin/content/\n\n'
                      'This endpoint should support filtering by content type, search, and status.'
                  : _error ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isBackendNotReady)
              ElevatedButton.icon(
                onPressed: _loadContent,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadContent,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Show mock data for development
                      setState(() {
                        _contentData = _getMockContentData();
                        _error = null;
                        _isLoading = false;
                      });
                    },
                    icon: const Icon(Icons.developer_mode),
                    label: const Text('Load Mock Data (Dev)'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getMockContentData() {
    final mockContent = [
      {
        'id': 1,
        'title': 'Fresh Organic Tomatoes',
        'content_type': 'product',
        'is_active': true,
        'owner': {'username': 'farmer_john', 'id': 1},
        'created_at': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
        'views': 245,
        'price': '15000',
      },
      {
        'id': 2,
        'title': 'Premium Carrot Delivery Service',
        'content_type': 'service',
        'is_active': true,
        'owner': {'username': 'green_valley', 'id': 2},
        'created_at': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
        'views': 189,
        'price': '25000',
      },
      {
        'id': 3,
        'title': 'Farm Land for Sale - 2 Hectares',
        'content_type': 'property',
        'is_active': true,
        'owner': {'username': 'land_agent', 'id': 3},
        'created_at': DateTime.now().subtract(const Duration(days: 10)).toIso8601String(),
        'views': 567,
        'price': '50000000',
      },
      {
        'id': 4,
        'title': 'Organic Potatoes - Bulk Order',
        'content_type': 'product',
        'is_active': false,
        'owner': {'username': 'potato_farm', 'id': 4},
        'created_at': DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
        'views': 98,
        'price': '12000',
      },
      {
        'id': 5,
        'title': 'Vegetable Packaging Service',
        'content_type': 'service',
        'is_active': true,
        'owner': {'username': 'pack_pro', 'id': 5},
        'created_at': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
        'views': 134,
        'price': '30000',
      },
      {
        'id': 6,
        'title': 'Warehouse Space for Rent',
        'content_type': 'property',
        'is_active': true,
        'owner': {'username': 'storage_co', 'id': 6},
        'created_at': DateTime.now().subtract(const Duration(days: 15)).toIso8601String(),
        'views': 312,
        'price': '1500000',
      },
      {
        'id': 7,
        'title': 'Fresh Cucumbers',
        'content_type': 'product',
        'is_active': true,
        'owner': {'username': 'veggie_mart', 'id': 7},
        'created_at': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'views': 201,
        'price': '18000',
      },
      {
        'id': 8,
        'title': 'Farm Equipment Maintenance',
        'content_type': 'service',
        'is_active': true,
        'owner': {'username': 'equip_services', 'id': 8},
        'created_at': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
        'views': 156,
        'price': '45000',
      },
    ];

    // Filter mock data based on current filters
    var filteredContent = mockContent;
    
    if (_selectedContentType != null) {
      filteredContent = filteredContent
          .where((item) => item['content_type'] == _selectedContentType)
          .toList();
    }
    
    if (_isActiveFilter != null) {
      filteredContent = filteredContent
          .where((item) => item['is_active'] == _isActiveFilter)
          .toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      final searchLower = _searchController.text.toLowerCase();
      filteredContent = filteredContent
          .where((item) => item['title'].toString().toLowerCase().contains(searchLower))
          .toList();
    }

    return {
      'count': filteredContent.length,
      'next': null,
      'previous': null,
      'results': filteredContent,
    };
  }

  Widget _buildContentList(AppLocalizations? localizations, ThemeData theme, ColorScheme colorScheme) {
    final content = _contentData?['results'] as List<dynamic>? ?? [];
    final count = _contentData?['count'] ?? 0;
    final next = _contentData?['next'];
    final previous = _contentData?['previous'];

    if (content.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.content_copy_outlined, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No content found', style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $count items', style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            ],
          ),
        ),
        // Content List
        Expanded(
          child: ListView.builder(
            itemCount: content.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = content[index];
              return _buildContentCard(item, colorScheme);
            },
          ),
        ),
        // Pagination
        if (next != null || previous != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outline.withOpacity(0.2))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: previous != null
                      ? () {
                          setState(() => _currentPage--);
                          _loadContent();
                        }
                      : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
                Text('Page $_currentPage', style: TextStyle(color: colorScheme.onSurface)),
                ElevatedButton.icon(
                  onPressed: next != null
                      ? () {
                          setState(() => _currentPage++);
                          _loadContent();
                        }
                      : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content, ColorScheme colorScheme) {
    final title = content['title'] ?? 'Untitled';
    final contentType = content['content_type'] ?? _selectedContentType ?? 'unknown';
    final isActive = content['is_active'] ?? true;
    final owner = content['owner'] ?? {};
    final ownerName = owner['username'] ?? 'Unknown';
    final createdAt = content['created_at'] ?? '';
    final views = content['views'] ?? 0;
    final price = content['price'] ?? '';

    IconData iconData;
    Color typeColor;
    switch (contentType) {
      case 'product':
        iconData = Icons.shopping_bag;
        typeColor = Colors.blue;
        break;
      case 'service':
        iconData = Icons.build;
        typeColor = Colors.green;
        break;
      case 'property':
        iconData = Icons.home;
        typeColor = Colors.orange;
        break;
      default:
        iconData = Icons.content_copy;
        typeColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // Navigate to content detail
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(iconData, color: typeColor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'By: $ownerName',
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isActive ? Colors.green : Colors.red),
                    ),
                    child: Text(
                      isActive ? 'ACTIVE' : 'INACTIVE',
                      style: TextStyle(
                        color: isActive ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.visibility, size: 16, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text('$views', style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      if (price.toString().isNotEmpty) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.attach_money, size: 16, color: colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(price.toString(), style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant)),
                      ],
                    ],
                  ),
                  Text(
                    createdAt.isNotEmpty ? createdAt.split('T')[0] : '',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _removeContent(content['id'], contentType),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    label: const Text('Remove', style: TextStyle(color: Colors.red)),
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

