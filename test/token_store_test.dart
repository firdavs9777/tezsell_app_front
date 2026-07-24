import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/config/app_config.dart';
import 'package:app/service/token_store.dart';

/// In-memory fake so we can unit test [TokenStore] without touching
/// platform channels (the real impl delegates to FlutterSecureStorage).
class _FakeSecureStorage implements SecureTokenStorage {
  final Map<String, String> _data = {};
  int writeCount = 0;
  int deleteCount = 0;

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async {
    writeCount++;
    _data[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    deleteCount++;
    _data.remove(key);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TokenStore migration', () {
    test('migrates legacy SharedPreferences token into secure storage and '
        'deletes the legacy keys', () async {
      SharedPreferences.setMockInitialValues({
        'token': 'legacy-access-token',
        AppConfig.refreshTokenKey: 'legacy-refresh-token',
        'token_expires_at': '2026-08-01T00:00:00.000Z',
        'refresh_token_expires_at': '2026-09-01T00:00:00.000Z',
        // Non-secret data that must NOT be touched by migration.
        'userId': '42',
        'username': 'aziza',
      });

      final fakeStorage = _FakeSecureStorage();
      final store = TokenStore.forTesting(fakeStorage);

      await store.init();

      expect(await store.getAccessToken(), 'legacy-access-token');
      expect(await store.getRefreshToken(), 'legacy-refresh-token');
      expect(await store.getExpiresAt(), DateTime.parse('2026-08-01T00:00:00.000Z'));
      expect(store.accessTokenCached, 'legacy-access-token');

      // Legacy plaintext keys must be gone after a successful migration.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), isNull);
      expect(prefs.getString(AppConfig.accessTokenKey), isNull);
      expect(prefs.getString(AppConfig.refreshTokenKey), isNull);
      expect(prefs.getString('token_expires_at'), isNull);
      expect(prefs.getString('refresh_token_expires_at'), isNull);

      // Non-secret data untouched.
      expect(prefs.getString('userId'), '42');
      expect(prefs.getString('username'), 'aziza');
    });

    test('is idempotent — a second init() does not re-migrate or duplicate '
        'writes', () async {
      SharedPreferences.setMockInitialValues({
        'token': 'legacy-access-token',
      });

      final fakeStorage = _FakeSecureStorage();
      final store = TokenStore.forTesting(fakeStorage);

      await store.init();
      final writesAfterFirstInit = fakeStorage.writeCount;

      // Calling init() again (e.g. a second call site before boot finishes)
      // must not trigger another migration pass.
      await store.init();
      expect(fakeStorage.writeCount, writesAfterFirstInit);
      expect(await store.getAccessToken(), 'legacy-access-token');
    });

    test('does not migrate when there is no legacy token', () async {
      SharedPreferences.setMockInitialValues({});

      final fakeStorage = _FakeSecureStorage();
      final store = TokenStore.forTesting(fakeStorage);

      await store.init();

      expect(await store.getAccessToken(), isNull);
      expect(await store.getRefreshToken(), isNull);
      expect(fakeStorage.writeCount, 0);
    });

    test('an existing secure-storage session wins over stale legacy SP data '
        '(migration only runs when secure storage is empty)', () async {
      SharedPreferences.setMockInitialValues({
        'token': 'stale-legacy-token',
      });

      final fakeStorage = _FakeSecureStorage();
      // Simulate secure storage already having a real session (e.g. from an
      // earlier migration on a previous launch).
      await fakeStorage.write('secure_access_token', 'current-secure-token');

      final store = TokenStore.forTesting(fakeStorage);
      await store.init();

      expect(await store.getAccessToken(), 'current-secure-token');

      // Legacy SP key is untouched since migration didn't run.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), 'stale-legacy-token');
    });
  });

  group('TokenStore read/write/clear', () {
    test('setTokens updates cache and persists to secure storage', () async {
      SharedPreferences.setMockInitialValues({});
      final fakeStorage = _FakeSecureStorage();
      final store = TokenStore.forTesting(fakeStorage);
      await store.init();

      final expiresAt = DateTime.utc(2026, 8, 1);
      await store.setTokens(
        access: 'new-access',
        refresh: 'new-refresh',
        expiresAt: expiresAt,
      );

      expect(store.accessTokenCached, 'new-access');
      expect(await store.getAccessToken(), 'new-access');
      expect(await store.getRefreshToken(), 'new-refresh');
      expect(await store.getExpiresAt(), expiresAt);
      expect(await fakeStorage.read('secure_access_token'), 'new-access');
      expect(await fakeStorage.read('secure_refresh_token'), 'new-refresh');
    });

    test('clear removes tokens from cache and secure storage', () async {
      SharedPreferences.setMockInitialValues({});
      final fakeStorage = _FakeSecureStorage();
      final store = TokenStore.forTesting(fakeStorage);
      await store.init();
      await store.setTokens(access: 'to-be-cleared', refresh: 'refresh');

      await store.clear();

      expect(await store.getAccessToken(), isNull);
      expect(await store.getRefreshToken(), isNull);
      expect(await fakeStorage.read('secure_access_token'), isNull);
      expect(await fakeStorage.read('secure_refresh_token'), isNull);
    });
  });
}
