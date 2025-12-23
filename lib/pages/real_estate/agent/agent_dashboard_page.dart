import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/config/app_config.dart';

class AgentDashboardPage extends ConsumerStatefulWidget {
  const AgentDashboardPage({super.key});

  @override
  ConsumerState<AgentDashboardPage> createState() => _AgentDashboardPageState();
}

class _AgentDashboardPageState extends ConsumerState<AgentDashboardPage> {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = true;
  String? _error;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadTokenAndDashboard();
  }

  Future<void> _loadTokenAndDashboard() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConfig.tokenKey);
      
      if (token == null) {
        setState(() {
          _error = 'Authentication required';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _token = token;
      });

      await _loadDashboard();
    } catch (e) {
      AppLogger.error('Error loading token: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadDashboard() async {
    if (_token == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final realEstateService = ref.read(realEstateServiceProvider);
      final data = await realEstateService.getAgentDashboard(token: _token!);
      
      setState(() {
        _dashboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading agent dashboard: $e');
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
        title: Text(
          localizations?.general_agent_panel ?? 'Agent Dashboard',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboard,
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

  Widget _buildErrorState(AppLocalizations? localizations, ColorScheme colorScheme) {
    final isNotAgent = _error?.toLowerCase().contains('not registered as an agent') ?? false;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNotAgent ? Icons.person_off : Icons.error_outline,
              size: 64,
              color: isNotAgent ? colorScheme.primary : colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isNotAgent
                  ? 'Not Registered as Agent'
                  : 'Error loading dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isNotAgent
                  ? 'You need to register as an agent to access the dashboard.'
                  : _error ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isNotAgent)
              ElevatedButton.icon(
                onPressed: _loadDashboard,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    AppLocalizations? localizations,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final agentInfo = _dashboardData?['agent_info'];
    final statistics = _dashboardData?['statistics'] ?? {};
    final monthlyPerformance = _dashboardData?['monthly_performance'] as List<dynamic>? ?? [];

    return RefreshIndicator(
      onRefresh: _loadDashboard,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agent Info Card
            if (agentInfo != null) _buildAgentInfoCard(agentInfo, colorScheme),
            const SizedBox(height: 24),

            // Statistics Grid
            _buildSectionTitle('Statistics', theme),
            const SizedBox(height: 12),
            _buildStatisticsGrid(localizations, colorScheme, statistics),
            const SizedBox(height: 24),

            // Monthly Performance
            if (monthlyPerformance.isNotEmpty) ...[
              _buildSectionTitle('Monthly Performance (Last 6 Months)', theme),
              const SizedBox(height: 12),
              _buildMonthlyPerformanceTable(monthlyPerformance, colorScheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAgentInfoCard(Map<String, dynamic> agentInfo, ColorScheme colorScheme) {
    final user = agentInfo['user'] ?? {};
    final agencyName = agentInfo['agency_name'] ?? 'No Agency';
    final rating = agentInfo['rating'] ?? '0.0';
    final totalSales = agentInfo['total_sales'] ?? 0;
    final yearsExperience = agentInfo['years_experience'] ?? 0;
    final specialization = agentInfo['specialization'] ?? 'N/A';
    final isVerified = agentInfo['is_verified'] ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          agencyName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 8),
                          Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${user['username'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(
                icon: Icons.star,
                label: 'Rating',
                value: rating,
                color: Colors.amber,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 16),
              _buildInfoItem(
                icon: Icons.sell,
                label: 'Total Sales',
                value: totalSales.toString(),
                color: Colors.green,
                colorScheme: colorScheme,
              ),
              const SizedBox(width: 16),
              _buildInfoItem(
                icon: Icons.calendar_today,
                label: 'Experience',
                value: '$yearsExperience years',
                color: Colors.blue,
                colorScheme: colorScheme,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Specialization: $specialization',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(
    AppLocalizations? localizations,
    ColorScheme colorScheme,
    Map<String, dynamic> statistics,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          title: 'Total Properties',
          value: statistics['total_properties']?.toString() ?? '0',
          icon: Icons.home,
          color: Colors.blue,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: 'Active Properties',
          value: statistics['active_properties']?.toString() ?? '0',
          icon: Icons.check_circle,
          color: Colors.green,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: 'Sold Properties',
          value: statistics['sold_properties']?.toString() ?? '0',
          icon: Icons.sell,
          color: Colors.orange,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: 'Pending Inquiries',
          value: statistics['pending_inquiries']?.toString() ?? '0',
          icon: Icons.pending,
          color: Colors.purple,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: 'Recent Views (30d)',
          value: statistics['recent_views']?.toString() ?? '0',
          icon: Icons.visibility,
          color: Colors.teal,
          colorScheme: colorScheme,
        ),
        _buildStatCard(
          title: 'Recent Inquiries (30d)',
          value: statistics['recent_inquiries']?.toString() ?? '0',
          icon: Icons.message,
          color: Colors.indigo,
          colorScheme: colorScheme,
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
                    fontSize: 11,
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
    );
  }

  Widget _buildMonthlyPerformanceTable(
    List<dynamic> monthlyPerformance,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ...monthlyPerformance.map((month) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      month['month'] ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${month['properties'] ?? 0} Properties',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${month['inquiries'] ?? 0} Inquiries',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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

