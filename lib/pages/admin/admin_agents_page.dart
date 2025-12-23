import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/config/app_config.dart';

class AdminAgentsPage extends ConsumerStatefulWidget {
  const AdminAgentsPage({super.key});

  @override
  ConsumerState<AdminAgentsPage> createState() => _AdminAgentsPageState();
}

class _AdminAgentsPageState extends ConsumerState<AdminAgentsPage> {
  Map<String, dynamic>? _agentsData;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAgents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final queryParams = <String, String>{
        'page': _currentPage.toString(),
        'page_size': '20',
      };
      
      if (_searchController.text.isNotEmpty) {
        queryParams['search'] = _searchController.text;
      }

      final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.realEstateAgentsPath}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _agentsData = data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load agents');
      }
    } catch (e) {
      AppLogger.error('Error loading agents: $e');
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
          localizations?.admin_total_agents ?? 'Total Agents',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAgents,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search agents',
                hintText: 'Enter name or agency',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadAgents();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
              ),
              onSubmitted: (_) {
                setState(() => _currentPage = 1);
                _loadAgents();
              },
            ),
          ),
          // Agents List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState(localizations, colorScheme)
                    : _buildAgentsList(localizations, theme, colorScheme),
          ),
        ],
      ),
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
              'Error loading agents',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(_error ?? '', style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadAgents,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentsList(AppLocalizations? localizations, ThemeData theme, ColorScheme colorScheme) {
    final agents = _agentsData?['results'] as List<dynamic>? ?? [];
    final count = _agentsData?['count'] ?? 0;
    final next = _agentsData?['next'];
    final previous = _agentsData?['previous'];

    if (agents.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.badge_outlined, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No agents found', style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant)),
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
              Text('Total: $count agents', style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            ],
          ),
        ),
        // Agents List
        Expanded(
          child: ListView.builder(
            itemCount: agents.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final agent = agents[index];
              return _buildAgentCard(agent, colorScheme);
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
                          _loadAgents();
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
                          _loadAgents();
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

  Widget _buildAgentCard(Map<String, dynamic> agent, ColorScheme colorScheme) {
    final user = agent['user'] ?? {};
    final agencyName = agent['agency_name'] ?? 'No Agency';
    final username = user['username'] ?? 'Unknown';
    final rating = agent['rating'] ?? '0.0';
    final totalSales = agent['total_sales'] ?? 0;
    final yearsExperience = agent['years_experience'] ?? 0;
    final specialization = agent['specialization'] ?? 'N/A';
    final isVerified = agent['is_verified'] ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to agent detail/profile
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              agencyName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            if (isVerified) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.verified, color: Colors.blue, size: 18),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@$username',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.star,
                    label: rating,
                    color: Colors.amber,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.sell,
                    label: '$totalSales sales',
                    color: Colors.green,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.calendar_today,
                    label: '$yearsExperience years',
                    color: Colors.blue,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  specialization,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

