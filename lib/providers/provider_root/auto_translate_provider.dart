import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// "Auto-translate to my language" — when on, incoming messages from other
/// people are translated as they arrive instead of one tap at a time.
///
/// Persisted per user (`chat_auto_translate_<userId>`) so two accounts on one
/// device don't inherit each other's setting. Defaults to OFF: translation
/// costs a backend call per message, and most conversations are between people
/// who already share a language.
class AutoTranslateNotifier extends StateNotifier<bool> {
  AutoTranslateNotifier(this._userId) : super(false) {
    _load();
  }

  final int? _userId;

  static String _keyFor(int? userId) => 'chat_auto_translate_${userId ?? 0}';

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getBool(_keyFor(_userId));
      if (stored != null && mounted) state = stored;
    } catch (_) {
      // Non-fatal: fall back to the OFF default rather than blocking the room.
    }
  }

  Future<void> set(bool value) async {
    state = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyFor(_userId), value);
    } catch (_) {
      // The in-memory value still applies for this session.
    }
  }

  Future<void> toggle() => set(!state);
}

/// Keyed by user id so the preference follows the account, not the device.
final autoTranslateProvider =
    StateNotifierProvider.family<AutoTranslateNotifier, bool, int?>(
  (ref, userId) => AutoTranslateNotifier(userId),
);
