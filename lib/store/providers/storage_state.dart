import 'package:app/service/authentication_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:riverpod/riverpod.dart';

// Constants
const String isAuthenticatedKey = 'IS_AUTHENTICATED_KEY';
const String authenticatedUserPhonenumberKey = 'AUTHENTICATED_USER_EMAIL_KEY';

// Provider for accessing SharedPreferences
final sharedPrefProvider = Provider((_) async {
  return await SharedPreferences.getInstance();
});

// Provider for setting authentication state
final setAuthStateProvider =
    StateProvider<AuthenticationService?>((ref) => null);

// Provider for setting isAuthenticated in SharedPreferences
final setIsAuthenticatedProvider =
    StateProvider.family<void, bool>((ref, isAuth) async {
  final prefs = await ref.watch(sharedPrefProvider);
  final check = await ref.watch(setAuthStateProvider);
  prefs.setBool(isAuthenticatedKey, isAuth);
});

// Provider for setting authenticated user email in SharedPreferences
final setAuthenticatedUserProvider =
    StateProvider.family<void, String>((ref, phoneNumber) async {
  final prefs = await ref.watch(sharedPrefProvider);
  final check = await ref.watch(setAuthStateProvider);
  prefs.setString(authenticatedUserPhonenumberKey, phoneNumber);
});

// Provider for getting isAuthenticated value from SharedPreferences
final getIsAuthenticatedProvider = FutureProvider<bool>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);
  ref.watch(setAuthStateProvider);
  return prefs.getBool(isAuthenticatedKey) ?? false;
});

// Provider for getting authenticated user email from SharedPreferences
final getAuthenticatedUserProvider = FutureProvider<String>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);

  final check = await ref.watch(setAuthStateProvider);
  return prefs.getString(authenticatedUserPhonenumberKey) ?? '';
});

// Provider for resetting SharedPreferences
final resetStorage = StateProvider<dynamic>((ref) async {
  final prefs = await ref.watch(sharedPrefProvider);
  final isCleared = await prefs.clear();
  return isCleared;
});
