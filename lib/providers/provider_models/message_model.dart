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
      final hasGarbledChars =
          text.contains('ë') ||
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
        } catch (e) {}
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
      firstName: json['first_name'] != null
          ? _fixEncoding(json['first_name'])
          : null,
      lastName: json['last_name'] != null
          ? _fixEncoding(json['last_name'])
          : null,
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

/// Summary of the listing (product/service/property) a chat room is
/// anchored to. Mirrors `ChatRoomSerializer.get_listing` on the backend.
///
/// `id` is always a String: product/service ids are ints on the backend but
/// property ids are UUID strings, so the model normalizes both via
/// `.toString()` to keep a single type on the client.
class ChatListing {
  final String type; // 'product' | 'service' | 'property'
  final String id;
  final String title;
  final String? price;
  final String? currency;
  final String? imageUrl;
  final String? status;
  final int? sellerId;

  const ChatListing({
    required this.type,
    required this.id,
    required this.title,
    this.price,
    this.currency,
    this.imageUrl,
    this.status,
    this.sellerId,
  });

  factory ChatListing.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawSellerId = json['seller_id'];
    return ChatListing(
      type: json['type'] as String? ?? '',
      id: rawId?.toString() ?? '',
      title: json['title'] as String? ?? '',
      price: json['price']?.toString(),
      currency: json['currency'] as String?,
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String?,
      sellerId: rawSellerId is int
          ? rawSellerId
          : (rawSellerId is num ? rawSellerId.toInt() : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'price': price,
      'currency': currency,
      'image_url': imageUrl,
      'status': status,
      'seller_id': sellerId,
    };
  }
}

/// Per-user room preferences (mute/archive/pin), mirroring the backend's
/// `RoomState` model via `ChatRoomSerializer.get_state` /
/// `room_state_effective_dict`. Defaults to all-false/null when the backend
/// omits `state` (legacy payloads) or the user has no `RoomState` row yet.
class RoomState {
  final bool isMuted;
  final DateTime? mutedUntil;
  final bool isArchived;
  final bool isPinned;

  const RoomState({
    this.isMuted = false,
    this.mutedUntil,
    this.isArchived = false,
    this.isPinned = false,
  });

