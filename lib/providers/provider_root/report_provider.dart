import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/service/report_service.dart';
import 'package:app/providers/provider_models/report_model.dart';

/// Provider for the ReportService instance
final reportServiceProvider = Provider<ReportService>((ref) {
  return ReportService();
});

/// State class for reports
class ReportsState {
  final List<Report> reports;
  final bool isLoading;
  final bool isSubmitting;
  final String? error;

  const ReportsState({
    this.reports = const [],
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
  });

  ReportsState copyWith({
    List<Report>? reports,
    bool? isLoading,
    bool? isSubmitting,
    String? error,
  }) {
    return ReportsState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  /// Get pending reports
  List<Report> get pendingReports =>
      reports.where((r) => r.status == ReportStatus.pending).toList();

  /// Get resolved reports
  List<Report> get resolvedReports =>
      reports.where((r) => r.isResolved).toList();
}

/// StateNotifier for managing reports
class ReportsNotifier extends StateNotifier<ReportsState> {
  final ReportService _service;

  ReportsNotifier(this._service) : super(const ReportsState());

  /// Load user's reports
  Future<void> loadReports() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final reports = await _service.getMyReports();
      state = state.copyWith(
        reports: reports,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Submit a new report
  Future<Report> submitReport(SubmitReportRequest request) async {
    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final report = await _service.submitReport(request);
      await loadReports(); // Refresh the list
      state = state.copyWith(isSubmitting: false);
      return report;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  /// Get report status
  Future<Report> getReportStatus(int reportId) async {
    return _service.getReportStatus(reportId);
  }

  /// Refresh reports
  Future<void> refresh() async {
    await loadReports();
  }
}

/// Provider for reports state
final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  final service = ref.watch(reportServiceProvider);
  return ReportsNotifier(service);
});

/// Provider for a specific report status
final reportStatusProvider = FutureProvider.family<Report, int>((ref, reportId) async {
  final service = ref.watch(reportServiceProvider);
  return service.getReportStatus(reportId);
});
