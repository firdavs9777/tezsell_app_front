import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/chat/widgets/chat_helpers.dart';
import 'package:app/providers/provider_models/message_model.dart';

ChatMessage _msg({
  required int senderId,
  required DateTime timestamp,
  MessageType type = MessageType.text,
}) {
  return ChatMessage(
    content: 'hi',
    sender: User(id: senderId, username: 'user$senderId'),
    timestamp: timestamp,
    messageType: type,
  );
}

void main() {
  group('ChatHelpers.bubblePosition', () {
    test('a single message from a sender is BubblePosition.single', () {
      final base = DateTime(2026, 7, 19, 10, 0);
      final messages = [_msg(senderId: 1, timestamp: base)];

      expect(ChatHelpers.bubblePosition(messages, 0), BubblePosition.single);
    });

    test('a run of 3 same-sender messages is first/middle/last', () {
      final base = DateTime(2026, 7, 19, 10, 0);
      final messages = [
        _msg(senderId: 1, timestamp: base),
        _msg(senderId: 1, timestamp: base.add(const Duration(minutes: 1))),
        _msg(senderId: 1, timestamp: base.add(const Duration(minutes: 2))),
      ];

      expect(ChatHelpers.bubblePosition(messages, 0), BubblePosition.first);
      expect(ChatHelpers.bubblePosition(messages, 1), BubblePosition.middle);
      expect(ChatHelpers.bubblePosition(messages, 2), BubblePosition.last);
    });

    test('a system message always breaks a run and is itself single', () {
      final base = DateTime(2026, 7, 19, 10, 0);
      final messages = [
        _msg(senderId: 1, timestamp: base),
        _msg(
          senderId: 1,
          timestamp: base.add(const Duration(minutes: 1)),
          type: MessageType.system,
        ),
        _msg(senderId: 1, timestamp: base.add(const Duration(minutes: 2))),
      ];

      // The message before the system message no longer groups forward.
      expect(ChatHelpers.bubblePosition(messages, 0), BubblePosition.single);
      // The system message itself is always single.
      expect(ChatHelpers.bubblePosition(messages, 1), BubblePosition.single);
      // The message after the system message doesn't group backward either.
      expect(ChatHelpers.bubblePosition(messages, 2), BubblePosition.single);
    });

    test('a day boundary breaks a run even for the same sender', () {
      final day1 = DateTime(2026, 7, 19, 23, 59);
      final day2 = DateTime(2026, 7, 20, 0, 1);
      final messages = [
        _msg(senderId: 1, timestamp: day1),
        _msg(senderId: 1, timestamp: day2),
      ];

      expect(ChatHelpers.bubblePosition(messages, 0), BubblePosition.single);
      expect(ChatHelpers.bubblePosition(messages, 1), BubblePosition.single);
    });

    test('different senders never group together', () {
      final base = DateTime(2026, 7, 19, 10, 0);
      final messages = [
        _msg(senderId: 1, timestamp: base),
        _msg(senderId: 2, timestamp: base.add(const Duration(minutes: 1))),
      ];

      expect(ChatHelpers.bubblePosition(messages, 0), BubblePosition.single);
      expect(ChatHelpers.bubblePosition(messages, 1), BubblePosition.single);
    });
  });

  group('ChatHelpers.relativeTimeShort', () {
    // relativeTimeShort measures elapsed time against DateTime.now(), so
    // these use short, safe-in-CI offsets from the real "now" rather than
    // literal fixed clocks (avoids depending on a fake clock injection).

    test('less than 60s elapsed -> "just now" (English fallback, l=null)',
        () {
      final timestamp = DateTime.now().subtract(const Duration(seconds: 10));
      expect(ChatHelpers.relativeTimeShort(timestamp, null), 'just now');
    });

    test('minutes elapsed -> "{m}m ago" (English fallback, l=null)', () {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 5));
      expect(ChatHelpers.relativeTimeShort(timestamp, null), '5m ago');
    });

    test('hours elapsed -> "{h}h ago" (English fallback, l=null)', () {
      final timestamp = DateTime.now().subtract(const Duration(hours: 3));
      expect(ChatHelpers.relativeTimeShort(timestamp, null), '3h ago');
    });

    test('boundary: exactly 1 minute elapsed is no longer "just now"', () {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 1));
      expect(ChatHelpers.relativeTimeShort(timestamp, null), '1m ago');
    });

    test('boundary: exactly 1 hour elapsed is no longer minutes-based', () {
      final timestamp = DateTime.now().subtract(const Duration(hours: 1));
      expect(ChatHelpers.relativeTimeShort(timestamp, null), '1h ago');
    });
  });
}
