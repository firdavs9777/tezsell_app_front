import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';

/// Thin storage seam so [TokenStore] can be unit tested without touching
/// platform channels. The real implementation delegates to
/// [FlutterSecureStorage]; tests can supply an in-memory fake.
abstract class SecureTokenStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class _FlutterSecureTokenStorage implements SecureTokenStorage {
  // Android: EncryptedSharedPreferences. iOS: Keychain (default).
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Single source of truth for auth tokens.
///
/// Tokens (access, refresh, expiry timestamps) are persisted in OS-level
/// secure storage (Keychain on iOS, EncryptedSharedPreferences on Android)
/// instead of plaintext SharedPreferences. `userId`/`username`/etc. are NOT
/// secret and continue to live in SharedPreferences untouched.
///
/// Because secure storage reads are async but many call sites throughout the
/// app build request headers synchronously-ish inside otherwise-async
/// functions, [init] loads everything into an in-memory cache once at app
/// startup (before any auth check runs — see `main.dart`). After that,
/// [getAccessToken]/[getRefreshToken]/[getExpiresAt] resolve instantly from
/// the cache (still `Future`-typed for call-site compatibility), while
/// [setTokens]/[clear] update both the cache and secure storage.
class TokenStore {
  TokenStore._(this._storage);

  /// Production singleton.
  static TokenStore instance = TokenStore._(_FlutterSecureTokenStorage());

  final SecureTokenStorage _storage;

  static const _kAccessToken = 'secure_access_token';
  static const _kRefreshToken = 'secure_refresh_token';
  static const _kExpiresAt = 'secure_token_expires_at';
  static const _kRefreshExpiresAt = 'secure_refresh_token_expires_at';

  String? _accessTokenCache;
  String? _refreshTokenCache;
  DateTime? _expiresAtCache;
  DateTime? _refreshExpiresAtCache;

  bool _initialized = false;
  Future<void>? _initFuture;

  bool get isInitialized => _initialized;

  /// Sync-ish fast read for header-building call sites that only ever run
  /// after [init] has completed (i.e. after app startup).
  String? get accessTokenCached => _accessTokenCache;

  /// One-time boot initialization: loads secure storage into memory, and if
  /// secure storage is empty but legacy plaintext SharedPreferences keys
  /// exist, migrates them into secure storage and deletes the legacy keys.
  /// Safe to call multiple times (idempotent) and safe to call concurrently.
  Future<void> init() {
    return _initFuture ??= _init();
  }

  Future<void> _init() async {
    try {
      final existingAccess = await _storage.read(_kAccessToken);
      if (existingAccess == null || existingAccess.isEmpty) {
        await _migrateFromSharedPreferences();
      }

      _accessTokenCache = await _storage.read(_kAccessToken);
      _refreshTokenCache = await _storage.read(_kRefreshToken);

      final expiresAtStr = await _storage.read(_kExpiresAt);
      _expiresAtCache =
          expiresAtStr != null ? DateTime.tryParse(expiresAtStr) : null;

      final refreshExpiresAtStr = await _storage.read(_kRefreshExpiresAt);
      _refreshExpiresAtCache = refreshExpiresAtStr != null
          ? DateTime.tryParse(refreshExpiresAtStr)
          : null;
    } catch (e) {
      AppLogger.error('TokenStore init error: $e');
    } finally {
      _initialized = true;
    }
  }

  /// One-time legacy migration. Existing logged-in users keep their session
  /// — nothing is deleted unless it was successfully copied first.
  Future<void> _migrateFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final legacyAccess =
          prefs.getString(AppConfig.accessTokenKey) ?? prefs.getString('token');

      if (legacyAccess == null || legacyAccess.isEmpty) {
        return; // No legacy session to migrate.
      }

      final legacyRefresh = prefs.getString(AppConfig.refreshTokenKey);
      final legacyExpiresAt = prefs.getString('token_expires_at');
      final legacyRefreshExpiresAt = prefs.getString('refresh_token_expires_at');

