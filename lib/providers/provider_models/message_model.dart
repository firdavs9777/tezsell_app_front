// lib/providers/provider_models/message_model.dart

import 'dart:convert';

class User {
  final int id;
  final String username;
  final String? email;
  final String? firstName;
  final String? lastName;

  // 🔥 NEW: Online status
  final bool isOnline;
  final DateTime? lastSeen;

  User({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
    this.isOnline = false,
    this.lastSeen,
  });

  // 🔥 IMPROVED: Fix double-encoded UTF-8 (especially for Korean)
  static String _fixEncoding(String text) {
    if (text.isEmpty) return text;

    try {
      // Check for common double-encoding patterns
      // Korean characters often show as garbled text when double-encoded
      final hasGarbledChars = text.contains('ë') ||
          text.contains('í') ||
          text.contains('ì') ||
          text.contains('â') ||
          text.contains('€') ||
          text.contains('Ã');

      // Also check if text contains valid Korean characters
      // If it does, likely no fix needed
      final hasKoreanChars = RegExp(r'[가-힣]').hasMatch(text);

      if (hasGarbledChars && !hasKoreanChars) {
        try {
          // Try to fix by re-encoding as Latin-1 then decoding as UTF-8
          final bytes = latin1.encode(text);
          final fixed = utf8.decode(bytes, allowMalformed: true);

          // Verify the fix worked by checking if we now have Korean characters
          if (RegExp(r'[가-힣]').hasMatch(fixed) || fixed != text) {
            return fixed;
          }
        } catch (e) {
        }
      }

      return text;
    } catch (e) {
      return text;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: _fixEncoding(json['username'] ?? ''),
      email: json['email'] != null ? _fixEncoding(json['email']) : null,
      firstName:
          json['first_name'] != null ? _fixEncoding(json['first_name']) : null,
      lastName:
          json['last_name'] != null ? _fixEncoding(json['last_name']) : null,
      isOnline: json['is_online'] as bool? ?? false,
      lastSeen: json['last_seen'] != null
          ? DateTime.parse(json['last_seen'] as String)
              .toLocal() // 🔥 Convert UTC to local time
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'is_online': isOnline,
      'last_seen': lastSeen?.toIso8601String(),
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
  final DateTime? updatedAt;
  final List<User> participants;
  final String? lastMessagePreview;
  final DateTime? lastMessageTimestamp;
  final int unreadCount;
  final bool isGroup; // 🔥 NEW: Group chat flag

  ChatRoom({
    required this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    required this.participants,
    this.lastMessagePreview,
    this.lastMessageTimestamp,
    this.unreadCount = 0,
    this.isGroup = false,
  });

  // 🔥 IMPROVED: Fix double-encoded UTF-8 (especially for Korean and emojis)
  static String _fixEncoding(String text) {
    if (text.isEmpty) return text;

    try {
      // 🔥 Check if text already contains valid Unicode (emojis, Korean, etc.)
      // If it does, don't try to fix it - it's already correct
      // Check for emojis using a simpler approach
      final hasEmojis = text.runes.any((rune) =>
              (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
              (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
              (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
              (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
              (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
              (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
              (rune >= 0x1FA00 && rune <= 0x1FA6F) // Chess Symbols
          );

      final hasKorean = RegExp(r'[가-힣]').hasMatch(text);

      // If text contains valid Unicode characters (emojis or Korean), return as-is
      if (hasEmojis || hasKorean) {
        return text;
      }

      // Check for common double-encoding patterns (but only if no valid Unicode)
      final hasGarbledChars = text.contains('ë') ||
          text.contains('í') ||
          text.contains('ì') ||
          text.contains('â') ||
          (text.contains('€') &&
              !text.contains('📷')) || // € might be part of emoji
          text.contains('Ã');

      if (hasGarbledChars) {
        try {
          final bytes = latin1.encode(text);
          final fixed = utf8.decode(bytes, allowMalformed: true);

          // Only use the fix if it actually improved the text
          // Check if fixed version has valid Unicode or is different
          final fixedHasValidUnicode = RegExp(r'[가-힣]').hasMatch(fixed) ||
              RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true).hasMatch(fixed) ||
              RegExp(r'[\u{1F300}-\u{1F5FF}]', unicode: true).hasMatch(fixed);

          if (fixedHasValidUnicode ||
              (fixed != text && fixed.length <= text.length * 2)) {
            return fixed;
          }
        } catch (e) {
        }
      }

      return text;
    } catch (e) {
      return text;
    }
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) {

    // Handle both REST API format (last_message) and WebSocket format (last_message_preview)
    String? lastMessagePreview;
    DateTime? lastMessageTimestamp;

    if (json['last_message'] != null) {
      if (json['last_message'] is Map) {
        // REST API format - nested object
        final lastMsg = json['last_message'] as Map<String, dynamic>;
        final rawContent = lastMsg['content'] as String?;

        // 🔥 Fix encoding for message content
        lastMessagePreview =
            rawContent != null ? _fixEncoding(rawContent) : null;

        lastMessageTimestamp = lastMsg['timestamp'] != null
            ? DateTime.parse(lastMsg['timestamp'] as String)
                .toLocal() // 🔥 Convert UTC to local time
            : null;

      }
    } else if (json.containsKey('last_message_preview')) {
      // WebSocket format - flat fields
      final rawPreview = json['last_message_preview'] as String?;

      // 🔥 Fix encoding for preview
      lastMessagePreview = rawPreview != null ? _fixEncoding(rawPreview) : null;

      lastMessageTimestamp = json['last_message_timestamp'] != null
          ? DateTime.parse(json['last_message_timestamp'] as String)
              .toLocal() // 🔥 Convert UTC to local time
          : null;

    }

    // 🔥 Fix encoding for room name
    final rawName = json['name'] as String? ?? 'Unknown';
    final fixedName = _fixEncoding(rawName);

    // 🔥 FIX: Parse unread_count more robustly (handle int, string, or null)
    int unreadCount = 0;
    final unreadCountRaw = json['unread_count'];
    if (unreadCountRaw != null) {
      if (unreadCountRaw is int) {
        unreadCount = unreadCountRaw;
      } else if (unreadCountRaw is String) {
        unreadCount = int.tryParse(unreadCountRaw) ?? 0;
      } else if (unreadCountRaw is num) {
        unreadCount = unreadCountRaw.toInt();
      }
    }

    // Parse participants
    List<User> participantsList = [];

    // 🔥 NEW: Handle both formats - full objects or just IDs (from WebSocket)
    if (json['participants'] != null && json['participants'] is List) {
      try {
        participantsList = (json['participants'] as List)
            .map((p) {
              if (p is Map<String, dynamic>) {
                return User.fromJson(p);
              } else if (p is int) {
                return User(id: p, username: 'User $p');
              }
              return null;
            })
            .whereType<User>()
            .toList();
      } catch (e) {
      }
    } else if (json['participant_ids'] != null &&
        json['participant_ids'] is List) {
      // 🔥 NEW: WebSocket format - just IDs, create User objects
      try {
        participantsList = (json['participant_ids'] as List)
            .map((id) {
              if (id is int) {
                return User(id: id, username: 'User $id');
              }
              return null;
            })
            .whereType<User>()
            .toList();
      } catch (e) {
      }
    }

    final chatRoom = ChatRoom(
      id: json['id'] as int,
      name: fixedName,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
              .toLocal() // 🔥 Convert UTC to local time
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
              .toLocal() // 🔥 Convert UTC to local time
          : null,
      participants: participantsList,
      lastMessagePreview: lastMessagePreview,
      lastMessageTimestamp: lastMessageTimestamp,
      unreadCount: unreadCount,
      isGroup: json['is_group'] as bool? ?? false,
    );

    return chatRoom;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'last_message_preview': lastMessagePreview,
      'last_message_timestamp': lastMessageTimestamp?.toIso8601String(),
      'unread_count': unreadCount,
      'is_group': isGroup,
    };
  }

  @override
  String toString() {
    return 'ChatRoom: $name, lastMsg: $lastMessagePreview, unread: $unreadCount';
  }
}

enum MessageType {
  text,
  image,
  voice;

  String toJson() => name;

  static MessageType fromJson(String value) {
    switch (value.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'voice':
        return MessageType.voice;
      case 'text':
      default:
        return MessageType.text;
    }
  }
}

class ChatMessage {
  final int? id;
  final MessageType messageType;
  final String? content;
  final String? file;
  final String? fileUrl;
  final int? duration;

  final User sender;
  final DateTime timestamp;
  final DateTime? updatedAt;
  final bool isRead;
  final List<int> readBy;

  // 🔥 NEW: Enhanced message features
  final bool isEdited;
  final bool isDeleted;
  final ChatMessage? replyTo;
  final Map<String, List<int>> reactions; // {"👍": [1, 2], "❤️": [3]}

  ChatMessage({
    this.id,
    this.messageType = MessageType.text,
    required this.content,
    this.file,
    this.fileUrl,
    this.duration,
    required this.sender,
    required this.timestamp,
    this.updatedAt,
    this.isRead = false,
    this.readBy = const [],
    this.isEdited = false,
    this.isDeleted = false,
    this.replyTo,
    this.reactions = const {},
  });

  // 🔥 IMPROVED: Fix double-encoded UTF-8 (same logic as ChatRoom)
  static String _fixEncoding(String text) {
    if (text.isEmpty) return text;

    try {
      // 🔥 Check if text already contains valid Unicode (emojis, Korean, etc.)
      final hasEmojis = text.runes.any((rune) =>
              (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
              (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
              (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
              (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
              (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
              (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
              (rune >= 0x1FA00 && rune <= 0x1FA6F) // Chess Symbols
          );

      final hasKorean = RegExp(r'[가-힣]').hasMatch(text);

      // If text contains valid Unicode characters, return as-is
      if (hasEmojis || hasKorean) {
        return text;
      }

      // Check for common double-encoding patterns
      final hasGarbledChars = text.contains('ë') ||
          text.contains('í') ||
          text.contains('ì') ||
          text.contains('â') ||
          text.contains('Ã');

      if (hasGarbledChars) {
        try {
          final bytes = latin1.encode(text);
          final fixed = utf8.decode(bytes, allowMalformed: true);

          final fixedHasValidUnicode = RegExp(r'[가-힣]').hasMatch(fixed) ||
              fixed.runes.any((rune) => rune >= 0x1F600 && rune <= 0x1F64F);

          if (fixedHasValidUnicode ||
              (fixed != text && fixed.length <= text.length * 2)) {
            return fixed;
          }
        } catch (e) {
        }
      }

      return text;
    } catch (e) {
      return text;
    }
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // Parse message type
    final messageTypeStr = json['message_type'] as String? ?? 'text';
    final messageType = MessageType.fromJson(messageTypeStr);

    // Parse content - can be null for image/voice messages
    String? rawContent = json['content'] ?? json['message'];
    String? fixedContent;
    if (rawContent != null && rawContent.isNotEmpty) {
      // 🔥 Fix encoding for message content
      fixedContent = _fixEncoding(rawContent);
    }

    // Parse file URLs - prefer file_url over file
    final String? fileUrl =
        json['file_url'] as String? ?? json['file'] as String?;

    // Parse duration for voice messages
    final int? duration = json['duration'] as int?;

    // 🔥 NEW: Parse enhanced message features
    final updatedAt = json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
            .toLocal() // 🔥 Convert UTC to local time
        : null;

    final isEdited = json['is_edited'] as bool? ?? false;
    final isDeleted = json['is_deleted'] as bool? ?? false;

    // Parse reply_to message
    ChatMessage? replyToMessage;
    if (json['reply_to'] != null) {
      if (json['reply_to'] is Map) {
        // Full message object
        try {
          final replyToData = Map<String, dynamic>.from(json['reply_to'] as Map);
          
          // 🔥 FIX: Handle case where sender is a string (username) instead of full user object
          if (replyToData['sender'] != null) {
            if (replyToData['sender'] is String) {
              final senderUsername = replyToData['sender'] as String;
              // Create a minimal User object from the username
              // Try to get sender ID from sender_id field if available
              final senderId = replyToData['sender_id'] as int?;
              
              replyToData['sender'] = {
                'id': senderId ?? 0, // Use 0 as fallback if no ID available
                'username': senderUsername,
                'is_online': false,
              };
            } else if (replyToData['sender'] is Map) {
              // Already a Map, no conversion needed
            } else {
              // Try to create a minimal user object anyway
              replyToData['sender'] = {
                'id': 0,
                'username': replyToData['sender'].toString(),
                'is_online': false,
              };
            }
          } else {
            // Create a minimal user object as fallback
            replyToData['sender'] = {
              'id': 0,
              'username': 'Unknown',
              'is_online': false,
            };
          }
          
          replyToMessage = ChatMessage.fromJson(replyToData);
        } catch (e, stackTrace) {
          // If parsing fails, replyToMessage will remain null
        }
      } else if (json['reply_to'] is int) {
        // Just an ID - we'll need to find the message from existing messages
        // This will be handled by the provider if needed
        // For now, we can't create a full message from just an ID
      }
    }

    // Parse reactions: {"👍": [1, 2], "❤️": [3]}
    Map<String, List<int>> reactionsMap = {};
    if (json['reactions'] != null && json['reactions'] is Map) {
      final reactionsData = json['reactions'] as Map<String, dynamic>;
      reactionsData.forEach((emoji, userIds) {
        if (userIds is List) {
          reactionsMap[emoji] = userIds.map((id) => id as int).toList();
        }
      });
    }

    return ChatMessage(
      id: json['id'] as int?,
      messageType: messageType,
      content: fixedContent,
      file: fileUrl,
      fileUrl: fileUrl,
      duration: duration,
      sender: User.fromJson(json['sender'] as Map<String, dynamic>),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
              .toLocal() // 🔥 Convert UTC to local time
          : DateTime.now(),
      updatedAt: updatedAt,
      isRead: json['is_read'] as bool? ?? false,
      readBy: json['read_by'] != null
          ? List<int>.from(json['read_by'] as List)
          : [],
      isEdited: isEdited,
      isDeleted: isDeleted,
      replyTo: replyToMessage,
      reactions: reactionsMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_type': messageType.toJson(),
      'content': content,
      'file_url': fileUrl,
      'duration': duration,
      'sender': sender.toJson(),
      'timestamp': timestamp.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_read': isRead,
      'read_by': readBy,
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'reply_to': replyTo?.toJson(),
      'reactions': reactions,
    };
  }

  bool isOwnMessage(int currentUserId) {
    return sender.id == currentUserId;
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: "$content", sender: ${sender.username})';
  }
}
