import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/admin_provider.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/app_logger.dart';

class AdminReportsPage extends ConsumerStatefulWidget {
  const AdminReportsPage({super.key});

  @override
  ConsumerState<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends ConsumerState<AdminReportsPage> {
  Map<String, dynamic>? _reportsData;
  bool _isLoading = true;
  String? _error;
  int _currentPage = 1;
  String? _selectedStatus;
  String? _selectedContentType;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _statusOptions = ['pending', 'reviewed', 'resolved', 'dismissed'];
  final List<String> _contentTypeOptions = ['product', 'service', 'property', 'message', 'user'];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final adminService = ref.read(adminServiceProvider);
      final data = await adminService.getReports(
        status: _selectedStatus,
        contentType: _selectedContentType,
        page: _currentPage,
        pageSize: 20,
      );
      setState(() {
        _reportsData = data;
        _isLoading = false;
      });
    } catch (e) {
      AppLogger.error('Error loading reports: $e');
      
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

  Future<void> _updateReportStatus(int reportId, String status, {String? action, String? reason}) async {
    try {
      final adminService = ref.read(adminServiceProvider);
      await adminService.updateReportStatus(
        reportId: reportId,
        status: status,
        action: action,
        reason: reason,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report $status successfully')),
        );
        _loadReports();
      }
    } catch (e) {
      AppErrorHandler.showError(context, e);
    }
  }

  void _showReportActions(int reportId, String currentStatus) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _ReportActionsSheet(
        reportId: reportId,
        currentStatus: currentStatus,
        onAction: (status, action, reason) {
          _updateReportStatus(reportId, status, action: action, reason: reason);
        },
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
        title: const Text('Reports Management', style: TextStyle(fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReports,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          _buildFilters(localizations, colorScheme),
          // Reports List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState(localizations, colorScheme)
                    : _buildReportsList(localizations, theme, colorScheme),
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
          // Status Filter
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                  ),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All Status')),
                    ..._statusOptions.map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status.toUpperCase()),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                      _currentPage = 1;
                    });
                    _loadReports();
                  },
                ),
              ),
              const SizedBox(width: 12),
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
                    _loadReports();
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
                  : 'Error loading reports',
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
                  ? 'The admin reports API endpoint needs to be implemented on the backend.\n\n'
                      'Please implement: GET /api/admin/reports/\n\n'
                      'This endpoint should support filtering by status and content type.'
                  : _error ?? '',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadReports,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportsList(AppLocalizations? localizations, ThemeData theme, ColorScheme colorScheme) {
    final reports = _reportsData?['results'] as List<dynamic>? ?? [];
    final count = _reportsData?['count'] ?? 0;
    final next = _reportsData?['next'];
    final previous = _reportsData?['previous'];

    if (reports.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.flag_outlined, size: 64, color: colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            Text('No reports found', style: TextStyle(fontSize: 18, color: colorScheme.onSurfaceVariant)),
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
              Text('Total: $count reports', style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface)),
            ],
          ),
        ),
        // Reports List
        Expanded(
          child: ListView.builder(
            itemCount: reports.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final report = reports[index];
              return _buildReportCard(report, colorScheme);
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
                          _loadReports();
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
                          _loadReports();
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

  Widget _buildReportCard(Map<String, dynamic> report, ColorScheme colorScheme) {
    final status = report['status'] ?? 'pending';
    final contentType = report['content_type'] ?? 'unknown';
    final reason = report['reason'] ?? 'unknown';
    final description = report['description'] ?? '';
    final createdAt = report['created_at'] ?? '';
    final reporter = report['reporter'] ?? {};
    final reporterName = reporter['username'] ?? 'Unknown';

    Color statusColor;
    switch (status) {
      case 'pending':
        statusColor = Colors.orange;
        break;
      case 'reviewed':
        statusColor = Colors.blue;
        break;
      case 'resolved':
        statusColor = Colors.green;
        break;
      case 'dismissed':
        statusColor = Colors.grey;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showReportActions(report['id'], status),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      contentType.toUpperCase(),
                      style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Reason: $reason',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'By: $reporterName',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    createdAt.isNotEmpty ? createdAt.split('T')[0] : '',
                    style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _showReportActions(report['id'], status),
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

class _ReportActionsSheet extends StatefulWidget {
  final int reportId;
  final String currentStatus;
  final Function(String status, String? action, String? reason) onAction;

  const _ReportActionsSheet({
    required this.reportId,
    required this.currentStatus,
    required this.onAction,
  });

  @override
  State<_ReportActionsSheet> createState() => _ReportActionsSheetState();
}

class _ReportActionsSheetState extends State<_ReportActionsSheet> {
  final TextEditingController _reasonController = TextEditingController();
  String? _selectedAction;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Report Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _selectedAction,
            decoration: InputDecoration(
              labelText: 'Action',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: const [
              DropdownMenuItem(value: 'review', child: Text('Mark as Reviewed')),
              DropdownMenuItem(value: 'resolve', child: Text('Resolve')),
              DropdownMenuItem(value: 'dismiss', child: Text('Dismiss')),
              DropdownMenuItem(value: 'remove_content', child: Text('Remove Content')),
              DropdownMenuItem(value: 'suspend_user', child: Text('Suspend User')),
            ],
            onChanged: (value) => setState(() => _selectedAction = value),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: 'Reason (optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _selectedAction != null
                    ? () {
                        String status = widget.currentStatus;
                        if (_selectedAction == 'review') status = 'reviewed';
                        if (_selectedAction == 'resolve') status = 'resolved';
                        if (_selectedAction == 'dismiss') status = 'dismissed';

                        widget.onAction(status, _selectedAction, _reasonController.text);
                        Navigator.pop(context);
                      }
                    : null,
                child: const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