      // Write the access token LAST: it is the skip-guard checked on the next
      // launch (a non-empty secure access token means "already migrated"). If
      // any refresh/expiry write throws first, the access token is never
      // written, so the next boot re-attempts the full migration instead of
      // stranding the refresh token in plaintext SP.
      if (legacyRefresh != null && legacyRefresh.isNotEmpty) {
        await _storage.write(_kRefreshToken, legacyRefresh);
      }
      if (legacyExpiresAt != null && legacyExpiresAt.isNotEmpty) {
        await _storage.write(_kExpiresAt, legacyExpiresAt);
      }
      if (legacyRefreshExpiresAt != null && legacyRefreshExpiresAt.isNotEmpty) {
        await _storage.write(_kRefreshExpiresAt, legacyRefreshExpiresAt);
      }
      await _storage.write(_kAccessToken, legacyAccess);

      // Only delete the legacy plaintext keys after the copy succeeded.
      await Future.wait([
        prefs.remove('token'),
        prefs.remove(AppConfig.accessTokenKey),
        prefs.remove(AppConfig.refreshTokenKey),
        prefs.remove('token_expires_in'),
        prefs.remove('token_expires_at'),
        prefs.remove('refresh_token_expires_in'),
        prefs.remove('refresh_token_expires_at'),
      ]);

      AppLogger.info(
        'TokenStore: migrated legacy plaintext token to secure storage',
      );
    } catch (e) {
      // If migration fails, leave legacy SP keys in place — existing
      // call sites that still fall back to `getStoredToken()` via
      // AuthenticationService will simply keep working against secure
      // storage being empty on this run; we'll retry migration next launch.
      AppLogger.error('TokenStore migration error: $e');
    }
  }

  Future<String?> getAccessToken() async {
    if (!_initialized) await init();
    return _accessTokenCache;
  }

  Future<String?> getRefreshToken() async {
    if (!_initialized) await init();
    return _refreshTokenCache;
  }

  Future<DateTime?> getExpiresAt() async {
    if (!_initialized) await init();
    return _expiresAtCache;
  }

  Future<DateTime?> getRefreshExpiresAt() async {
    if (!_initialized) await init();
    return _refreshExpiresAtCache;
  }

  /// Persist new tokens (login/register/refresh). Only non-null fields are
  /// updated; pass `refresh`/`expiresAt`/`refreshExpiresAt` as null to leave
  /// the previously stored value untouched.
  Future<void> setTokens({
    required String access,
    String? refresh,
    DateTime? expiresAt,
    DateTime? refreshExpiresAt,
  }) async {
    _accessTokenCache = access;
    final writes = <Future>[_storage.write(_kAccessToken, access)];

    if (refresh != null && refresh.isNotEmpty) {
      _refreshTokenCache = refresh;
      writes.add(_storage.write(_kRefreshToken, refresh));
    }
    if (expiresAt != null) {
      _expiresAtCache = expiresAt;
      writes.add(_storage.write(_kExpiresAt, expiresAt.toIso8601String()));
    }
    if (refreshExpiresAt != null) {
      _refreshExpiresAtCache = refreshExpiresAt;
      writes.add(
        _storage.write(_kRefreshExpiresAt, refreshExpiresAt.toIso8601String()),
      );
    }

    await Future.wait(writes);
    _initialized = true;
  }

  /// Clear all tokens (logout).
  Future<void> clear() async {
    _accessTokenCache = null;
    _refreshTokenCache = null;
    _expiresAtCache = null;
    _refreshExpiresAtCache = null;
    await Future.wait([
      _storage.delete(_kAccessToken),
      _storage.delete(_kRefreshToken),
      _storage.delete(_kExpiresAt),
      _storage.delete(_kRefreshExpiresAt),
    ]);
  }

  /// Test-only hook to swap in a fake [SecureTokenStorage] and reset state.
  @visibleForTesting
  static void setInstanceForTesting(TokenStore store) {
    instance = store;
  }

  @visibleForTesting
  factory TokenStore.forTesting(SecureTokenStorage storage) =>
      TokenStore._(storage);
}
