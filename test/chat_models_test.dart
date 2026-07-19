import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/message_model.dart';

void main() {
  group('ChatMessage.fromJson', () {
    test('parses full backend-shaped payload: reactions + reply + local_id',
        () {
      final json = {
        'id': 42,
        'content': 'Sounds good, see you there',
        'message_type': 'text',
        'timestamp': '2026-07-19T10:00:00Z',
        'updated_at': null,
        'sender': {'id': 3, 'username': 'aziza', 'is_online': true},
        'file': null,
        'file_url': null,
        'duration': null,
        'delivery_status': 'delivered',
        'delivered_at': '2026-07-19T10:00:05Z',
        'is_edited': false,
        'is_deleted': false,
        'read_by': [1, 3],
        'reply_to': {
          'id': 40,
          'content': 'Is the couch still available?',
          'sender': 'bekzod',
          'message_type': 'text',
        },
        'reactions': {
          '👍': [1, 2],
          '❤️': [3],
        },
        'local_id': 'client-uuid-abc-123',
        'metadata': {'client_platform': 'ios'},
        'is_forwarded': false,
        'forwarded_from': null,
        'is_pinned': true,
        'pinned_at': '2026-07-19T10:01:00Z',
        'pinned_by': 3,
      };

      final message = ChatMessage.fromJson(json);

      expect(message.id, 42);
      expect(message.localId, 'client-uuid-abc-123');
      expect(message.metadata, {'client_platform': 'ios'});
      expect(message.isForwarded, false);
      expect(message.forwardedFromId, null);
      expect(message.isPinned, true);
      expect(message.pinnedBy, 3);
      expect(message.pinnedAt, isNotNull);
      expect(message.reactions['👍'], [1, 2]);
      expect(message.reactions['❤️'], [3]);
      expect(message.deliveryStatus, DeliveryStatus.delivered);
      expect(message.deliveredAt, isNotNull);
      expect(message.replyToId, 40);
      expect(message.replyPreview, isNotNull);
      expect(message.replyPreview!.senderUsername, 'bekzod');
      expect(message.replyPreview!.content, 'Is the couch still available?');
      // translation is a client-only cache field, never populated from JSON
      expect(message.translation, isNull);
    });

    test('applies null-safe defaults when new fields are absent', () {
      final json = {
        'id': 5,
        'content': 'hi',
        'sender': {'id': 1, 'username': 'user1'},
        'timestamp': '2026-07-19T09:00:00Z',
      };

      final message = ChatMessage.fromJson(json);

      expect(message.localId, isNull);
      expect(message.metadata, {});
      expect(message.isForwarded, false);
      expect(message.forwardedFromId, isNull);
      expect(message.isPinned, false);
      expect(message.pinnedAt, isNull);
      expect(message.pinnedBy, isNull);
      expect(message.reactions, {});
      expect(message.replyToId, isNull);
      expect(message.replyPreview, isNull);
      expect(message.deliveryStatus, DeliveryStatus.sent);
      expect(message.deliveredAt, isNull);
      expect(message.translation, isNull);
    });

    test('deliveryStatus.fromJson maps every backend value and defaults '
        'unknown to sent', () {
      expect(DeliveryStatus.fromJson('sending'), DeliveryStatus.sending);
      expect(DeliveryStatus.fromJson('sent'), DeliveryStatus.sent);
      expect(DeliveryStatus.fromJson('delivered'), DeliveryStatus.delivered);
      expect(DeliveryStatus.fromJson('read'), DeliveryStatus.read);
      expect(DeliveryStatus.fromJson('failed'), DeliveryStatus.failed);
      expect(DeliveryStatus.fromJson(null), DeliveryStatus.sent);
      // 'queued' is a client-only state, never sent by the backend, but the
      // enum still round-trips it for locally-composed messages.
      expect(DeliveryStatus.fromJson('queued'), DeliveryStatus.queued);
      expect(DeliveryStatus.queued.toJson(), 'queued');
    });

    test('copyWith overrides only the given fields', () {
      final original = ChatMessage(
        content: 'hello',
        sender: User(id: 1, username: 'a'),
        timestamp: DateTime.parse('2026-07-19T09:00:00Z'),
        deliveryStatus: DeliveryStatus.sending,
      );

      final updated = original.copyWith(
        deliveryStatus: DeliveryStatus.sent,
        translation: 'salut',
      );

      expect(updated.deliveryStatus, DeliveryStatus.sent);
      expect(updated.translation, 'salut');
      expect(updated.content, 'hello');
      expect(updated.sender.username, 'a');
    });

    test('toJson round-trips the new fields through fromJson', () {
      final original = ChatMessage.fromJson({
        'id': 9,
        'content': 'roundtrip',
        'sender': {'id': 2, 'username': 'b'},
        'timestamp': '2026-07-19T09:00:00Z',
        'local_id': 'abc',
        'metadata': {'k': 'v'},
        'is_pinned': true,
        'reactions': {
          '👍': [2],
        },
        'delivery_status': 'read',
      });

      final restored = ChatMessage.fromJson(original.toJson());

      expect(restored.localId, 'abc');
      expect(restored.metadata, {'k': 'v'});
      expect(restored.isPinned, true);
      expect(restored.reactions['👍'], [2]);
      expect(restored.deliveryStatus, DeliveryStatus.read);
    });
  });

  group('ChatRoom.fromJson', () {
    test('parses a product listing including seller_id and state with '
        'muted_until', () {
      final json = {
        'id': 100,
        'name': 'bekzod',
        'participants': [
          {'id': 1, 'username': 'me'},
          {'id': 2, 'username': 'bekzod'},
        ],
        'is_group': false,
        'unread_count': 3,
        'listing': {
          'type': 'product',
          'id': 55,
          'title': 'Leather couch',
          'price': '450000.00',
          'currency': 'UZS',
          'image_url': 'https://cdn.example.com/couch.jpg',
          'status': 'available',
          'seller_id': 2,
        },
        'state': {
          'is_muted': true,
          'muted_until': '2026-08-01T00:00:00Z',
          'is_archived': false,
          'is_pinned': true,
        },
      };

      final room = ChatRoom.fromJson(json);

      expect(room.listing, isNotNull);
      expect(room.listing!.type, 'product');
      expect(room.listing!.id, '55');
      expect(room.listing!.title, 'Leather couch');
      expect(room.listing!.price, '450000.00');
      expect(room.listing!.currency, 'UZS');
      expect(room.listing!.sellerId, 2);
      expect(room.listing!.status, 'available');

      expect(room.state.isMuted, true);
      expect(room.state.mutedUntil, isNotNull);
      expect(room.state.isArchived, false);
      expect(room.state.isPinned, true);
    });

    test('parses a property listing with a UUID string id', () {
      final json = {
        'id': 101,
        'name': 'aziza',
        'participants': [],
        'listing': {
          'type': 'property',
          'id': 'b3f1c9de-1234-4a5b-9c2d-abcdef123456',
          'title': '2-bedroom apartment',
          'price': '1200.00',
          'currency': 'USD',
          'image_url': null,
          'status': null,
          'seller_id': 7,
        },
      };

      final room = ChatRoom.fromJson(json);

      expect(room.listing, isNotNull);
      expect(room.listing!.type, 'property');
      expect(room.listing!.id, 'b3f1c9de-1234-4a5b-9c2d-abcdef123456');
      expect(room.listing!.id, isA<String>());
      expect(room.listing!.sellerId, 7);
    });

    test('defaults listing to null and state to all-false/null when absent',
        () {
      final json = {
        'id': 102,
        'name': 'legacy room',
        'participants': [],
      };

      final room = ChatRoom.fromJson(json);

      expect(room.listing, isNull);
      expect(room.state.isMuted, false);
      expect(room.state.mutedUntil, isNull);
      expect(room.state.isArchived, false);
      expect(room.state.isPinned, false);
    });

    test('copyWith overrides only the given fields', () {
      final original = ChatRoom(
        id: 1,
        name: 'room',
        participants: const [],
      );

      final updated = original.copyWith(
        state: const RoomState(isMuted: true, isArchived: true),
      );

      expect(updated.state.isMuted, true);
      expect(updated.state.isArchived, true);
      expect(updated.name, 'room');
    });

    test('toJson round-trips listing and state through fromJson', () {
      final original = ChatRoom.fromJson({
        'id': 200,
        'name': 'room',
        'participants': [],
        'listing': {
          'type': 'service',
          'id': 12,
          'title': 'Plumbing',
          'price': null,
          'currency': null,
          'image_url': null,
          'status': null,
          'seller_id': 9,
        },
        'state': {
          'is_muted': false,
          'muted_until': null,
          'is_archived': true,
          'is_pinned': false,
        },
      });

      final restored = ChatRoom.fromJson(original.toJson());

      expect(restored.listing!.type, 'service');
      expect(restored.listing!.id, '12');
      expect(restored.listing!.sellerId, 9);
      expect(restored.state.isArchived, true);
    });
  });
}
