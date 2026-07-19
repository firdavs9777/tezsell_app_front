import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/message_model.dart';
import 'package:intl/intl.dart';

/// 🔥 NEW: Task 20 — a message's position within a run of consecutive
/// same-sender messages, used to pick grouped-bubble corner radii.
enum BubblePosition { single, first, middle, last }

class ChatHelpers {
  /// 🔥 NEW: Task 15 — sender-only edit window mirrored from the backend
  /// (`PUT .../messages/<id>/` returns 403 once a message is older than
  /// this). Used client-side to hide the Edit action proactively instead of
  /// letting the user hit the 403 first.
  static const Duration editWindow = Duration(minutes: 15);

  /// Whether [timestamp] is still within the sender-only edit window.
  static bool canEditMessage(DateTime timestamp) {
    return DateTime.now().difference(timestamp) <= editWindow;
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Format timestamp for display
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// 🔥 NEW: Task 20 — compact relative-time string for the presence
  /// subtitle's `chatLastSeen(time)` placeholder (e.g. "5m ago", "3h ago",
  /// "Mon 14:32", "Jul 4"). Shared by the app bar and anywhere else a short
  /// last-seen string is needed.
  ///
  /// 🔥 FIX: Task 20 review — the sub-24h branches are localized via
  /// [AppLocalizations] instead of hardcoded English so ru/uz don't get
  /// mixed-language text inside `chatLastSeen`. [l] may be null (e.g. in
  /// pure unit tests), in which case English fallbacks are used. The >=24h
  /// branches keep absolute `DateFormat`s but thread [l]'s locale through.
  static String relativeTimeShort(DateTime timestamp, AppLocalizations? l) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    if (diff.inMinutes < 1) {
      return l?.timeJustNow ?? 'just now';
    } else if (diff.inHours < 1) {
      return l?.timeMinutesShort(diff.inMinutes) ?? '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      return l?.timeHoursShort(diff.inHours) ?? '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return DateFormat.E(l?.localeName).add_Hm().format(timestamp);
    } else {
      return DateFormat.MMMd(l?.localeName).format(timestamp);
    }
  }

  /// 🔥 NEW: Task 20 — where [index] falls within a run of consecutive
  /// messages from the same sender in [sortedMessages] (ascending by
  /// timestamp). System messages and day boundaries always break a run so
  /// grouping never spans a date separator or a system pill.
  static BubblePosition bubblePosition(
    List<ChatMessage> sortedMessages,
    int index,
  ) {
    final message = sortedMessages[index];
    if (message.messageType == MessageType.system) {
      return BubblePosition.single;
    }

    bool groupsWith(ChatMessage other) =>
        other.messageType != MessageType.system &&
        other.sender.id == message.sender.id &&
        isSameDay(other.timestamp, message.timestamp);

    final sameAsPrev = index > 0 && groupsWith(sortedMessages[index - 1]);
    final sameAsNext = index < sortedMessages.length - 1 &&
        groupsWith(sortedMessages[index + 1]);

    if (!sameAsPrev && !sameAsNext) return BubblePosition.single;
    if (!sameAsPrev && sameAsNext) return BubblePosition.first;
    if (sameAsPrev && sameAsNext) return BubblePosition.middle;
    return BubblePosition.last;
  }
}

