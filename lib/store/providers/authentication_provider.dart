import 'package:flutter_riverpod/flutter_riverpod.dart';

class authStateProvider extends StateNotifier<List> {
  authStateProvider() : super([]);
}

final authStatesProvider =
    StateNotifierProvider<authStateProvider, List>((ref) {
  return authStateProvider();
});
