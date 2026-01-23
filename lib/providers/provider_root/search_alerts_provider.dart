import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/search_alerts_service.dart';
import '../provider_models/search_alert_model.dart';

// ==================== Search Alerts State ====================

class SearchAlertsState {
  final List<SearchAlert> alerts;
  final bool isLoading;
  final String? error;

  SearchAlertsState({
    this.alerts = const [],
    this.isLoading = false,
    this.error,
  });

  SearchAlertsState copyWith({
    List<SearchAlert>? alerts,
    bool? isLoading,
    String? error,
  }) {
    return SearchAlertsState(
      alerts: alerts ?? this.alerts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get totalCount => alerts.length;
  int get activeCount => alerts.where((a) => a.isActive).length;
  List<SearchAlert> get activeAlerts => alerts.where((a) => a.isActive).toList();
  List<SearchAlert> get inactiveAlerts => alerts.where((a) => !a.isActive).toList();
}

class SearchAlertsNotifier extends StateNotifier<SearchAlertsState> {
  final SearchAlertsService _service;

  SearchAlertsNotifier(this._service) : super(SearchAlertsState());

  Future<void> fetchAlerts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final alerts = await _service.getAlerts();
      state = state.copyWith(
        alerts: alerts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<SearchAlert?> createAlert({
    required String keyword,
    String itemType = 'all',
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
    bool notifyPush = true,
    bool notifyEmail = false,
  }) async {
    try {
      final alert = await _service.createAlert(
        keyword: keyword,
        itemType: itemType,
        categoryId: categoryId,
        region: region,
        district: district,
        minPrice: minPrice,
        maxPrice: maxPrice,
        notifyPush: notifyPush,
        notifyEmail: notifyEmail,
      );

      if (alert != null) {
        state = state.copyWith(
          alerts: [alert, ...state.alerts],
        );
      }

      return alert;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<SearchAlert?> updateAlert({
    required int alertId,
    String? keyword,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
    bool? notifyPush,
    bool? notifyEmail,
  }) async {
    try {
      final updated = await _service.updateAlert(
        alertId: alertId,
        keyword: keyword,
        itemType: itemType,
        categoryId: categoryId,
        region: region,
        district: district,
        minPrice: minPrice,
        maxPrice: maxPrice,
        notifyPush: notifyPush,
        notifyEmail: notifyEmail,
      );

      if (updated != null) {
        state = state.copyWith(
          alerts: state.alerts.map((a) {
            return a.id == alertId ? updated : a;
          }).toList(),
        );
      }

      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> toggleAlert(int alertId) async {
    try {
      final result = await _service.toggleAlert(alertId);

      if (result['success'] == true) {
        state = state.copyWith(
          alerts: state.alerts.map((a) {
            if (a.id == alertId) {
              return a.copyWith(isActive: result['isActive'] as bool?);
            }
            return a;
          }).toList(),
        );
        return true;
      }

      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> deleteAlert(int alertId) async {
    try {
      final success = await _service.deleteAlert(alertId);

      if (success) {
        state = state.copyWith(
          alerts: state.alerts.where((a) => a.id != alertId).toList(),
        );
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ==================== Providers ====================

final searchAlertsServiceProvider = Provider<SearchAlertsService>((ref) {
  return SearchAlertsService();
});

final searchAlertsProvider =
    StateNotifierProvider<SearchAlertsNotifier, SearchAlertsState>((ref) {
  final service = ref.watch(searchAlertsServiceProvider);
  final notifier = SearchAlertsNotifier(service);
  notifier.fetchAlerts();
  return notifier;
});

// Count providers for quick access
final alertsCountProvider = Provider<int>((ref) {
  final state = ref.watch(searchAlertsProvider);
  return state.totalCount;
});

final activeAlertsCountProvider = Provider<int>((ref) {
  final state = ref.watch(searchAlertsProvider);
  return state.activeCount;
});

// Single alert provider
final alertProvider =
    FutureProvider.family<SearchAlert?, int>((ref, alertId) async {
  final service = ref.watch(searchAlertsServiceProvider);
  return service.getAlert(alertId);
});
