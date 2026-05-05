import 'package:app/l10n/app_localizations.dart';

/// Localized time formatting for chat. A drop-in companion to
/// [ChatHelpers] in `chat_helpers.dart`; call sites can migrate
/// incrementally.
class ChatTimeFormat {
  ChatTimeFormat._();

  /// Returns true when [a] and [b] fall on the same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Localized "X minutes/hours/days ago" / "Just now" / fallback to
  /// dd/MM/yyyy for messages older than a week.
  ///
  /// Returns the timestamp formatted relative to [reference] (defaults
  /// to [DateTime.now]) using the keys `time_just_now`, `time_minutes_ago`,
  /// `time_hours_ago`, `time_days_ago` defined in the ARBs.
  static String relative(
    AppLocalizations l,
    DateTime timestamp, {
    DateTime? reference,
  }) {
    final now = reference ?? DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inMinutes < 1) return l.time_just_now;
    if (diff.inHours < 1) return l.time_minutes_ago(diff.inMinutes);
    if (diff.inDays < 1) return l.time_hours_ago(diff.inHours);
    if (diff.inDays < 7) return l.time_days_ago(diff.inDays);

    return '${timestamp.day.toString().padLeft(2, '0')}/'
        '${timestamp.month.toString().padLeft(2, '0')}/'
        '${timestamp.year}';
  }
}