  factory RoomState.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RoomState();
    return RoomState(
      isMuted: json['is_muted'] as bool? ?? false,
      mutedUntil: json['muted_until'] != null
          ? DateTime.tryParse(json['muted_until'] as String)?.toLocal()
          : null,
      isArchived: json['is_archived'] as bool? ?? false,
      isPinned: json['is_pinned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_muted': isMuted,
      'muted_until': mutedUntil?.toIso8601String(),
      'is_archived': isArchived,
      'is_pinned': isPinned,
    };
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
  final bool isGroup;
  final bool isPinned;

  // 🔥 NEW: Listing anchor + per-user room state
  final ChatListing? listing;
  final RoomState state;

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
    this.isPinned = false,
    this.listing,
    this.state = const RoomState(),
  });

  // 🔥 IMPROVED: Fix double-encoded UTF-8 (especially for Korean and emojis)
  static String _fixEncoding(String text) {
    if (text.isEmpty) return text;

    try {
      // 🔥 Check if text already contains valid Unicode (emojis, Korean, etc.)
      // If it does, don't try to fix it - it's already correct
      // Check for emojis using a simpler approach
      final hasEmojis = text.runes.any(
        (rune) =>
            (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
            (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
            (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
            (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
            (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
            (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
            (rune >= 0x1FA00 && rune <= 0x1FA6F), // Chess Symbols
      );

      final hasKorean = RegExp(r'[가-힣]').hasMatch(text);

      // If text contains valid Unicode characters (emojis or Korean), return as-is
      if (hasEmojis || hasKorean) {
        return text;
      }

      // Check for common double-encoding patterns (but only if no valid Unicode)
      final hasGarbledChars =
          text.contains('ë') ||
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
          final fixedHasValidUnicode =
              RegExp(r'[가-힣]').hasMatch(fixed) ||
              RegExp(r'[\u{1F600}-\u{1F64F}]', unicode: true).hasMatch(fixed) ||
              RegExp(r'[\u{1F300}-\u{1F5FF}]', unicode: true).hasMatch(fixed);

          if (fixedHasValidUnicode ||
              (fixed != text && fixed.length <= text.length * 2)) {
            return fixed;
          }
        } catch (e) {}
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
        lastMessagePreview = rawContent != null
            ? _fixEncoding(rawContent)
            : null;

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
                // 🔍 Debug: Log participant online status
                print(
                  '👤 [ChatRoom] Participant: ${p['username']}, is_online=${p['is_online']}, last_seen=${p['last_seen']}',
                );
                return User.fromJson(p);
              } else if (p is int) {
                return User(id: p, username: 'User $p');
              }
              return null;
            })
            .whereType<User>()
            .toList();
      } catch (e) {
        print('❌ [ChatRoom] Error parsing participants: $e');
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
      } catch (e) {}
    }

    // 🔥 NEW: Parse listing anchor summary (product/service/property), if any
    ChatListing? listing;
    if (json['listing'] != null && json['listing'] is Map) {
      try {
        listing = ChatListing.fromJson(
          Map<String, dynamic>.from(json['listing'] as Map),
        );
      } catch (e) {
        listing = null;
      }
    }

    // 🔥 NEW: Parse per-user room state (mute/archive/pin); defaults when absent
    final roomState = RoomState.fromJson(
      json['state'] != null && json['state'] is Map
          ? Map<String, dynamic>.from(json['state'] as Map)
          : null,
    );

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
      isPinned: json['is_pinned'] as bool? ?? false,
      listing: listing,
      state: roomState,
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
      'is_pinned': isPinned,
      'listing': listing?.toJson(),
      'state': state.toJson(),
    };
  }

  ChatRoom copyWith({
    int? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<User>? participants,
    String? lastMessagePreview,
    DateTime? lastMessageTimestamp,
    int? unreadCount,
    bool? isGroup,
    bool? isPinned,
    ChatListing? listing,
    RoomState? state,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      participants: participants ?? this.participants,
      lastMessagePreview: lastMessagePreview ?? this.lastMessagePreview,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      isGroup: isGroup ?? this.isGroup,
      isPinned: isPinned ?? this.isPinned,
      listing: listing ?? this.listing,
      state: state ?? this.state,
    );
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

/// Delivery lifecycle of an outgoing message. `sending`..`failed` mirror the
/// backend's `Message.DELIVERY_STATUS` choices; `queued` is client-only,
/// used for messages composed while offline that haven't been handed to the
/// send pipeline yet (the backend never sends this value).
enum DeliveryStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
  queued;

  String toJson() => name;

  static DeliveryStatus fromJson(String? value) {
    switch (value) {
      case 'sending':
        return DeliveryStatus.sending;
      case 'delivered':
        return DeliveryStatus.delivered;
      case 'read':
        return DeliveryStatus.read;
      case 'failed':
        return DeliveryStatus.failed;
      case 'queued':
        return DeliveryStatus.queued;
      case 'sent':
      default:
        return DeliveryStatus.sent;
    }
  }
}

/// Lightweight preview of a replied-to message, matching the shape
/// `MessageSerializer.get_reply_to` actually sends: `{id, content, sender,
/// message_type}` where `content` is truncated to 50 chars and `sender` is
/// the plain username string (not a nested user object).
class ReplyPreview {
  final int id;
  final String content;
  final String senderUsername;
  final MessageType messageType;

  const ReplyPreview({
    required this.id,
    required this.content,
    required this.senderUsername,
    this.messageType = MessageType.text,
  });

