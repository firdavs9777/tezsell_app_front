import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/social_auth_service.dart';
import '../provider_models/social_auth_model.dart';

// ==================== Social Auth State ====================

class SocialAuthState {
  final List<SocialAccount> linkedAccounts;
  final List<LoginHistoryEntry> loginHistory;
  final bool isLoading;
  final bool isAuthenticating;
  final String? error;
  final SocialAuthResponse? lastAuthResponse;

  SocialAuthState({
    this.linkedAccounts = const [],
    this.loginHistory = const [],
    this.isLoading = false,
    this.isAuthenticating = false,
    this.error,
    this.lastAuthResponse,
  });

  SocialAuthState copyWith({
    List<SocialAccount>? linkedAccounts,
    List<LoginHistoryEntry>? loginHistory,
    bool? isLoading,
    bool? isAuthenticating,
    String? error,
    SocialAuthResponse? lastAuthResponse,
  }) {
    return SocialAuthState(
      linkedAccounts: linkedAccounts ?? this.linkedAccounts,
      loginHistory: loginHistory ?? this.loginHistory,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      error: error,
      lastAuthResponse: lastAuthResponse ?? this.lastAuthResponse,
    );
  }

  bool get hasGoogleLinked =>
      linkedAccounts.any((a) => a.provider == 'google');

  bool get hasAppleLinked =>
      linkedAccounts.any((a) => a.provider == 'apple');

  SocialAccount? get googleAccount {
    try {
      return linkedAccounts.firstWhere((a) => a.provider == 'google');
    } catch (_) {
      return null;
    }
  }

  SocialAccount? get appleAccount {
    try {
      return linkedAccounts.firstWhere((a) => a.provider == 'apple');
    } catch (_) {
      return null;
    }
  }
}

class SocialAuthNotifier extends StateNotifier<SocialAuthState> {
  final SocialAuthService _service;

  SocialAuthNotifier(this._service) : super(SocialAuthState());

  // ==================== Login Methods ====================

  Future<SocialAuthResponse> loginWithGoogle(String idToken, {String? photoUrl}) async {
    state = state.copyWith(isAuthenticating: true, error: null);

    try {
      final response = await _service.loginWithGoogle(idToken, photoUrl: photoUrl);
      state = state.copyWith(
        isAuthenticating: false,
        lastAuthResponse: response,
        error: response.success ? null : response.error,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isAuthenticating: false,
        error: e.toString(),
      );
      return SocialAuthResponse.error(e.toString());
    }
  }

  Future<SocialAuthResponse> loginWithApple({
    required String idToken,
    String? userEmail,
    String? userName,
  }) async {
    state = state.copyWith(isAuthenticating: true, error: null);

    try {
      final response = await _service.loginWithApple(
        idToken: idToken,
        userEmail: userEmail,
        userName: userName,
      );
      state = state.copyWith(
        isAuthenticating: false,
        lastAuthResponse: response,
        error: response.success ? null : response.error,
      );
      return response;
    } catch (e) {
      state = state.copyWith(
        isAuthenticating: false,
        error: e.toString(),
      );
      return SocialAuthResponse.error(e.toString());
    }
  }

  // ==================== Linked Accounts ====================

  Future<void> fetchLinkedAccounts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final accounts = await _service.getLinkedAccounts();
      state = state.copyWith(
        linkedAccounts: accounts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Map<String, dynamic>> linkGoogleAccount(String idToken) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _service.linkGoogleAccount(idToken);

      if (result['success'] == true) {
        await fetchLinkedAccounts();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> linkAppleAccount({
    required String idToken,
    String? userEmail,
    String? userName,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _service.linkAppleAccount(
        idToken: idToken,
        userEmail: userEmail,
        userName: userName,
      );

      if (result['success'] == true) {
        await fetchLinkedAccounts();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> unlinkAccount(String provider) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final result = await _service.unlinkAccount(provider);

      if (result['success'] == true) {
        state = state.copyWith(
          linkedAccounts: state.linkedAccounts
              .where((a) => a.provider != provider)
              .toList(),
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['error'] as String?,
        );
      }

      return result;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return {'success': false, 'error': e.toString()};
    }
  }

  // ==================== Login History ====================

  Future<void> fetchLoginHistory({int limit = 20}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final history = await _service.getLoginHistory(limit: limit);
      state = state.copyWith(
        loginHistory: history,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ==================== Helpers ====================

  bool get isGoogleSignInAvailable => _service.isGoogleSignInAvailable;
  bool get isAppleSignInAvailable => _service.isAppleSignInAvailable;

  Future<void> clearTokens() async {
    await _service.clearTokens();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearAuthResponse() {
    state = state.copyWith(lastAuthResponse: null);
  }
}

// ==================== Providers ====================

final socialAuthServiceProvider = Provider<SocialAuthService>((ref) {
  return SocialAuthService();
});

final socialAuthProvider =
    StateNotifierProvider<SocialAuthNotifier, SocialAuthState>((ref) {
  final service = ref.watch(socialAuthServiceProvider);
  return SocialAuthNotifier(service);
});

// Quick access providers
final linkedAccountsProvider = Provider<List<SocialAccount>>((ref) {
  return ref.watch(socialAuthProvider).linkedAccounts;
});

final hasGoogleLinkedProvider = Provider<bool>((ref) {
  return ref.watch(socialAuthProvider).hasGoogleLinked;
});

final hasAppleLinkedProvider = Provider<bool>((ref) {
  return ref.watch(socialAuthProvider).hasAppleLinked;
});

final isAuthenticatingProvider = Provider<bool>((ref) {
  return ref.watch(socialAuthProvider).isAuthenticating;
});

final loginHistoryProvider = Provider<List<LoginHistoryEntry>>((ref) {
  return ref.watch(socialAuthProvider).loginHistory;
});

// Availability providers
final googleSignInAvailableProvider = Provider<bool>((ref) {
  final service = ref.watch(socialAuthServiceProvider);
  return service.isGoogleSignInAvailable;
});

final appleSignInAvailableProvider = Provider<bool>((ref) {
  final service = ref.watch(socialAuthServiceProvider);
  return service.isAppleSignInAvailable;
});
