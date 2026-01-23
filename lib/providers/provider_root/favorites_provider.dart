import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/favorites_service.dart';
import '../provider_models/enhanced_favorite_model.dart';

// ==================== Favorites State ====================

class FavoritesState {
  final List<FavoriteItem> favorites;
  final FavoritesCount count;
  final bool isLoading;
  final String? error;
  final String? filterType; // 'product', 'service', 'property', or null for all

  FavoritesState({
    this.favorites = const [],
    FavoritesCount? count,
    this.isLoading = false,
    this.error,
    this.filterType,
  }) : count = count ?? FavoritesCount(
          totalCount: 0,
          productCount: 0,
          serviceCount: 0,
          propertyCount: 0,
        );

  FavoritesState copyWith({
    List<FavoriteItem>? favorites,
    FavoritesCount? count,
    bool? isLoading,
    String? error,
    String? filterType,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filterType: filterType ?? this.filterType,
    );
  }

  List<FavoriteItem> get filteredFavorites {
    if (filterType == null) return favorites;
    return favorites.where((f) => f.itemType == filterType).toList();
  }

  List<FavoriteItem> get priceDroppedItems =>
      favorites.where((f) => f.hasPriceDropped).toList();

  bool isFavorited(String itemType, int itemId) {
    return favorites.any((f) => f.itemType == itemType && f.itemId == itemId);
  }
}

class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesService _service;

  FavoritesNotifier(this._service) : super(FavoritesState());

  Future<void> fetchFavorites({String? itemType, int page = 1}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final favorites = await _service.getFavorites(
        itemType: itemType,
        page: page,
      );
      state = state.copyWith(
        favorites: page == 1 ? favorites : [...state.favorites, ...favorites],
        isLoading: false,
        filterType: itemType,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> fetchCount() async {
    try {
      final count = await _service.getFavoritesCount();
      state = state.copyWith(count: count);
    } catch (e) {
      // Silently fail
    }
  }

  Future<Map<String, dynamic>> toggleFavorite({
    required String itemType,
    required int itemId,
    String? note,
    bool notifyPriceDrop = false,
  }) async {
    try {
      final result = await _service.toggleFavorite(
        itemType: itemType,
        itemId: itemId,
        note: note,
        notifyPriceDrop: notifyPriceDrop,
      );

      if (result['success'] == true) {
        if (result['action'] == 'added' && result['data'] != null) {
          state = state.copyWith(
            favorites: [result['data'] as FavoriteItem, ...state.favorites],
          );
        } else if (result['action'] == 'removed') {
          state = state.copyWith(
            favorites: state.favorites
                .where((f) => !(f.itemType == itemType && f.itemId == itemId))
                .toList(),
          );
        }
        await fetchCount();
      }

      return result;
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<FavoriteCheckResult> checkFavorite({
    required String itemType,
    required int itemId,
  }) async {
    return _service.checkFavorite(itemType: itemType, itemId: itemId);
  }

  Future<FavoriteItem?> updateFavorite({
    required int favoriteId,
    String? note,
    bool? notifyPriceDrop,
  }) async {
    try {
      final updated = await _service.updateFavorite(
        favoriteId: favoriteId,
        note: note,
        notifyPriceDrop: notifyPriceDrop,
      );

      if (updated != null) {
        state = state.copyWith(
          favorites: state.favorites.map((f) {
            return f.id == favoriteId ? updated : f;
          }).toList(),
        );
      }

      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> deleteFavorite(int favoriteId) async {
    try {
      final success = await _service.deleteFavorite(favoriteId);

      if (success) {
        state = state.copyWith(
          favorites: state.favorites.where((f) => f.id != favoriteId).toList(),
        );
        await fetchCount();
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  void setFilter(String? itemType) {
    state = state.copyWith(filterType: itemType);
  }

  void clearFilter() {
    state = state.copyWith(filterType: null);
  }
}

// ==================== Collections State ====================

class CollectionsState {
  final List<FavoriteCollection> collections;
  final bool isLoading;
  final String? error;

  CollectionsState({
    this.collections = const [],
    this.isLoading = false,
    this.error,
  });

  CollectionsState copyWith({
    List<FavoriteCollection>? collections,
    bool? isLoading,
    String? error,
  }) {
    return CollectionsState(
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CollectionsNotifier extends StateNotifier<CollectionsState> {
  final FavoritesService _service;

  CollectionsNotifier(this._service) : super(CollectionsState());

  Future<void> fetchCollections() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final collections = await _service.getCollections();
      state = state.copyWith(
        collections: collections,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<FavoriteCollection?> createCollection({
    required String name,
    String? description,
    bool isPublic = false,
  }) async {
    try {
      final collection = await _service.createCollection(
        name: name,
        description: description,
        isPublic: isPublic,
      );

      if (collection != null) {
        state = state.copyWith(
          collections: [collection, ...state.collections],
        );
      }

      return collection;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<FavoriteCollection?> updateCollection({
    required int collectionId,
    String? name,
    String? description,
    bool? isPublic,
  }) async {
    try {
      final updated = await _service.updateCollection(
        collectionId: collectionId,
        name: name,
        description: description,
        isPublic: isPublic,
      );

      if (updated != null) {
        state = state.copyWith(
          collections: state.collections.map((c) {
            return c.id == collectionId ? updated : c;
          }).toList(),
        );
      }

      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> deleteCollection(int collectionId) async {
    try {
      final success = await _service.deleteCollection(collectionId);

      if (success) {
        state = state.copyWith(
          collections: state.collections.where((c) => c.id != collectionId).toList(),
        );
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addToCollection({
    required int collectionId,
    required int favoriteId,
  }) async {
    try {
      return await _service.addToCollection(
        collectionId: collectionId,
        favoriteId: favoriteId,
      );
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFromCollection({
    required int collectionId,
    required int favoriteId,
  }) async {
    try {
      return await _service.removeFromCollection(
        collectionId: collectionId,
        favoriteId: favoriteId,
      );
    } catch (e) {
      return false;
    }
  }

  Future<List<FavoriteItem>> getCollectionItems(int collectionId) async {
    return _service.getCollectionItems(collectionId);
  }
}

// ==================== Providers ====================

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  return FavoritesService();
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  final notifier = FavoritesNotifier(service);
  // Auto-fetch on initialization
  notifier.fetchFavorites();
  notifier.fetchCount();
  return notifier;
});

final collectionsProvider =
    StateNotifierProvider<CollectionsNotifier, CollectionsState>((ref) {
  final service = ref.watch(favoritesServiceProvider);
  final notifier = CollectionsNotifier(service);
  notifier.fetchCollections();
  return notifier;
});

// Simple providers for quick checks
final isFavoritedProvider =
    FutureProvider.family<FavoriteCheckResult, ({String itemType, int itemId})>(
        (ref, params) async {
  final service = ref.watch(favoritesServiceProvider);
  return service.checkFavorite(
    itemType: params.itemType,
    itemId: params.itemId,
  );
});

final favoritesCountProvider = FutureProvider<FavoritesCount>((ref) async {
  final service = ref.watch(favoritesServiceProvider);
  return service.getFavoritesCount();
});

// Collection items provider
final collectionItemsProvider =
    FutureProvider.family<List<FavoriteItem>, int>((ref, collectionId) async {
  final service = ref.watch(favoritesServiceProvider);
  return service.getCollectionItems(collectionId);
});
