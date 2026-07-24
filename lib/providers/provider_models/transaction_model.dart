/// Transaction Model for tracking deals between buyers and sellers.
///
/// Mirrors the backend `TransactionSerializer` (reviews app): `seller`/`buyer`
/// are plain user PK integers, with the display names carried separately in
/// `seller_name`/`buyer_name`. Review state is exposed per-party via
/// `seller_reviewed`/`buyer_reviewed` plus a derived `can_review` flag.
class Transaction {
  final int id;
  final int seller; // seller user PK
  final String sellerName;
  final int buyer; // buyer user PK
  final String buyerName;
  final String itemType; // product, service, property
  final String itemTitle;
  final String? itemImage;
  final String status;
  final String? agreedPrice;
  final bool canReview;
  final bool sellerReviewed;
  final bool buyerReviewed;
  final DateTime createdAt;
  final DateTime? completedAt;

  Transaction({
    required this.id,
    required this.seller,
    this.sellerName = '',
    required this.buyer,
    this.buyerName = '',
    required this.itemType,
    required this.itemTitle,
    this.itemImage,
    required this.status,
    this.agreedPrice,
    required this.canReview,
    this.sellerReviewed = false,
    this.buyerReviewed = false,
    required this.createdAt,
    this.completedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      seller: json['seller'] ?? 0,
      sellerName: json['seller_name'] ?? '',
      buyer: json['buyer'] ?? 0,
      buyerName: json['buyer_name'] ?? '',
      itemType: json['item_type'] ?? 'product',
      itemTitle: json['item_title'] ?? '',
      itemImage: json['item_image'],
      status: json['status'] ?? 'interested',
      agreedPrice: json['agreed_price']?.toString(),
      canReview: json['can_review'] ?? false,
      sellerReviewed: json['seller_reviewed'] ?? false,
      buyerReviewed: json['buyer_reviewed'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller': seller,
      'seller_name': sellerName,
      'buyer': buyer,
      'buyer_name': buyerName,
      'item_type': itemType,
      'item_title': itemTitle,
      'item_image': itemImage,
      'status': status,
      'agreed_price': agreedPrice,
      'can_review': canReview,
      'seller_reviewed': sellerReviewed,
      'buyer_reviewed': buyerReviewed,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isActive => !isCompleted && !isCancelled;

  /// Returns whether [userId] is the buyer party of this transaction.
  /// Returns null when the user is neither buyer nor seller (or unknown),
  /// so callers can avoid silently defaulting a role.
  bool? isBuyerFor(int? userId) {
    if (userId == null) return null;
    if (userId == buyer) return true;
    if (userId == seller) return false;
    return null;
  }
}

/// Transaction status enum
enum TransactionStatus {
  interested,
  negotiating,
  reserved,
  completed,
  cancelled,
}

extension TransactionStatusExtension on TransactionStatus {
  String get value {
    switch (this) {
      case TransactionStatus.interested:
        return 'interested';
      case TransactionStatus.negotiating:
        return 'negotiating';
      case TransactionStatus.reserved:
        return 'reserved';
      case TransactionStatus.completed:
        return 'completed';
      case TransactionStatus.cancelled:
        return 'cancelled';
    }
  }

  String get displayName {
    switch (this) {
      case TransactionStatus.interested:
        return 'Interested';
      case TransactionStatus.negotiating:
        return 'Negotiating';
      case TransactionStatus.reserved:
        return 'Reserved';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get displayNameUz {
    switch (this) {
      case TransactionStatus.interested:
        return 'Qiziqish';
      case TransactionStatus.negotiating:
        return 'Muzokara';
      case TransactionStatus.reserved:
        return 'Band qilingan';
      case TransactionStatus.completed:
        return 'Yakunlangan';
      case TransactionStatus.cancelled:
        return 'Bekor qilingan';
    }
  }

  String get displayNameRu {
    switch (this) {
      case TransactionStatus.interested:
        return 'Интересует';
      case TransactionStatus.negotiating:
        return 'Переговоры';
      case TransactionStatus.reserved:
        return 'Забронировано';
      case TransactionStatus.completed:
        return 'Завершено';
      case TransactionStatus.cancelled:
        return 'Отменено';
    }
  }

  static TransactionStatus fromString(String value) {
    return TransactionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TransactionStatus.interested,
    );
  }
}
