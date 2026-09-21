import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateProvider extends StateNotifier<List> {
  AuthStateProvider() : super([]);
}

final authStatesProvider =
    StateNotifierProvider<AuthStateProvider, List>((ref) {
  return AuthStateProvider();
});
