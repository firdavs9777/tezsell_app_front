import 'dart:async';

import 'package:app/service/authentication_service.dart';
import 'package:app/service/push_notification_service.dart';
import 'package:app/service/token_store.dart';
import 'package:app/store/providers/authentication_provider.dart';
import 'package:app/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Central session-failure handler for the reactive (401-triggered) refresh
/// flow — the counterpart to [TokenRefreshService]'s proactive 23h timer.
///
/// After F1's 24h access-token expiry, a cold app start can fire many
/// requests at once, all of which will 401 simultaneously. Without
/// single-flighting, each of those would kick off its own
/// `POST /accounts/refresh-token/` call — wasteful at best, and actively
/// harmful once F1's refresh-token rotation lands (a second concurrent
/// refresh call would invalidate the first one's rotated token, so the
/// *other* N-1 retries would fail even though the session was actually
/// still salvageable).
///
/// [tryRefresh] fixes this: every concurrent caller during a refresh awaits
/// the *same* in-flight `Future<bool>`.
class SessionManager {
  SessionManager._({
    required Future<Token?> Function() refresh,
    required Future<void> Function() clearSession,
  })  : _refresh = refresh,
        _clearSession = clearSession;

  /// Production singleton. Swappable in tests via [setInstanceForTesting].
  static SessionManager instance = SessionManager._(
    refresh: () => AuthenticationService(authStatesProvider).refreshToken(),
    clearSession: () => TokenStore.instance.clear(),
  );

  final Future<Token?> Function() _refresh;
  final Future<void> Function() _clearSession;

  Future<bool>? _inFlightRefresh;

  /// True while a session-expiry redirect is in progress, so a cold-start
  /// wave of 401s redirects to /login exactly once. Cleared when the session
  /// is re-established ([onAuthenticated] / a successful [tryRefresh]).
  bool _expiring = false;

  /// Call after a fresh login/register succeeds so a future expiry (e.g. the
  /// next 24h boundary) can redirect again.
  void onAuthenticated() => _expiring = false;

  /// Attempts a single silent token refresh. Safe to call concurrently:
  /// if a refresh is already in flight, callers piggyback on it instead of
  /// starting a new one — exactly one `refreshToken()` call happens per
  /// refresh "wave", no matter how many 401s triggered it.
  ///
  /// Returns `true` if the session now has a fresh access token, `false` if
  /// refresh failed (caller should treat this as "session is over" and call
  /// [onSessionExpired]).
  Future<bool> tryRefresh() {
    return _inFlightRefresh ??= _doRefresh().whenComplete(() {
      _inFlightRefresh = null;
    });
  }

  Future<bool> _doRefresh() async {
    try {
      final token = await _refresh();
      if (token != null) {
        _expiring = false; // session recovered
        return true;
      }
      return false;
    } catch (e) {
      AppLogger.error('SessionManager.tryRefresh error: $e');
      return false;
    }
  }

  /// Refresh failed (or a 401 arrived with no way to recover): clear the
  /// stored session and redirect to `/login`, showing a "session expired"
  /// message once the login screen is up.
  ///
  /// Fire-and-forget by design — callers (interceptors/http wrappers) are
  /// mid-request-teardown and shouldn't block on navigation.
  void onSessionExpired() {
    // Cold-start after the 24h expiry produces a wave of simultaneous 401s;
    // guard so we clear + redirect exactly once, not once per failed request
    // (which would re-run Login.initState and re-fire the snackbar).
    if (_expiring) return;
    _expiring = true;
    unawaited(_expireSession());
  }

  Future<void> _expireSession() async {
    try {
      await _clearSession();
    } catch (e) {
      AppLogger.error('SessionManager: error clearing session: $e');
    }

    final router = PushNotificationService().router;
    if (router != null) {
      router.go('/login', extra: const {'sessionExpired': true});
    } else {
      AppLogger.warning(
        'SessionManager: no router available to redirect to /login',
      );
    }
  }

  @visibleForTesting
  static void setInstanceForTesting(SessionManager manager) {
    instance = manager;
  }

  @visibleForTesting
  factory SessionManager.forTesting({
    required Future<Token?> Function() refresh,
    Future<void> Function()? clearSession,
  }) {
    return SessionManager._(
      refresh: refresh,
      clearSession: clearSession ?? () async {},
    );
  }
}

/// Signature for a thunk that performs one HTTP attempt. Implementations
/// MUST read the current access token fresh on every invocation (e.g. via
/// `TokenStore.instance.getAccessToken()` inside the closure body) — the
/// retry attempt reuses the exact same thunk, and a closed-over stale token
/// would defeat the whole point of refreshing first.
typedef HttpAttempt<T> = Future<T> Function();

/// Runs [attempt] and, if the response looks like an auth failure (per
/// [isUnauthorized], defaulting to `statusCode == 401`), performs one
/// single-flighted silent refresh via [SessionManager.tryRefresh] and retries
/// [attempt] exactly once with the refreshed token. If refresh fails, forces
/// [SessionManager.onSessionExpired] and returns the original (401) result.
///
/// Used for the `package:http`-based services that build a `Dio`-less
/// request pipeline by hand (community_provider, chat_api_service).
Future<T> authedHttp<T>(
  HttpAttempt<T> attempt, {
  bool Function(T result)? isUnauthorized,
}) async {
  final isUnauthorizedCheck = isUnauthorized ?? _defaultIsUnauthorized;

  final result = await attempt();
  if (!isUnauthorizedCheck(result)) {
    return result;
  }

  final refreshed = await SessionManager.instance.tryRefresh();
  if (!refreshed) {
    SessionManager.instance.onSessionExpired();
    return result;
  }

  return attempt();
}

bool _defaultIsUnauthorized(dynamic result) {
  try {
    // Works for http.Response (and anything else exposing statusCode).
    return result.statusCode == 401;
  } catch (_) {
    return false;
  }
}
