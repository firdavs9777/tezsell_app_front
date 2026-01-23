import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/service/analytics_service.dart';
import 'package:app/providers/provider_models/analytics_model.dart';

/// Provider for the AnalyticsService instance
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

/// State class for seller analytics
class AnalyticsState {
  final SellerAnalytics? analytics;
  final Map<String, ListingAnalytics> listingAnalytics;
  final bool isLoading;
  final String? error;

  const AnalyticsState({
    this.analytics,
    this.listingAnalytics = const {},
    this.isLoading = false,
    this.error,
  });

  AnalyticsState copyWith({
    SellerAnalytics? analytics,
    Map<String, ListingAnalytics>? listingAnalytics,
    bool? isLoading,
    String? error,
  }) {
    return AnalyticsState(
      analytics: analytics ?? this.analytics,
      listingAnalytics: listingAnalytics ?? this.listingAnalytics,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// StateNotifier for managing analytics
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final AnalyticsService _service;

  AnalyticsNotifier(this._service) : super(const AnalyticsState());

  /// Load overall analytics
  Future<void> loadAnalytics() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final analytics = await _service.getOverallAnalytics();
      state = state.copyWith(
        analytics: analytics,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Load analytics for a specific listing
  Future<ListingAnalytics> loadListingAnalytics(String itemType, int itemId) async {
    final key = '${itemType}_$itemId';

    try {
      final analytics = await _service.getListingAnalytics(itemType, itemId);
      state = state.copyWith(
        listingAnalytics: {...state.listingAnalytics, key: analytics},
      );
      return analytics;
    } catch (e) {
      rethrow;
    }
  }

  /// Record a view
  Future<void> recordView(String itemType, int itemId) async {
    await _service.recordView(itemType, itemId);
  }

  /// Refresh analytics
  Future<void> refresh() async {
    await loadAnalytics();
  }

  /// Get cached listing analytics
  ListingAnalytics? getListingAnalytics(String itemType, int itemId) {
    return state.listingAnalytics['${itemType}_$itemId'];
  }
}

/// Provider for analytics state
final analyticsProvider = StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final service = ref.watch(analyticsServiceProvider);
  return AnalyticsNotifier(service);
});

/// Provider for overall seller analytics
final sellerAnalyticsProvider = FutureProvider<SellerAnalytics>((ref) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getOverallAnalytics();
});

/// Provider for listing-specific analytics
final listingAnalyticsProvider =
    FutureProvider.family<ListingAnalytics, ({String itemType, int itemId})>((ref, params) async {
  final service = ref.watch(analyticsServiceProvider);
  return service.getListingAnalytics(params.itemType, params.itemId);
});
