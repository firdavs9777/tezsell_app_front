import 'package:shared_preferences/shared_preferences.dart';

/// Resolves the signed-in user's numeric id from locally persisted prefs
/// (the `userId` string written at login, see `authentication_service.dart`).
///
/// Screens reachable via a bare deep link or push notification (e.g.
/// [WriteReviewScreen]) can be built before other providers that also
/// expose a "current user id" (like chat's `currentUserIdProvider`) have
/// finished their own fire-and-forget async initialization. Reading prefs
/// directly avoids depending on that initialization order.
Future<int?> loadCurrentUserIdFromPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  final userIdStr = prefs.getString('userId');
  return userIdStr != null ? int.tryParse(userIdStr) : null;
}
