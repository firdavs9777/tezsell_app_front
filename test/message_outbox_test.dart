import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/service/message_outbox_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  OutboxEntry entry(String localId, {int roomId = 1, DateTime? createdAt}) {
    return OutboxEntry(
      localId: localId,
      roomId: roomId,
      content: 'hello $localId',
      createdAt: createdAt ?? DateTime(2026, 1, 1),
    );
  }

  test('enqueue adds a new entry retrievable via pendingFor', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));

    final pending = outbox.pendingFor(1);
    expect(pending.length, 1);
    expect(pending.first.localId, 'a');
    expect(pending.first.content, 'hello a');
    expect(pending.first.attempts, 0);
  });

  test('persists across a fresh SharedPreferences instance (restore)', () async {
    final prefs1 = await SharedPreferences.getInstance();
    final outbox1 = MessageOutboxService(prefs1);
    await outbox1.enqueue(entry('a'));
    await outbox1.enqueue(entry('b'));

    // Simulate app restart: get a new SharedPreferences instance backed by
    // the same mock store.
    final prefs2 = await SharedPreferences.getInstance();
    final outbox2 = MessageOutboxService(prefs2);

    final restored = outbox2.all();
    expect(restored.length, 2);
    expect(restored.map((e) => e.localId), containsAll(['a', 'b']));
  });

  test('pendingFor drains oldest first (drain order)', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('c', createdAt: DateTime(2026, 1, 3)));
    await outbox.enqueue(entry('a', createdAt: DateTime(2026, 1, 1)));
    await outbox.enqueue(entry('b', createdAt: DateTime(2026, 1, 2)));

    final pending = outbox.pendingFor(1);
    expect(pending.map((e) => e.localId).toList(), ['a', 'b', 'c']);
  });

  test('enqueue with an existing localId updates in place (dedup)', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));
    await outbox.enqueue(
      OutboxEntry(
        localId: 'a',
        roomId: 1,
        content: 'updated content',
        createdAt: DateTime(2026, 1, 1),
        attempts: 2,
      ),
    );

    final pending = outbox.pendingFor(1);
    expect(pending.length, 1);
    expect(pending.first.content, 'updated content');
    expect(pending.first.attempts, 2);
  });

  test('remove drops the entry by localId', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));
    await outbox.enqueue(entry('b'));
    await outbox.remove('a');

    final pending = outbox.pendingFor(1);
    expect(pending.map((e) => e.localId).toList(), ['b']);
  });

  test('remove of a non-existent localId is a no-op', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));
    await outbox.remove('does-not-exist');

    expect(outbox.pendingFor(1).length, 1);
  });

  test('incrementAttempts bumps the counter, capped by caller logic at maxAttempts', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));

    for (var i = 0; i < MessageOutboxService.maxAttempts; i++) {
      await outbox.incrementAttempts('a');
    }

    final pending = outbox.pendingFor(1);
    expect(pending.first.attempts, MessageOutboxService.maxAttempts);
  });

  test('pendingFor only returns entries for the requested room', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a', roomId: 1));
    await outbox.enqueue(entry('b', roomId: 2));

    expect(outbox.pendingFor(1).map((e) => e.localId).toList(), ['a']);
    expect(outbox.pendingFor(2).map((e) => e.localId).toList(), ['b']);
  });

  test('getByLocalId returns the queued entry, or null if absent', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));

    expect(outbox.getByLocalId('a')?.localId, 'a');
    expect(outbox.getByLocalId('does-not-exist'), isNull);
  });

  test(
      'carry-forward re-enqueue (mirrors _markFailedAndEnqueue) preserves '
      'attempts instead of resetting it, so maxAttempts is reachable', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    // Simulate an entry that has already failed 3 times.
    await outbox.enqueue(entry('a'));
    for (var i = 0; i < 3; i++) {
      await outbox.incrementAttempts('a');
    }
    expect(outbox.getByLocalId('a')?.attempts, 3);

    // Simulate another ack-timeout re-enqueue for the same localId, using
    // the carry-forward pattern from ChatProvider._markFailedAndEnqueue:
    // look up the existing entry first and carry its attempts forward,
    // rather than constructing a fresh OutboxEntry(attempts: 0).
    final existing = outbox.getByLocalId('a');
    await outbox.enqueue(OutboxEntry(
      localId: 'a',
      roomId: 1,
      content: 'hello a',
      createdAt: DateTime(2026, 1, 1),
      attempts: existing?.attempts ?? 0,
    ));

    // Attempts must survive the re-enqueue, not reset to 0.
    expect(outbox.getByLocalId('a')?.attempts, 3);
  });

  test('clear empties the outbox', () async {
    final prefs = await SharedPreferences.getInstance();
    final outbox = MessageOutboxService(prefs);

    await outbox.enqueue(entry('a'));
    await outbox.clear();

    expect(outbox.all(), isEmpty);
  });
}
