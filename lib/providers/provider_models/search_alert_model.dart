/// Search Alert Model for saved search notifications

class SearchAlert {
  final int id;
  final String keyword;
  final String itemType; // product, service, property, all
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;
  final bool isActive;
  final bool notifyPush;
  final bool notifyEmail;
  final int matchesFound;
  final DateTime? lastChecked;
  final DateTime? lastNotified;
  final DateTime createdAt;

  SearchAlert({
    required this.id,
    required this.keyword,
    required this.itemType,
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
    required this.isActive,
    required this.notifyPush,
    required this.notifyEmail,
    required this.matchesFound,
    this.lastChecked,
    this.lastNotified,
    required this.createdAt,
  });

  factory SearchAlert.fromJson(Map<String, dynamic> json) {
    return SearchAlert(
      id: json['id'] ?? 0,
      keyword: json['keyword'] ?? '',
      itemType: json['item_type'] ?? 'all',
      categoryId: json['category_id'],
      region: json['region'],
      district: json['district'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      isActive: json['is_active'] ?? true,
      notifyPush: json['notify_push'] ?? true,
      notifyEmail: json['notify_email'] ?? false,
      matchesFound: json['matches_found'] ?? 0,
      lastChecked: json['last_checked'] != null
          ? DateTime.tryParse(json['last_checked'])
          : null,
      lastNotified: json['last_notified'] != null
          ? DateTime.tryParse(json['last_notified'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keyword': keyword,
      'item_type': itemType,
      'category_id': categoryId,
      'region': region,
      'district': district,
      'min_price': minPrice,
      'max_price': maxPrice,
      'is_active': isActive,
      'notify_push': notifyPush,
      'notify_email': notifyEmail,
      'matches_found': matchesFound,
      'last_checked': lastChecked?.toIso8601String(),
      'last_notified': lastNotified?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Get item type display name
  String get itemTypeDisplay {
    switch (itemType) {
      case 'product':
        return 'Products';
      case 'service':
        return 'Services';
      case 'property':
        return 'Real Estate';
      case 'all':
      default:
        return 'All';
    }
  }

  /// Get filter summary
  String get filterSummary {
    final parts = <String>[];

    if (region != null && region!.isNotEmpty) {
      parts.add(region!);
    }
    if (district != null && district!.isNotEmpty) {
      parts.add(district!);
    }
    if (minPrice != null || maxPrice != null) {
      if (minPrice != null && maxPrice != null) {
        parts.add('$minPrice - $maxPrice');
      } else if (minPrice != null) {
        parts.add('From $minPrice');
      } else {
        parts.add('Up to $maxPrice');
      }
    }

    return parts.isEmpty ? 'No filters' : parts.join(' • ');
  }

  /// Check if alert has location filter
  bool get hasLocationFilter =>
      (region != null && region!.isNotEmpty) ||
      (district != null && district!.isNotEmpty);

  /// Check if alert has price filter
  bool get hasPriceFilter => minPrice != null || maxPrice != null;
}

/// Create search alert request
class CreateSearchAlertRequest {
  final String keyword;
  final String itemType;
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;
  final bool notifyPush;
  final bool notifyEmail;

  CreateSearchAlertRequest({
    required this.keyword,
    this.itemType = 'all',
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.notifyPush = true,
    this.notifyEmail = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'item_type': itemType,
      if (categoryId != null) 'category_id': categoryId,
      if (region != null) 'region': region,
      if (district != null) 'district': district,
      if (minPrice != null) 'min_price': minPrice,
      if (maxPrice != null) 'max_price': maxPrice,
      'notify_push': notifyPush,
      'notify_email': notifyEmail,
    };
  }
}

/// Update search alert request
class UpdateSearchAlertRequest {
  final String? keyword;
  final String? itemType;
  final int? categoryId;
  final String? region;
  final String? district;
  final String? minPrice;
  final String? maxPrice;
  final bool? notifyPush;
  final bool? notifyEmail;

  UpdateSearchAlertRequest({
    this.keyword,
    this.itemType,
    this.categoryId,
    this.region,
    this.district,
    this.minPrice,
    this.maxPrice,
    this.notifyPush,
    this.notifyEmail,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (keyword != null) data['keyword'] = keyword;
    if (itemType != null) data['item_type'] = itemType;
    if (categoryId != null) data['category_id'] = categoryId;
    if (region != null) data['region'] = region;
    if (district != null) data['district'] = district;
    if (minPrice != null) data['min_price'] = minPrice;
    if (maxPrice != null) data['max_price'] = maxPrice;
    if (notifyPush != null) data['notify_push'] = notifyPush;
    if (notifyEmail != null) data['notify_email'] = notifyEmail;
    return data;
  }
}

/// Alert item type enum
enum AlertItemType {
  all,
  product,
  service,
  property,
}

extension AlertItemTypeExtension on AlertItemType {
  String get value {
    switch (this) {
      case AlertItemType.all:
        return 'all';
      case AlertItemType.product:
        return 'product';
      case AlertItemType.service:
        return 'service';
      case AlertItemType.property:
        return 'property';
    }
  }

  String get displayName {
    switch (this) {
      case AlertItemType.all:
        return 'All';
      case AlertItemType.product:
        return 'Products';
      case AlertItemType.service:
        return 'Services';
      case AlertItemType.property:
        return 'Real Estate';
    }
  }

  String get displayNameUz {
    switch (this) {
      case AlertItemType.all:
        return 'Hammasi';
      case AlertItemType.product:
        return 'Mahsulotlar';
      case AlertItemType.service:
        return 'Xizmatlar';
      case AlertItemType.property:
        return 'Ko\'chmas mulk';
    }
  }

  static AlertItemType fromString(String value) {
    return AlertItemType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertItemType.all,
    );
  }
}
