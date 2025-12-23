import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/admin_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';

class AdminStatisticsPage extends ConsumerStatefulWidget {
  const AdminStatisticsPage({super.key});

  @override
  ConsumerState<AdminStatisticsPage> createState() => _AdminStatisticsPageState();
}

class _AdminStatisticsPageState extends ConsumerState<AdminStatisticsPage> {
  Map<String, dynamic>? _statsData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Use the dashboard stats which includes comprehensive statistics
      final adminService = ref.read(adminServiceProvider);
      final dashboardData = await adminService.getDashboardStats();
      
      // Extract statistics from dashboard data
      setState(() {
        _statsData = dashboardData;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading statistics: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      if (mounted) {
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
        title: const Text('Statistics & Analytics', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStatistics,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorState(localizations, colorScheme)
              : _buildStatisticsContent(localizations, theme, colorScheme),
    );
  }

  Widget _buildErrorState(AppLocalizations? localizations, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Error loading statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(_error ?? '', style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadStatistics,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsContent(
    AppLocalizations? localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return RefreshIndicator(
      onRefresh: _loadStatistics,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildSectionTitle('Overview', theme),
            const SizedBox(height: 12),
            _buildOverviewCards(localizations, colorScheme),
            const SizedBox(height: 24),

            // Property Types Distribution
            _buildSectionTitle(
                localizations?.admin_property_types_distribution ?? 'Property Types Distribution', theme),
            const SizedBox(height: 12),
            _buildPropertyTypesChart(localizations, colorScheme),
            const SizedBox(height: 24),

            // Properties by City
            _buildSectionTitle(
                localizations?.admin_properties_by_city ?? 'Properties by City', theme),
            const SizedBox(height: 12),
            _buildPropertiesByCity(localizations, colorScheme),
            const SizedBox(height: 24),

            // Inquiry Types Distribution
            _buildSectionTitle(
                localizations?.admin_inquiry_types_distribution ?? 'Inquiry Types Distribution', theme),
            const SizedBox(height: 12),
            _buildInquiryTypesChart(localizations, colorScheme),
            const SizedBox(height: 24),

            // Performance Metrics
            _buildSectionTitle('Performance Metrics', theme),
            const SizedBox(height: 12),
            _buildPerformanceMetrics(localizations, colorScheme),
            const SizedBox(height: 24),

            // System Health
            _buildSectionTitle(
                localizations?.admin_system_health ?? 'System Health', theme),
            const SizedBox(height: 12),
            _buildSystemHealth(localizations, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(AppLocalizations? localizations, ColorScheme colorScheme) {
    final stats = _statsData ?? {};
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: [
        _buildStatCard(
          title: localizations?.admin_avg_sale_price ?? 'Avg Sale Price',
          value: _formatCurrency(stats['avg_sale_price']),
          subtitle: localizations?.admin_avg_sale_price_subtitle ?? 'All active listings',
          icon: Icons.attach_money,
          color: Colors.green,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: localizations?.admin_total_portfolio_value ?? 'Total Portfolio Value',
          value: _formatCurrency(stats['total_portfolio_value']),
          subtitle: localizations?.admin_total_portfolio_value_subtitle ?? 'Combined property value',
          icon: Icons.account_balance,
          color: Colors.blue,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: localizations?.admin_avg_price_per_sqm ?? 'Avg Price per m²',
          value: _formatCurrency(stats['avg_price_per_sqm']),
          subtitle: localizations?.admin_avg_price_per_sqm_subtitle ?? 'Market rate indicator',
          icon: Icons.square_foot,
          color: Colors.orange,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: localizations?.admin_avg_views_per_property ?? 'Avg Views per Property',
          value: stats['avg_views_per_property']?.toString() ?? '0',
          subtitle: localizations?.admin_avg_views_per_property_subtitle ?? 'Property popularity',
          icon: Icons.visibility,
          color: Colors.purple,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 9, color: colorScheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPropertyTypesChart(AppLocalizations? localizations, ColorScheme colorScheme) {
    final distribution = _statsData?['property_types_distribution'] as Map<String, dynamic>? ?? {};
    final entries = distribution.entries.toList();

    if (entries.isEmpty) {
      return _buildEmptyState('No property type data available', colorScheme);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: entries.map((entry) {
          final percentage = (entry.value as num).toDouble();
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key.toUpperCase(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                    ),
                    Text(
                      '${percentage.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    valueColor: AlwaysStoppedAnimation<Color>(_getColorForType(entry.key)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPropertiesByCity(AppLocalizations? localizations, ColorScheme colorScheme) {
    final byCity = _statsData?['properties_by_city'] as Map<String, dynamic>? ?? {};
    final entries = byCity.entries.toList()
      ..sort((a, b) => (b.value as num).compareTo(a.value as num));

    if (entries.isEmpty) {
      return _buildEmptyState('No city data available', colorScheme);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: entries.take(10).map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    entry.key,
                    style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.primary),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInquiryTypesChart(AppLocalizations? localizations, ColorScheme colorScheme) {
    final distribution = _statsData?['inquiry_types_distribution'] as Map<String, dynamic>? ?? {};
    final entries = distribution.entries.toList();

    if (entries.isEmpty) {
      return _buildEmptyState('No inquiry type data available', colorScheme);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: entries.map((entry) {
          final count = entry.value as num;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entry.key.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPerformanceMetrics(AppLocalizations? localizations, ColorScheme colorScheme) {
    final stats = _statsData ?? {};
    return Column(
      children: [
        _buildMetricRow(
          label: localizations?.admin_agent_verification_rate ?? 'Agent Verification Rate',
          value: '${stats['agent_verification_rate']?.toString() ?? '0'}%',
          subtitle: localizations?.admin_agent_verification_rate_subtitle ?? 'Quality control',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          label: localizations?.admin_inquiry_response_rate ?? 'Inquiry Response Rate',
          value: '${stats['inquiry_response_rate']?.toString() ?? '0'}%',
          subtitle: localizations?.admin_inquiry_response_rate_subtitle ?? 'Customer service',
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildMetricRow(
          label: localizations?.admin_featured_properties ?? 'Featured Properties',
          value: stats['featured_properties']?.toString() ?? '0',
          subtitle: localizations?.admin_featured_properties_subtitle ?? 'Premium listings',
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildMetricRow({
    required String label,
    required String value,
    required String subtitle,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth(AppLocalizations? localizations, ColorScheme colorScheme) {
    final stats = _statsData ?? {};
    return Column(
      children: [
        _buildHealthItem(
          label: localizations?.admin_properties_without_images ?? 'Properties without Images',
          value: stats['properties_without_images']?.toString() ?? '0',
          color: Colors.orange,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildHealthItem(
          label: localizations?.admin_missing_location_data ?? 'Missing Location Data',
          value: stats['missing_location_data']?.toString() ?? '0',
          color: Colors.red,
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 8),
        _buildHealthItem(
          label: localizations?.admin_pending_agent_verification ?? 'Pending Agent Verification',
          value: stats['pending_agent_verification']?.toString() ?? '0',
          color: Colors.blue,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  Widget _buildHealthItem({
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
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

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'apartment':
        return Colors.blue;
      case 'house':
        return Colors.green;
      case 'villa':
        return Colors.orange;
      case 'commercial':
        return Colors.purple;
      case 'office':
        return Colors.teal;
      case 'land':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _formatCurrency(dynamic value) {
    if (value == null) return 'N/A';
    if (value is num) {
      return value.toStringAsFixed(0);
    }
    return value.toString();
  }
}

