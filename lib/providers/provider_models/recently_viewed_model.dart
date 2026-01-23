/// Recently Viewed Item Model
class RecentlyViewedItem {
  final int id;
  final String itemType;
  final int itemId;
  final RecentItemDetails? itemDetails;
  final DateTime viewedAt;

  RecentlyViewedItem({
    required this.id,
    required this.itemType,
    required this.itemId,
    this.itemDetails,
    required this.viewedAt,
  });

  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyViewedItem(
      id: json['id'] ?? 0,
      itemType: json['item_type'] ?? '',
      itemId: json['item_id'] ?? 0,
      itemDetails: json['item_details'] != null
          ? RecentItemDetails.fromJson(json['item_details'])
          : null,
      viewedAt: json['viewed_at'] != null
          ? DateTime.parse(json['viewed_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType,
      'item_id': itemId,
      'item_details': itemDetails?.toJson(),
      'viewed_at': viewedAt.toIso8601String(),
    };
  }

  bool get isProduct => itemType == 'product';
  bool get isService => itemType == 'service';
  bool get isProperty => itemType == 'property';
}

class RecentItemDetails {
  final int id;
  final String title;
  final String price;
  final bool isActive;
  final String? image;
  final ItemLocation? location;

  RecentItemDetails({
    required this.id,
    required this.title,
    required this.price,
    this.isActive = true,
    this.image,
    this.location,
  });

  factory RecentItemDetails.fromJson(Map<String, dynamic> json) {
    return RecentItemDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '0',
      isActive: json['is_active'] ?? true,
      image: json['image'],
      location: json['location'] != null
          ? ItemLocation.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'is_active': isActive,
      'image': image,
      'location': location?.toJson(),
    };
  }
}

class ItemLocation {
  final String? region;
  final String? district;

  ItemLocation({this.region, this.district});

  factory ItemLocation.fromJson(Map<String, dynamic> json) {
    return ItemLocation(
      region: json['region'],
      district: json['district'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'region': region,
      'district': district,
    };
  }

  String get displayName {
    if (region != null && district != null) {
      return '$region, $district';
    }
    return region ?? district ?? '';
  }
}

/// Request model for recording a view
class RecordViewRequest {
  final String itemType;
  final int itemId;

  RecordViewRequest({
    required this.itemType,
    required this.itemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'item_id': itemId,
    };
  }
}
