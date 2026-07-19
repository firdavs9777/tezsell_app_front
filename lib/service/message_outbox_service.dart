// lib/service/message_outbox_service.dart
//
// Persists chat messages that couldn't be sent (composed while offline, or
// whose send attempt failed/timed out) so they survive app restarts and can
// be replayed once the connection is back. Backed by SharedPreferences under
// a single JSON-encoded list key — deliberately simple, no sqlite/hive dep.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// One message queued for (re)send.
class OutboxEntry {
  final String localId;
  final int roomId;
  final String? content;
  final String type; // e.g. 'text' — mirrors MessageType.name
  final String? filePath;
  final DateTime createdAt;
  final int attempts;

  const OutboxEntry({
    required this.localId,
    required this.roomId,
    this.content,
    this.type = 'text',
    this.filePath,
    required this.createdAt,
    this.attempts = 0,
  });

  OutboxEntry copyWith({int? attempts}) {
    return OutboxEntry(
      localId: localId,
      roomId: roomId,
      content: content,
      type: type,
      filePath: filePath,
      createdAt: createdAt,
      attempts: attempts ?? this.attempts,
    );
  }

  factory OutboxEntry.fromJson(Map<String, dynamic> json) {
    return OutboxEntry(
      localId: json['local_id'] as String,
      roomId: json['room_id'] as int,
      content: json['content'] as String?,
      type: json['type'] as String? ?? 'text',
      filePath: json['file_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      attempts: json['attempts'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'room_id': roomId,
      'content': content,
      'type': type,
      'file_path': filePath,
      'created_at': createdAt.toIso8601String(),
      'attempts': attempts,
    };
  }
}

/// Pure-Dart, SharedPreferences-backed outbox queue. Constructor takes an
/// already-initialized `SharedPreferences` instance so it's trivially
/// testable with `SharedPreferences.setMockInitialValues`.
class MessageOutboxService {
  static const String storageKey = 'chat_outbox_v1';

  /// After this many failed attempts, an entry is dropped from the outbox
  /// and the message is left permanently `failed` (user must manually retry).
  static const int maxAttempts = 5;

  final SharedPreferences _prefs;

  MessageOutboxService(this._prefs);

  List<OutboxEntry> _readAll() {
    final raw = _prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = json.decode(raw) as List;
      return decoded
          .map((e) => OutboxEntry.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (_) {
      // Corrupt data shouldn't crash the app — treat as empty.
      return [];
    }
  }

  Future<void> _writeAll(List<OutboxEntry> entries) async {
    final raw = json.encode(entries.map((e) => e.toJson()).toList());
    await _prefs.setString(storageKey, raw);
  }

  /// All queued entries, in insertion/storage order.
  List<OutboxEntry> all() => _readAll();

  /// Enqueue a new entry, or update it in place if an entry with the same
  /// `localId` already exists (keeps the outbox de-duplicated by localId).
  Future<void> enqueue(OutboxEntry entry) async {
    final entries = _readAll();
    final idx = entries.indexWhere((e) => e.localId == entry.localId);
    if (idx != -1) {
      entries[idx] = entry;
    } else {
      entries.add(entry);
    }
    await _writeAll(entries);
  }

  /// Look up the currently-queued entry for a given `localId`, if any.
  /// Used to carry forward state (e.g. `attempts`) when re-enqueuing after
  /// a timeout, so re-enqueuing doesn't reset the retry counter.
  OutboxEntry? getByLocalId(String localId) {
    final entries = _readAll();
    for (final e in entries) {
      if (e.localId == localId) return e;
    }
    return null;
  }

  /// Pending entries for a room, oldest first (drain order).
  List<OutboxEntry> pendingFor(int roomId) {
    final entries = _readAll().where((e) => e.roomId == roomId).toList();
    entries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return entries;
  }

  /// Remove an entry once it has been sent successfully (or given up on).
  Future<void> remove(String localId) async {
    final entries = _readAll();
    entries.removeWhere((e) => e.localId == localId);
    await _writeAll(entries);
  }

  /// Increment the attempt counter for an entry. No-op if it's not queued.
  Future<void> incrementAttempts(String localId) async {
    final entries = _readAll();
    final idx = entries.indexWhere((e) => e.localId == localId);
    if (idx == -1) return;
    entries[idx] = entries[idx].copyWith(attempts: entries[idx].attempts + 1);
    await _writeAll(entries);
  }

  /// Clear the whole outbox. Mainly useful for tests / logout.
  Future<void> clear() async {
    await _prefs.remove(storageKey);
  }
}
