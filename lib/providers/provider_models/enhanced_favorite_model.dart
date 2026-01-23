/// Enhanced Favorite Model with price tracking and collections

class FavoriteItem {
  final int id;
  final String itemType; // product, service, property
  final int itemId;
  final String itemTitle;
  final String itemPrice;
  final String? itemImage;
  final String itemStatus;
  final String? note;
  final String priceAtFavorite;
  final String? currentPrice;
  final bool priceDropped;
  final bool notifyPriceDrop;
  final DateTime createdAt;

  FavoriteItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.itemTitle,
    required this.itemPrice,
    this.itemImage,
    required this.itemStatus,
    this.note,
    required this.priceAtFavorite,
    this.currentPrice,
    required this.priceDropped,
    required this.notifyPriceDrop,
    required this.createdAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'] ?? 0,
      itemType: json['item_type'] ?? 'product',
      itemId: json['item_id'] ?? 0,
      itemTitle: json['item_title'] ?? '',
      itemPrice: json['item_price'] ?? '0',
      itemImage: json['item_image'],
      itemStatus: json['item_status'] ?? 'active',
      note: json['note'],
      priceAtFavorite: json['price_at_favorite'] ?? '0',
      currentPrice: json['current_price'],
      priceDropped: json['price_dropped'] ?? false,
      notifyPriceDrop: json['notify_price_drop'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType,
      'item_id': itemId,
      'item_title': itemTitle,
      'item_price': itemPrice,
      'item_image': itemImage,
      'item_status': itemStatus,
      'note': note,
      'price_at_favorite': priceAtFavorite,
      'current_price': currentPrice,
      'price_dropped': priceDropped,
      'notify_price_drop': notifyPriceDrop,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get price drop percentage
  double? get priceDropPercentage {
    if (!priceDropped || currentPrice == null) return null;

    try {
      final originalPrice = double.parse(priceAtFavorite);
      final newPrice = double.parse(currentPrice!);
      if (originalPrice <= 0) return null;

      return ((originalPrice - newPrice) / originalPrice * 100);
    } catch (e) {
      return null;
    }
  }

  /// Get formatted price drop
  String? get formattedPriceDrop {
    final percentage = priceDropPercentage;
    if (percentage == null) return null;
    return '-${percentage.toStringAsFixed(0)}%';
  }
}

class FavoriteCollection {
  final int id;
  final String name;
  final String? description;
  final bool isPublic;
  final int itemsCount;
  final List<FavoriteItem>? items;
  final DateTime createdAt;

  FavoriteCollection({
    required this.id,
    required this.name,
    this.description,
    required this.isPublic,
    required this.itemsCount,
    this.items,
    required this.createdAt,
  });

  factory FavoriteCollection.fromJson(Map<String, dynamic> json) {
    return FavoriteCollection(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      isPublic: json['is_public'] ?? false,
      itemsCount: json['items_count'] ?? 0,
      items: json['items'] != null
          ? (json['items'] as List)
              .map((item) => FavoriteItem.fromJson(item))
              .toList()
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_public': isPublic,
      'items_count': itemsCount,
      'items': items?.map((item) => item.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class FavoritesCount {
  final int totalCount;
  final int productCount;
  final int serviceCount;
  final int propertyCount;

  FavoritesCount({
    required this.totalCount,
    required this.productCount,
    required this.serviceCount,
    required this.propertyCount,
  });

  factory FavoritesCount.fromJson(Map<String, dynamic> json) {
    final byType = json['by_type'] as Map<String, dynamic>? ?? {};
    return FavoritesCount(
      totalCount: json['total_count'] ?? 0,
      productCount: byType['product'] ?? 0,
      serviceCount: byType['service'] ?? 0,
      propertyCount: byType['property'] ?? 0,
    );
  }
}

class FavoriteCheckResult {
  final bool isFavorited;
  final int? favoriteId;

  FavoriteCheckResult({
    required this.isFavorited,
    this.favoriteId,
  });

  factory FavoriteCheckResult.fromJson(Map<String, dynamic> json) {
    return FavoriteCheckResult(
      isFavorited: json['is_favorited'] ?? false,
      favoriteId: json['favorite_id'],
    );
  }
}

/// Toggle favorite request
class ToggleFavoriteRequest {
  final String itemType;
  final int itemId;
  final String? note;
  final bool notifyPriceDrop;

  ToggleFavoriteRequest({
    required this.itemType,
    required this.itemId,
    this.note,
    this.notifyPriceDrop = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'item_id': itemId,
      if (note != null) 'note': note,
      'notify_price_drop': notifyPriceDrop,
    };
  }
}

/// Update favorite request
class UpdateFavoriteRequest {
  final String? note;
  final bool? notifyPriceDrop;

  UpdateFavoriteRequest({
    this.note,
    this.notifyPriceDrop,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (note != null) data['note'] = note;
    if (notifyPriceDrop != null) data['notify_price_drop'] = notifyPriceDrop;
    return data;
  }
}

/// Create collection request
class CreateCollectionRequest {
  final String name;
  final String? description;
  final bool isPublic;

  CreateCollectionRequest({
    required this.name,
    this.description,
    this.isPublic = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (description != null) 'description': description,
      'is_public': isPublic,
    };
  }
}
