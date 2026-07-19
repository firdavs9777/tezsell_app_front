// lib/service/draft_store.dart
//
// 🔥 NEW: Task 19 — per-room draft persistence (SharedPreferences key
// `chat_draft_<roomId>`), with an in-memory cache so the chat list can read
// every room's draft synchronously on each row build instead of doing a
// per-row async SharedPreferences read. [ensureLoaded] populates the cache
// once (by scanning for `chat_draft_*` keys); afterwards [get]/[set]/[clear]
// keep it in sync with disk.
import 'package:shared_preferences/shared_preferences.dart';

class DraftStore {
  DraftStore._internal();
  static final DraftStore instance = DraftStore._internal();

  static const _prefix = 'chat_draft_';

  final Map<int, String> _cache = {};
  bool _loaded = false;
  Future<void>? _loadingFuture;

  /// Populates the in-memory cache from disk. Safe to call multiple times —
  /// subsequent calls are no-ops once loaded (or await the same in-flight load).
  Future<void> ensureLoaded() {
    if (_loaded) return Future.value();
    return _loadingFuture ??= _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix));
    for (final key in keys) {
      final roomId = int.tryParse(key.substring(_prefix.length));
      final text = prefs.getString(key);
      if (roomId != null && text != null && text.isNotEmpty) {
        _cache[roomId] = text;
      }
    }
    _loaded = true;
  }

  /// Synchronous read from the in-memory cache — call [ensureLoaded] first.
  String? get(int roomId) => _cache[roomId];

  bool has(int roomId) => _cache.containsKey(roomId);

  /// Persists [text] as the draft for [roomId]. An empty/whitespace-only
  /// [text] clears the draft instead of storing an empty string.
  Future<void> set(int roomId, String text) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_prefix$roomId';
    if (text.trim().isEmpty) {
      await prefs.remove(key);
      _cache.remove(roomId);
    } else {
      await prefs.setString(key, text);
      _cache[roomId] = text;
    }
  }

  /// Clears the draft for [roomId] (e.g. after a successful send).
  Future<void> clear(int roomId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$roomId');
    _cache.remove(roomId);
  }
}
