import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/admin_provider.dart';
import 'package:app/pages/admin/admin_reports_page.dart';
import 'package:app/pages/admin/admin_users_page.dart';
import 'package:app/pages/admin/admin_content_page.dart';
import 'package:app/pages/admin/admin_statistics_page.dart';
import 'package:app/pages/admin/admin_agents_page.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final adminService = ref.read(adminServiceProvider);

      // Try new statistics APIs first
      try {
        final newStats = await adminService.getStatisticsFromNewAPIs();

        // Also try to get dashboard stats for additional data
        Map<String, dynamic>? dashboardStats;
        try {
          dashboardStats = await adminService.getDashboardStats();
        } catch (e) {
          // If dashboard endpoint not available, use only new stats
          AppLogger.error('Dashboard stats endpoint not available: $e');
        }

        // Merge data
        setState(() {
          _dashboardData = {
            'stats': {
              'total_properties': newStats['total_properties'] ?? 0,
              'total_agents': newStats['total_agents'] ?? 0,
              'total_users': newStats['total_users'] ?? 0,
              'total_views': dashboardStats?['stats']?['total_views'] ?? 0,
              'avg_sale_price':
                  dashboardStats?['stats']?['avg_sale_price'] ?? 0,
              'total_portfolio_value':
                  dashboardStats?['stats']?['total_portfolio_value'] ?? 0,
              'avg_price_per_sqm':
                  dashboardStats?['stats']?['avg_price_per_sqm'] ?? 0,
              'avg_views_per_property':
                  dashboardStats?['stats']?['avg_views_per_property'] ?? 0,
            },
            'last_update': dashboardStats?['last_update'] ??
                DateTime.now().toIso8601String(),
            'property_types_distribution':
                dashboardStats?['property_types_distribution'] ?? {},
            'properties_by_city': dashboardStats?['properties_by_city'] ?? {},
            'inquiry_types_distribution':
                dashboardStats?['inquiry_types_distribution'] ?? {},
            'agent_verification_rate':
                dashboardStats?['agent_verification_rate'] ?? 0,
            'inquiry_response_rate':
                dashboardStats?['inquiry_response_rate'] ?? 0,
            'featured_properties': dashboardStats?['featured_properties'] ?? 0,
            'properties_without_images':
                dashboardStats?['properties_without_images'] ?? 0,
            'missing_location_data':
                dashboardStats?['missing_location_data'] ?? 0,
            'pending_agent_verification': newStats['pending_agents'] ?? 0,
            'verified_agents': newStats['verified_agents'] ?? 0,
          };
          _isLoading = false;
        });
      } catch (e) {
        // Fallback to old dashboard endpoint
        AppLogger.error('New statistics APIs failed, trying old endpoint: $e');
        final data = await adminService.getDashboardStats();
        setState(() {
          _dashboardData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      AppLogger.error('Error loading dashboard: $e');

      // Check if it's a 404 or backend not implemented error
      final errorString = e.toString().toLowerCase();
      final isBackendNotReady = errorString.contains('failed to load') ||
          errorString.contains('404') ||
          errorString.contains('not found');

      setState(() {
        _error = isBackendNotReady ? 'backend_not_implemented' : e.toString();
        _isLoading = false;
      });

      // Only show error snackbar if it's not a backend implementation issue
      if (mounted && !isBackendNotReady) {
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
        title: Text(
          localizations?.admin_dashboard_title ?? 'Admin Dashboard',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(localizations, colorScheme)
              : _buildDashboardContent(localizations, theme, colorScheme),
    );
  }

  Widget _buildErrorState(
      AppLocalizations? localizations, ColorScheme colorScheme) {
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
              color:
                  isBackendNotReady ? colorScheme.primary : colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isBackendNotReady
                  ? 'Backend API Not Implemented Yet'
                  : localizations?.admin_error_loading_dashboard ??
                      'Error loading dashboard',
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
                  ? 'The admin dashboard API endpoint needs to be implemented on the backend.\n\n'
                      'Please implement: GET /api/admin/dashboard/\n\n'
                      'For now, you can use the other admin pages (Reports, Users, Content, Statistics) '
                      'which will also need their respective backend endpoints.'
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
                onPressed: _loadDashboardData,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              )
            else
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _loadDashboardData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Show mock data for development
                      setState(() {
                        _dashboardData = _getMockDashboardData();
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

  Map<String, dynamic> _getMockDashboardData() {
    return {
      'stats': {
        'total_properties': 1250,
        'total_agents': 45,
        'total_users': 5430,
        'total_views': 125000,
        'avg_sale_price': 85000,
        'total_portfolio_value': 106250000,
        'avg_price_per_sqm': 850,
        'avg_views_per_property': 100,
      },
      'last_update': DateTime.now().toIso8601String(),
      'property_types_distribution': {
        'apartment': 45.2,
        'house': 28.5,
        'villa': 12.3,
        'commercial': 8.0,
        'office': 4.5,
        'land': 1.5,
      },
      'properties_by_city': {
        'Tashkent': 450,
        'Samarkand': 320,
        'Bukhara': 180,
        'Andijan': 150,
        'Namangan': 120,
        'Fergana': 30,
      },
      'inquiry_types_distribution': {
        'viewing': 45,
        'info': 30,
        'offer': 15,
        'callback': 10,
      },
      'agent_verification_rate': 85.5,
      'inquiry_response_rate': 92.3,
      'featured_properties': 125,
      'properties_without_images': 12,
      'missing_location_data': 8,
      'pending_agent_verification': 5,
    };
  }

  Widget _buildDashboardContent(
    AppLocalizations? localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final stats = _dashboardData?['stats'] ?? {};
    final lastUpdate = _dashboardData?['last_update'] ?? '';

    // Format the last update time
    String formattedUpdate = '';
    if (lastUpdate.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(lastUpdate);
        formattedUpdate =
            '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
      } catch (e) {
        formattedUpdate = lastUpdate;
      }
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            if (formattedUpdate.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        size: 20, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      '${localizations?.admin_last_update ?? 'Last update'}: $formattedUpdate',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // Quick Stats Grid
            _buildStatsGrid(localizations, colorScheme, stats),
            const SizedBox(height: 24),

            // Quick Actions
            _buildSectionTitle(
                localizations?.admin_panel ?? 'Quick Actions', theme),
            const SizedBox(height: 12),
            _buildQuickActions(localizations, colorScheme),
            const SizedBox(height: 24),

            // Additional Stats
            _buildSectionTitle('Statistics', theme),
            const SizedBox(height: 12),
            _buildAdditionalStats(localizations, colorScheme, stats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
    AppLocalizations? localizations,
    ColorScheme colorScheme,
    Map<String, dynamic> stats,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: localizations?.admin_total_properties ?? 'Total Properties',
          value: stats['total_properties']?.toString() ?? '0',
          icon: Icons.home,
          color: Colors.blue,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const RealEstateMain(regionName: '', districtName: ''),
              ),
            );
          },
        ),
        _buildStatCard(
          title: localizations?.admin_total_agents ?? 'Total Agents',
          value: stats['total_agents']?.toString() ?? '0',
          icon: Icons.badge,
          color: Colors.green,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminAgentsPage(),
              ),
            );
          },
        ),
        _buildStatCard(
          title: localizations?.admin_total_users ?? 'Total Users',
          value: stats['total_users']?.toString() ?? '0',
          icon: Icons.people,
          color: Colors.orange,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminUsersPage(),
              ),
            );
          },
        ),
        _buildStatCard(
          title: localizations?.admin_total_views ?? 'Total Views',
          value: stats['total_views']?.toString() ?? '0',
          icon: Icons.visibility,
          color: Colors.purple,
          colorScheme: colorScheme,
          onTap: () {
            // Navigate to properties list (views are property-level)
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const RealEstateMain(regionName: '', districtName: ''),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required ColorScheme colorScheme,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
              ],
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    AppLocalizations? localizations,
    ColorScheme colorScheme,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.5,
      children: [
        _buildActionCard(
          title: 'Reports',
          icon: Icons.flag,
          color: Colors.red,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminReportsPage()),
            );
          },
        ),
        _buildActionCard(
          title: 'Users',
          icon: Icons.people,
          color: Colors.blue,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminUsersPage()),
            );
          },
        ),
        _buildActionCard(
          title: 'Content',
          icon: Icons.content_copy,
          color: Colors.green,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminContentPage()),
            );
          },
        ),
        _buildActionCard(
          title: 'Statistics',
          icon: Icons.analytics,
          color: Colors.purple,
          colorScheme: colorScheme,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AdminStatisticsPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required ColorScheme colorScheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalStats(
    AppLocalizations? localizations,
    ColorScheme colorScheme,
    Map<String, dynamic> stats,
  ) {
    return Column(
      children: [
        _buildStatRow(
          label: localizations?.admin_avg_sale_price ?? 'Avg Sale Price',
          value: stats['avg_sale_price']?.toString() ?? 'N/A',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          label: localizations?.admin_total_portfolio_value ??
              'Total Portfolio Value',
          value: stats['total_portfolio_value']?.toString() ?? 'N/A',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          label: localizations?.admin_avg_price_per_sqm ?? 'Avg Price per m²',
          value: stats['avg_price_per_sqm']?.toString() ?? 'N/A',
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildStatRow({
    required String label,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}
