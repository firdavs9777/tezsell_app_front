// lib/models/chat_models.dart

class User {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }

  String get displayName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return username;
  }
}

class ChatRoom {
  final int id;
  final String name;
  final DateTime createdAt;
  final List<User> participants;
  final String? lastMessagePreview;
  final DateTime? lastMessageTimestamp;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.participants,
    this.lastMessagePreview,
    this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      participants: (json['participants'] as List?)
              ?.map((p) => User.fromJson(p))
              .toList() ??
          [],
      lastMessagePreview: json['last_message_preview'],
      lastMessageTimestamp: json['last_message_timestamp'] != null
          ? DateTime.parse(json['last_message_timestamp'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }
}

class ChatMessage {
  final int id;
  final String content;
  final User sender;
  final DateTime timestamp;
  final bool isRead;
  final List<User> readBy;

  ChatMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    required this.isRead,
    required this.readBy,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      sender: User.fromJson(json['sender']),
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'] ?? false,
      readBy:
          (json['read_by'] as List?)?.map((u) => User.fromJson(u)).toList() ??
              [],
    );
  }

  bool isOwnMessage(int currentUserId) {
    return sender.id == currentUserId;
  }
}
