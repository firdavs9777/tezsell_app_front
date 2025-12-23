import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/admin_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  Map<String, dynamic>? _usersData;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  bool? _isActiveFilter;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final adminService = ref.read(adminServiceProvider);
      final data = await adminService.getUsers(
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        isActive: _isActiveFilter,
        page: _currentPage,
        pageSize: 20,
      );
      setState(() {
        _usersData = data;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading users: $e');
      
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

  Future<void> _suspendUser(int userId) async {
    final reasonController = TextEditingController();
    final durationController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend User'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(
                labelText: 'Duration (days, leave empty for permanent)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
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
            child: const Text('Suspend'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        final adminService = ref.read(adminServiceProvider);
        await adminService.suspendUser(
          userId: userId,
          reason: reasonController.text,
          durationDays: durationController.text.isNotEmpty
              ? int.tryParse(durationController.text)
              : null,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User suspended successfully')),
          );
          _loadUsers();
        }
      } catch (e) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  Future<void> _banUser(int userId) async {
    final reasonController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ban User'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason *',
            border: OutlineInputBorder(),
          ),
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
            child: const Text('Ban'),
          ),
        ],
      ),
    );

    if (result == true && reasonController.text.isNotEmpty) {
      try {
        final adminService = ref.read(adminServiceProvider);
        await adminService.banUser(
          userId: userId,
          reason: reasonController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User banned successfully')),
          );
          _loadUsers();
        }
      } catch (e) {
        AppErrorHandler.showError(context, e);
      }
    }
  }

  void _showUserActions(int userId, bool isActive) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.block, color: Colors.orange),
              title: const Text('Suspend User'),
              onTap: () {
                Navigator.pop(context);
                _suspendUser(userId);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Ban User'),
              onTap: () {
                Navigator.pop(context);
                _banUser(userId);
              },
            ),
          ],
        ),
      ),
    );
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
        title: const Text('User Management', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(localizations, colorScheme),
          // Users List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState(localizations, colorScheme)
                    : _buildUsersList(localizations, theme, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(AppLocalizations? localizations, ColorScheme colorScheme) {
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
              labelText: 'Search users',
              hintText: 'Enter username or phone number',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _loadUsers();
                      },
                    )
                  : null,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            onSubmitted: (_) => _loadUsers(),
          ),
          const SizedBox(height: 12),
          // Active Filter
          Row(
            children: [
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
                    DropdownMenuItem(value: null, child: Text('All Users')),
                    DropdownMenuItem(value: true, child: Text('Active')),
                    DropdownMenuItem(value: false, child: Text('Inactive')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _isActiveFilter = value;
                      _currentPage = 1;
                    });
                    _loadUsers();
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
                  : 'Error loading users',
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
                  ? 'The admin users API endpoint needs to be implemented on the backend.\n\n'
                      'Please implement: GET /api/admin/users/\n\n'
                      'This endpoint should support filtering by search query and active status.'
                  : _error ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadUsers,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(AppLocalizations? localizations, ThemeData theme, ColorScheme colorScheme) {
    final users = _usersData?['results'] as List<dynamic>? ?? [];
    final count = _usersData?['count'] ?? 0;
    final next = _usersData?['next'];
    final previous = _usersData?['previous'];

    if (users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No users found', style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant)),
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
              Text('Total: $count users', style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            ],
          ),
        ),
        // Users List
        Expanded(
          child: ListView.builder(
            itemCount: users.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final user = users[index];
              return _buildUserCard(user, colorScheme);
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
                          _loadUsers();
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
                          _loadUsers();
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

  Widget _buildUserCard(Map<String, dynamic> user, ColorScheme colorScheme) {
    final username = user['username'] ?? 'Unknown';
    final phoneNumber = user['phone_number'] ?? '';
    final isActive = user['is_active'] ?? true;
    final userType = user['user_type'] ?? 'user';
    final isStaff = user['is_staff'] ?? false;
    final isSuperuser = user['is_superuser'] ?? false;
    final dateJoined = user['date_joined'] ?? '';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showUserActions(user['id'], isActive),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              username,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                            ),
                            if (isSuperuser) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('SUPER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                              ),
                            ] else if (isStaff) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text('STAFF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phoneNumber,
                          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
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
                  Text(
                    'Type: ${userType.toUpperCase()}',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    dateJoined.isNotEmpty ? dateJoined.split('T')[0] : '',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showUserActions(user['id'], isActive),
                    icon: const Icon(Icons.more_vert),
                    label: const Text('Actions'),
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

