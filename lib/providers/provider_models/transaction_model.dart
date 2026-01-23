/// Transaction Model for tracking deals between buyers and sellers

class Transaction {
  final int id;
  final TransactionUser seller;
  final TransactionUser buyer;
  final String itemType; // product, service, property
  final int itemId;
  final String itemTitle;
  final String? itemImage;
  final String status;
  final String statusDisplay;
  final String? agreedPrice;
  final int? chatRoomId;
  final bool canReview;
  final bool myReviewSubmitted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;

  Transaction({
    required this.id,
    required this.seller,
    required this.buyer,
    required this.itemType,
    required this.itemId,
    required this.itemTitle,
    this.itemImage,
    required this.status,
    required this.statusDisplay,
    this.agreedPrice,
    this.chatRoomId,
    required this.canReview,
    required this.myReviewSubmitted,
    required this.createdAt,
    this.completedAt,
    this.cancelledAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0,
      seller: TransactionUser.fromJson(json['seller'] ?? {}),
      buyer: TransactionUser.fromJson(json['buyer'] ?? {}),
      itemType: json['item_type'] ?? 'product',
      itemId: json['item_id'] ?? 0,
      itemTitle: json['item_title'] ?? '',
      itemImage: json['item_image'],
      status: json['status'] ?? 'interested',
      statusDisplay: json['status_display'] ?? 'Interested',
      agreedPrice: json['agreed_price'],
      chatRoomId: json['chat_room_id'],
      canReview: json['can_review'] ?? false,
      myReviewSubmitted: json['my_review_submitted'] ?? false,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller': seller.toJson(),
      'buyer': buyer.toJson(),
      'item_type': itemType,
      'item_id': itemId,
      'item_title': itemTitle,
      'item_image': itemImage,
      'status': status,
      'status_display': statusDisplay,
      'agreed_price': agreedPrice,
      'chat_room_id': chatRoomId,
      'can_review': canReview,
      'my_review_submitted': myReviewSubmitted,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }

  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isActive => !isCompleted && !isCancelled;
}

class TransactionUser {
  final int id;
  final String username;
  final String? avatar;
  final double? temperature;

  TransactionUser({
    required this.id,
    required this.username,
    this.avatar,
    this.temperature,
  });

  factory TransactionUser.fromJson(Map<String, dynamic> json) {
    return TransactionUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      avatar: json['avatar'],
      temperature: double.tryParse(json['temperature']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
      'temperature': temperature,
    };
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
