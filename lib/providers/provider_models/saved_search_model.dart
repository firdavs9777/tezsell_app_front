/// Saved Search Model
class SavedSearch {
  final int id;
  final String query;
  final String? name;
  final String displayName;
  final String? itemType;
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;
  final int useCount;
  final DateTime? lastUsed;
  final DateTime createdAt;

  SavedSearch({
    required this.id,
    required this.query,
    this.name,
    required this.displayName,
    this.itemType,
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.useCount = 0,
    this.lastUsed,
    required this.createdAt,
  });

  factory SavedSearch.fromJson(Map<String, dynamic> json) {
    return SavedSearch(
      id: json['id'] ?? 0,
      query: json['query'] ?? '',
      name: json['name'],
      displayName: json['display_name'] ?? json['name'] ?? json['query'] ?? '',
      itemType: json['item_type'],
      categoryId: json['category_id'],
      region: json['region'],
      district: json['district'],
      minPrice: json['min_price']?.toString(),
      maxPrice: json['max_price']?.toString(),
      useCount: json['use_count'] ?? 0,
      lastUsed: json['last_used'] != null
          ? DateTime.parse(json['last_used'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'name': name,
      'display_name': displayName,
      'item_type': itemType,
      'category_id': categoryId,
      'region': region,
      'district': district,
      'min_price': minPrice,
      'max_price': maxPrice,
      'use_count': useCount,
      'last_used': lastUsed?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  SavedSearch copyWith({
    int? id,
    String? query,
    String? name,
    String? displayName,
    String? itemType,
    int? categoryId,
    String? region,
    String? district,
    String? minPrice,
    String? maxPrice,
    int? useCount,
    DateTime? lastUsed,
    DateTime? createdAt,
  }) {
    return SavedSearch(
      id: id ?? this.id,
      query: query ?? this.query,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      itemType: itemType ?? this.itemType,
      categoryId: categoryId ?? this.categoryId,
      region: region ?? this.region,
      district: district ?? this.district,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      useCount: useCount ?? this.useCount,
      lastUsed: lastUsed ?? this.lastUsed,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  bool get hasFilters =>
      itemType != null ||
      categoryId != null ||
      region != null ||
      district != null ||
      minPrice != null ||
      maxPrice != null;

  String get filtersDescription {
    final parts = <String>[];
    if (itemType != null) parts.add(itemType!);
    if (region != null) parts.add(region!);
    if (minPrice != null || maxPrice != null) {
      if (minPrice != null && maxPrice != null) {
        parts.add('$minPrice - $maxPrice');
      } else if (minPrice != null) {
        parts.add('from $minPrice');
      } else {
        parts.add('up to $maxPrice');
      }
    }
    return parts.join(' | ');
  }
}

/// Request model for creating a saved search
class CreateSavedSearchRequest {
  final String query;
  final String? name;
  final String? itemType;
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;

  CreateSavedSearchRequest({
    required this.query,
    this.name,
    this.itemType,
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'query': query,
      if (name != null) 'name': name,
      if (itemType != null) 'item_type': itemType,
      if (categoryId != null) 'category_id': categoryId,
      if (region != null) 'region': region,
      if (district != null) 'district': district,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
    };
  }
}

/// Request model for updating a saved search
class UpdateSavedSearchRequest {
  final String? name;
  final String? query;
  final String? itemType;
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;

  UpdateSavedSearchRequest({
    this.name,
    this.query,
    this.itemType,
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (query != null) 'query': query,
      if (itemType != null) 'item_type': itemType,
      if (categoryId != null) 'category_id': categoryId,
      if (region != null) 'region': region,
      if (district != null) 'district': district,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
    };
  }
}
