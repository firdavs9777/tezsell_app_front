/// Notification types supported by the backend
class NotificationTypes {
  static const String chat = 'chat';
  static const String productLike = 'product_like';
  static const String serviceLike = 'service_like';
  static const String commentLike = 'comment_like';
  static const String productComment = 'product_comment';
  static const String serviceComment = 'service_comment';
  static const String realEstate = 'real_estate';
  static const String realEstateInquiry = 'real_estate_inquiry';
  static const String order = 'order';
  static const String system = 'system';
  static const String recommendedProduct = 'recommended_product';
  static const String recommendedService = 'recommended_service';
  static const String recommendedProperty = 'recommended_property';
  static const String priceDrop = 'price_drop';
  static const String newListing = 'new_listing';
}

class NotificationModel {
  final int id;
  final int? sender;
  final String? senderUsername;
  final String? senderAvatar;  // NEW: Sender's profile picture URL
  final String type;
  final String title;
  final String body;
  final int? objectId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    this.sender,
    this.senderUsername,
    this.senderAvatar,
    required this.type,
    required this.title,
    required this.body,
    this.objectId,
    required this.isRead,
    required this.createdAt,
  });

  /// Returns the display name for the sender (falls back to "TezSell" for system notifications)
  String get displaySenderName => senderUsername ?? 'TezSell';

  /// Returns true if this is a system notification
  bool get isSystemNotification => sender == null || type == NotificationTypes.system;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    // Handle object_id as both string and int
    int? objectId;
    if (json['object_id'] != null) {
      if (json['object_id'] is int) {
        objectId = json['object_id'];
      } else if (json['object_id'] is String) {
        objectId = int.tryParse(json['object_id']);
      }
    }

    return NotificationModel(
      id: json['id'],
      sender: json['sender'],
      senderUsername: json['sender_username'],
      senderAvatar: json['sender_avatar'],  // NEW
      type: json['type'],
      title: json['title'],
      body: json['body'] ?? '',
      objectId: objectId,
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'sender_username': senderUsername,
      'sender_avatar': senderAvatar,
      'type': type,
      'title': title,
      'body': body,
      'object_id': objectId,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    int? sender,
    String? senderUsername,
    String? senderAvatar,
    String? type,
    String? title,
    String? body,
    int? objectId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderUsername: senderUsername ?? this.senderUsername,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      objectId: objectId ?? this.objectId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