  factory ReplyPreview.fromJson(Map<String, dynamic> json) {
    final rawSender = json['sender'];
    return ReplyPreview(
      id: json['id'] as int? ?? 0,
      content: json['content'] as String? ?? '',
      senderUsername: rawSender is String
          ? rawSender
          : (rawSender is Map ? (rawSender['username'] as String? ?? '') : ''),
      messageType: json['message_type'] != null
          ? MessageType.fromJson(json['message_type'] as String)
          : MessageType.text,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': senderUsername,
      'message_type': messageType.toJson(),
    };
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

  // 🔥 NEW: Offline send + delivery tracking
  final String? localId; // client-generated id echoed back by the backend
  final DeliveryStatus deliveryStatus;
  final DateTime? deliveredAt;

  // 🔥 NEW: Reply metadata as actually sent by the backend (lightweight,
  // not a full nested message) — replyToId/replyPreview are the source of
  // truth; `replyTo` above is kept for existing call sites that build a
  // best-effort ChatMessage out of the same payload.
  final int? replyToId;
  final ReplyPreview? replyPreview;

  // 🔥 NEW: Arbitrary client/server annotations attached to the message
  final Map<String, dynamic> metadata;

  // 🔥 NEW: Forwarding
  final bool isForwarded;
  final int? forwardedFromId;

  // 🔥 NEW: Pinning
  final bool isPinned;
  final DateTime? pinnedAt;
  final int? pinnedBy;

  // 🔥 NEW: Client-only cache of a fetched translation for this message.
  // Never populated from JSON; not sent back to the server.
  final String? translation;

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
    this.localId,
    this.deliveryStatus = DeliveryStatus.sent,
    this.deliveredAt,
    this.replyToId,
    this.replyPreview,
    this.metadata = const {},
    this.isForwarded = false,
    this.forwardedFromId,
    this.isPinned = false,
    this.pinnedAt,
    this.pinnedBy,
    this.translation,
  });

  // 🔥 IMPROVED: Fix double-encoded UTF-8 (same logic as ChatRoom)
  static String _fixEncoding(String text) {
    if (text.isEmpty) return text;

    try {
      // 🔥 Check if text already contains valid Unicode (emojis, Korean, etc.)
      final hasEmojis = text.runes.any(
        (rune) =>
            (rune >= 0x1F600 && rune <= 0x1F64F) || // Emoticons
            (rune >= 0x1F300 && rune <= 0x1F5FF) || // Misc Symbols
            (rune >= 0x1F680 && rune <= 0x1F6FF) || // Transport
            (rune >= 0x2600 && rune <= 0x26FF) || // Misc symbols
            (rune >= 0x2700 && rune <= 0x27BF) || // Dingbats
            (rune >= 0x1F900 && rune <= 0x1F9FF) || // Supplemental Symbols
            (rune >= 0x1FA00 && rune <= 0x1FA6F), // Chess Symbols
      );

      final hasKorean = RegExp(r'[가-힣]').hasMatch(text);

      // If text contains valid Unicode characters, return as-is
      if (hasEmojis || hasKorean) {
        return text;
      }

      // Check for common double-encoding patterns
      final hasGarbledChars =
          text.contains('ë') ||
          text.contains('í') ||
          text.contains('ì') ||
          text.contains('â') ||
          text.contains('Ã');

      if (hasGarbledChars) {
        try {
          final bytes = latin1.encode(text);
          final fixed = utf8.decode(bytes, allowMalformed: true);

          final fixedHasValidUnicode =
              RegExp(r'[가-힣]').hasMatch(fixed) ||
              fixed.runes.any((rune) => rune >= 0x1F600 && rune <= 0x1F64F);

          if (fixedHasValidUnicode ||
              (fixed != text && fixed.length <= text.length * 2)) {
            return fixed;
          }
        } catch (e) {}
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
          final replyToData = Map<String, dynamic>.from(
            json['reply_to'] as Map,
          );

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

    // 🔥 NEW: Parse the lightweight reply_to shape the backend actually
    // sends: {id, content, sender: <username string>, message_type}.
    int? replyToId;
    ReplyPreview? replyPreview;
    if (json['reply_to'] != null) {
      if (json['reply_to'] is Map) {
        final replyMap = Map<String, dynamic>.from(json['reply_to'] as Map);
        replyToId = replyMap['id'] as int?;
        try {
          replyPreview = ReplyPreview.fromJson(replyMap);
        } catch (e) {
          replyPreview = null;
        }
      } else if (json['reply_to'] is int) {
        replyToId = json['reply_to'] as int;
      }
    }

    // 🔥 NEW: local_id / metadata / forwarding / pinning
    final localId = json['local_id'] as String?;

    Map<String, dynamic> metadata = {};
    if (json['metadata'] != null && json['metadata'] is Map) {
      metadata = Map<String, dynamic>.from(json['metadata'] as Map);
    }

    final isForwarded = json['is_forwarded'] as bool? ?? false;
    final rawForwardedFrom = json['forwarded_from'];
    final forwardedFromId = rawForwardedFrom is int
        ? rawForwardedFrom
        : (rawForwardedFrom is num ? rawForwardedFrom.toInt() : null);

    final isPinnedMsg = json['is_pinned'] as bool? ?? false;
    final pinnedAt = json['pinned_at'] != null
        ? DateTime.tryParse(json['pinned_at'] as String)?.toLocal()
        : null;
    final rawPinnedBy = json['pinned_by'];
    final pinnedBy = rawPinnedBy is int
        ? rawPinnedBy
        : (rawPinnedBy is num ? rawPinnedBy.toInt() : null);

    final deliveryStatus = DeliveryStatus.fromJson(
      json['delivery_status'] as String?,
    );
    final deliveredAt = json['delivered_at'] != null
        ? DateTime.tryParse(json['delivered_at'] as String)?.toLocal()
        : null;

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
      localId: localId,
      deliveryStatus: deliveryStatus,
      deliveredAt: deliveredAt,
      replyToId: replyToId,
      replyPreview: replyPreview,
      metadata: metadata,
      isForwarded: isForwarded,
      forwardedFromId: forwardedFromId,
      isPinned: isPinnedMsg,
      pinnedAt: pinnedAt,
      pinnedBy: pinnedBy,
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
      'local_id': localId,
      'delivery_status': deliveryStatus.toJson(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'reply_to_id': replyToId,
      'reply_preview': replyPreview?.toJson(),
      'metadata': metadata,
      'is_forwarded': isForwarded,
      'forwarded_from': forwardedFromId,
      'is_pinned': isPinned,
      'pinned_at': pinnedAt?.toIso8601String(),
      'pinned_by': pinnedBy,
    };
  }

  ChatMessage copyWith({
    int? id,
    MessageType? messageType,
    String? content,
    String? file,
    String? fileUrl,
    int? duration,
    User? sender,
    DateTime? timestamp,
    DateTime? updatedAt,
    bool? isRead,
    List<int>? readBy,
    bool? isEdited,
    bool? isDeleted,
    ChatMessage? replyTo,
    Map<String, List<int>>? reactions,
    String? localId,
    DeliveryStatus? deliveryStatus,
    DateTime? deliveredAt,
    int? replyToId,
    ReplyPreview? replyPreview,
    Map<String, dynamic>? metadata,
    bool? isForwarded,
    int? forwardedFromId,
    bool? isPinned,
    DateTime? pinnedAt,
    int? pinnedBy,
    String? translation,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      file: file ?? this.file,
      fileUrl: fileUrl ?? this.fileUrl,
      duration: duration ?? this.duration,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      updatedAt: updatedAt ?? this.updatedAt,
      isRead: isRead ?? this.isRead,
      readBy: readBy ?? this.readBy,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      replyTo: replyTo ?? this.replyTo,
      reactions: reactions ?? this.reactions,
      localId: localId ?? this.localId,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      replyToId: replyToId ?? this.replyToId,
      replyPreview: replyPreview ?? this.replyPreview,
      metadata: metadata ?? this.metadata,
      isForwarded: isForwarded ?? this.isForwarded,
      forwardedFromId: forwardedFromId ?? this.forwardedFromId,
      isPinned: isPinned ?? this.isPinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinnedBy: pinnedBy ?? this.pinnedBy,
      translation: translation ?? this.translation,
    );
  }

  bool isOwnMessage(int currentUserId) {
    return sender.id == currentUserId;
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: "$content", sender: ${sender.username})';
  }
}
