/// Offer/Negotiation Model for price negotiations between buyers and sellers
/// Allows buyers to make offers, sellers can accept/counter/decline

enum OfferStatus {
  pending,
  accepted,
  declined,
  countered,
  cancelled,
  expired;

  static OfferStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return OfferStatus.accepted;
      case 'declined':
        return OfferStatus.declined;
      case 'countered':
        return OfferStatus.countered;
      case 'cancelled':
        return OfferStatus.cancelled;
      case 'expired':
        return OfferStatus.expired;
      default:
        return OfferStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case OfferStatus.pending:
        return 'Pending';
      case OfferStatus.accepted:
        return 'Accepted';
      case OfferStatus.declined:
        return 'Declined';
      case OfferStatus.countered:
        return 'Counter Offer';
      case OfferStatus.cancelled:
        return 'Cancelled';
      case OfferStatus.expired:
        return 'Expired';
    }
  }

  /// Color code for status (as hex int)
  int get colorCode {
    switch (this) {
      case OfferStatus.pending:
        return 0xFFFFC107; // Yellow/Amber
      case OfferStatus.accepted:
        return 0xFF4CAF50; // Green
      case OfferStatus.declined:
        return 0xFFF44336; // Red
      case OfferStatus.countered:
        return 0xFF2196F3; // Blue
      case OfferStatus.cancelled:
        return 0xFF9E9E9E; // Gray
      case OfferStatus.expired:
        return 0xFF9E9E9E; // Gray
    }
  }

  bool get isActive => this == OfferStatus.pending || this == OfferStatus.countered;
}

class Offer {
  final int id;
  final int buyerId;
  final String buyerName;
  final String? buyerAvatar;
  final int sellerId;
  final String sellerName;
  final String? sellerAvatar;
  final String itemType; // 'product' or 'service'
  final int itemId;
  final String itemTitle;
  final String? itemImage;
  final double offerAmount;
  final double originalPrice;
  final double discountPercent;
  final String? message;
  final double? counterAmount;
  final String? counterMessage;
  final OfferStatus status;
  final String? declineReason;
  final bool isExpired;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? respondedAt;

  const Offer({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    this.buyerAvatar,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    required this.itemType,
    required this.itemId,
    required this.itemTitle,
    this.itemImage,
    required this.offerAmount,
    required this.originalPrice,
    required this.discountPercent,
    this.message,
    this.counterAmount,
    this.counterMessage,
    required this.status,
    this.declineReason,
    required this.isExpired,
    required this.createdAt,
    required this.expiresAt,
    this.respondedAt,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] ?? 0,
      buyerId: json['buyer'] ?? 0,
      buyerName: json['buyer_name'] ?? '',
      buyerAvatar: json['buyer_avatar'],
      sellerId: json['seller'] ?? 0,
      sellerName: json['seller_name'] ?? '',
      sellerAvatar: json['seller_avatar'],
      itemType: json['item_type'] ?? 'product',
      itemId: json['item_id'] ?? 0,
      itemTitle: json['item_title'] ?? '',
      itemImage: json['item_image'],
      offerAmount: double.tryParse(json['offer_amount']?.toString() ?? '0') ?? 0,
      originalPrice: double.tryParse(json['original_price']?.toString() ?? '0') ?? 0,
      discountPercent: double.tryParse(json['discount_percent']?.toString() ?? '0') ?? 0,
      message: json['message'],
      counterAmount: json['counter_amount'] != null
          ? double.tryParse(json['counter_amount'].toString())
          : null,
      counterMessage: json['counter_message'],
      status: OfferStatus.fromString(json['status'] ?? 'pending'),
      declineReason: json['decline_reason'],
      isExpired: json['is_expired'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: DateTime.tryParse(json['expires_at'] ?? '') ?? DateTime.now().add(const Duration(hours: 48)),
      respondedAt: json['responded_at'] != null
          ? DateTime.tryParse(json['responded_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyer': buyerId,
      'buyer_name': buyerName,
      'buyer_avatar': buyerAvatar,
      'seller': sellerId,
      'seller_name': sellerName,
      'seller_avatar': sellerAvatar,
      'item_type': itemType,
      'item_id': itemId,
      'item_title': itemTitle,
      'item_image': itemImage,
      'offer_amount': offerAmount.toString(),
      'original_price': originalPrice.toString(),
      'discount_percent': discountPercent,
      'message': message,
      'counter_amount': counterAmount?.toString(),
      'counter_message': counterMessage,
      'status': status.name,
      'decline_reason': declineReason,
      'is_expired': isExpired,
      'created_at': createdAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
    };
  }

  /// Check if offer can be responded to
  bool get canRespond => status == OfferStatus.pending && !isExpired;

  /// Check if counter can be accepted
  bool get canAcceptCounter => status == OfferStatus.countered && !isExpired;

  /// Get time remaining until expiration
  Duration get timeRemaining => expiresAt.difference(DateTime.now());

  /// Get savings amount
  double get savingsAmount => originalPrice - offerAmount;

  /// Get final agreed price
  double get finalPrice {
    if (status == OfferStatus.accepted) {
      return counterAmount ?? offerAmount;
    }
    return offerAmount;
  }

  Offer copyWith({
    int? id,
    int? buyerId,
    String? buyerName,
    String? buyerAvatar,
    int? sellerId,
    String? sellerName,
    String? sellerAvatar,
    String? itemType,
    int? itemId,
    String? itemTitle,
    String? itemImage,
    double? offerAmount,
    double? originalPrice,
    double? discountPercent,
    String? message,
    double? counterAmount,
    String? counterMessage,
    OfferStatus? status,
    String? declineReason,
    bool? isExpired,
    DateTime? createdAt,
    DateTime? expiresAt,
    DateTime? respondedAt,
  }) {
    return Offer(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      buyerAvatar: buyerAvatar ?? this.buyerAvatar,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      itemType: itemType ?? this.itemType,
      itemId: itemId ?? this.itemId,
      itemTitle: itemTitle ?? this.itemTitle,
      itemImage: itemImage ?? this.itemImage,
      offerAmount: offerAmount ?? this.offerAmount,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      message: message ?? this.message,
      counterAmount: counterAmount ?? this.counterAmount,
      counterMessage: counterMessage ?? this.counterMessage,
      status: status ?? this.status,
      declineReason: declineReason ?? this.declineReason,
      isExpired: isExpired ?? this.isExpired,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      respondedAt: respondedAt ?? this.respondedAt,
    );
  }
}

/// Request model for creating an offer
class CreateOfferRequest {
  final String itemType;
  final int itemId;
  final double offerAmount;
  final String? message;

  const CreateOfferRequest({
    required this.itemType,
    required this.itemId,
    required this.offerAmount,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_type': itemType,
      'item_id': itemId,
      'offer_amount': offerAmount.toStringAsFixed(2),
      if (message != null) 'message': message,
    };
  }
}

/// Request model for responding to an offer
class OfferResponseRequest {
  final String action; // 'accept', 'decline', 'counter'
  final String? declineReason;
  final double? counterAmount;
  final String? counterMessage;

  const OfferResponseRequest({
    required this.action,
    this.declineReason,
    this.counterAmount,
    this.counterMessage,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'action': action};
    if (action == 'decline' && declineReason != null) {
      map['decline_reason'] = declineReason;
    }
    if (action == 'counter') {
      if (counterAmount != null) {
        map['counter_amount'] = counterAmount!.toStringAsFixed(2);
      }
      if (counterMessage != null) {
        map['counter_message'] = counterMessage;
      }
    }
    return map;
  }
}
