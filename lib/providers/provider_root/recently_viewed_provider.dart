import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/recently_viewed_service.dart';
import '../provider_models/recently_viewed_model.dart';

// ==================== Recently Viewed State ====================

class RecentlyViewedState {
  final List<RecentlyViewedItem> items;
  final bool isLoading;
  final String? error;

  RecentlyViewedState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  RecentlyViewedState copyWith({
    List<RecentlyViewedItem>? items,
    bool? isLoading,
    String? error,
  }) {
    return RecentlyViewedState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  List<RecentlyViewedItem> get products =>
      items.where((i) => i.isProduct).toList();

  List<RecentlyViewedItem> get services =>
      items.where((i) => i.isService).toList();

  List<RecentlyViewedItem> get properties =>
      items.where((i) => i.isProperty).toList();

  int get count => items.length;
}

class RecentlyViewedNotifier extends StateNotifier<RecentlyViewedState> {
  final RecentlyViewedService _service;

  RecentlyViewedNotifier(this._service) : super(RecentlyViewedState());

  Future<void> fetchRecentlyViewed({int? limit, String? itemType}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _service.getRecentlyViewed(
        limit: limit,
        itemType: itemType,
      );
      state = state.copyWith(
        items: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> recordView({
    required String itemType,
    required int itemId,
  }) async {
    try {
      final success = await _service.recordView(
        itemType: itemType,
        itemId: itemId,
      );

      if (success) {
        // Re-viewing something already in the strip is the common case (the
        // PDP records a view on every open), and it only changes ordering --
        // so move it to the front locally instead of spending a second round
        // trip re-fetching a list we can already derive. A genuinely new item
        // still needs the server's payload (id, viewedAt, itemDetails), so
        // that path refetches as before.
        final existingIndex = state.items.indexWhere(
          (i) => i.itemType == itemType && i.itemId == itemId,
        );
        if (existingIndex >= 0) {
          final reordered = [...state.items];
          final moved = reordered.removeAt(existingIndex);
          reordered.insert(0, moved);
          state = state.copyWith(items: reordered);
        } else {
          await fetchRecentlyViewed();
        }
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearHistory() async {
    try {
      final success = await _service.clearHistory();

      if (success) {
        state = state.copyWith(items: []);
      }

      return success;
    } catch (e) {
      return false;
    }
  }
}

// ==================== Providers ====================

final recentlyViewedServiceProvider = Provider<RecentlyViewedService>((ref) {
  return RecentlyViewedService();
});

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, RecentlyViewedState>((ref) {
  final service = ref.watch(recentlyViewedServiceProvider);
  final notifier = RecentlyViewedNotifier(service);
  notifier.fetchRecentlyViewed();
  return notifier;
});

// Count provider
final recentlyViewedCountProvider = Provider<int>((ref) {
  return ref.watch(recentlyViewedProvider).count;
});
