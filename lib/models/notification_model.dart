class NotificationModel {
  final int id;
  final int? sender;
  final String? senderUsername;
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
    required this.type,
    required this.title,
    required this.body,
    this.objectId,
    required this.isRead,
    required this.createdAt,
  });

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
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      objectId: objectId ?? this.objectId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

