
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
}

