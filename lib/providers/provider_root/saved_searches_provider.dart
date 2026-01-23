import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/saved_searches_service.dart';
import '../provider_models/saved_search_model.dart';

// ==================== Saved Searches State ====================

class SavedSearchesState {
  final List<SavedSearch> searches;
  final bool isLoading;
  final String? error;

  SavedSearchesState({
    this.searches = const [],
    this.isLoading = false,
    this.error,
  });

  SavedSearchesState copyWith({
    List<SavedSearch>? searches,
    bool? isLoading,
    String? error,
  }) {
    return SavedSearchesState(
      searches: searches ?? this.searches,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  int get count => searches.length;

  List<SavedSearch> get recentlyUsed {
    final sorted = [...searches];
    sorted.sort((a, b) {
      if (a.lastUsed == null && b.lastUsed == null) return 0;
      if (a.lastUsed == null) return 1;
      if (b.lastUsed == null) return -1;
      return b.lastUsed!.compareTo(a.lastUsed!);
    });
    return sorted;
  }

  List<SavedSearch> get mostUsed {
    final sorted = [...searches];
    sorted.sort((a, b) => b.useCount.compareTo(a.useCount));
    return sorted;
  }
}

class SavedSearchesNotifier extends StateNotifier<SavedSearchesState> {
  final SavedSearchesService _service;

  SavedSearchesNotifier(this._service) : super(SavedSearchesState());

  Future<void> fetchSavedSearches() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final searches = await _service.getSavedSearches();
      state = state.copyWith(
        searches: searches,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<SavedSearch?> createSavedSearch({
    required String query,
    String? name,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
  }) async {
    try {
      final search = await _service.createSavedSearch(
        query: query,
        name: name,
        itemType: itemType,
        categoryId: categoryId,
        region: region,
        district: district,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      if (search != null) {
        state = state.copyWith(
          searches: [search, ...state.searches],
        );
      }

      return search;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<SavedSearch?> useSavedSearch(int searchId) async {
    try {
      final search = await _service.useSavedSearch(searchId);

      if (search != null) {
        // Update the search in the list with new use count
        state = state.copyWith(
          searches: state.searches.map((s) {
            return s.id == searchId ? search : s;
          }).toList(),
        );
      }

      return search;
    } catch (e) {
      return null;
    }
  }

  Future<SavedSearch?> updateSavedSearch({
    required int searchId,
    String? name,
    String? query,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
  }) async {
    try {
      final updated = await _service.updateSavedSearch(
        searchId: searchId,
        name: name,
        query: query,
        itemType: itemType,
        categoryId: categoryId,
        region: region,
        district: district,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );

      if (updated != null) {
        state = state.copyWith(
          searches: state.searches.map((s) {
            return s.id == searchId ? updated : s;
          }).toList(),
        );
      }

      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> deleteSavedSearch(int searchId) async {
    try {
      final success = await _service.deleteSavedSearch(searchId);

      if (success) {
        state = state.copyWith(
          searches: state.searches.where((s) => s.id != searchId).toList(),
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

final savedSearchesServiceProvider = Provider<SavedSearchesService>((ref) {
  return SavedSearchesService();
});

final savedSearchesProvider =
    StateNotifierProvider<SavedSearchesNotifier, SavedSearchesState>((ref) {
  final service = ref.watch(savedSearchesServiceProvider);
  final notifier = SavedSearchesNotifier(service);
  notifier.fetchSavedSearches();
  return notifier;
});

// Count provider
final savedSearchesCountProvider = Provider<int>((ref) {
  return ref.watch(savedSearchesProvider).count;
});

// Single search provider
final savedSearchProvider =
    FutureProvider.family<SavedSearch?, int>((ref, searchId) async {
  final service = ref.watch(savedSearchesServiceProvider);
  return service.useSavedSearch(searchId);
});
