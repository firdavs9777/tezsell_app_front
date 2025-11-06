// lib/providers/provider_models/message_model.dart

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

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
    };
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
  final DateTime? createdAt;
  final List<User> participants;
  final String? lastMessagePreview;
  final DateTime? lastMessageTimestamp;
  final int unreadCount;

  ChatRoom({
    required this.id,
    required this.name,
    this.createdAt,
    required this.participants,
    this.lastMessagePreview,
    this.lastMessageTimestamp,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
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

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message_preview': lastMessagePreview,
      'last_message_timestamp': lastMessageTimestamp?.toIso8601String(),
      'unread_count': unreadCount,
    };
  }
}

class ChatMessage {
  final int? id;
  final String content;
  final User sender;
  final DateTime timestamp;
  final bool isRead;
  final List<int> readBy; // Changed to List<int> to match WebSocket format

  ChatMessage({
    this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.isRead = false,
    this.readBy = const [],
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'] ?? json['message'] ?? '', // Handle both keys
      sender: User.fromJson(json['sender']),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
      readBy: json['read_by'] != null
          ? List<int>.from(json['read_by']) // Parse as list of IDs
          : [],
    );
  }

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
      'read_by': readBy,
    };
  }

  bool isOwnMessage(int currentUserId) {
    return sender.id == currentUserId;
  }
}
