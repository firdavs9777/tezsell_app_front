import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:app/service/authentication_service.dart';
import 'package:app/service/session_manager.dart';

void main() {
  group('SessionManager.tryRefresh single-flight', () {
    test('two concurrent callers share one refresh call', () async {
      var refreshCallCount = 0;
      final gate = Completer<void>();

      final manager = SessionManager.forTesting(
        refresh: () async {
          refreshCallCount++;
          // Block until the test releases the gate, simulating a slow
          // network round-trip so both callers are guaranteed to overlap.
          await gate.future;
          return const Token(accessToken: 'new-access-token');
        },
      );

      // Fire two concurrent 401-triggered refreshes (mirrors many requests
      // 401ing at once on cold start after F1's 24h expiry).
      final first = manager.tryRefresh();
      final second = manager.tryRefresh();

      // Let both attempts reach the (shared) in-flight future before
      // resolving it.
      await Future<void>.delayed(Duration.zero);
      gate.complete();

      final results = await Future.wait([first, second]);

      expect(refreshCallCount, 1,
          reason: 'concurrent 401s must trigger exactly one refresh call');
      expect(results, [true, true]);
    });

    test('a later call after completion starts a fresh refresh', () async {
      var refreshCallCount = 0;
      final manager = SessionManager.forTesting(
        refresh: () async {
          refreshCallCount++;
          return Token(accessToken: 'token-$refreshCallCount');
        },
      );

      final r1 = await manager.tryRefresh();
      final r2 = await manager.tryRefresh();

      expect(r1, true);
      expect(r2, true);
      expect(refreshCallCount, 2,
          reason: 'non-overlapping calls are independent refresh waves');
    });

    test('returns false and does not throw when refresh fails', () async {
      final manager = SessionManager.forTesting(
        refresh: () async => null,
      );

      expect(await manager.tryRefresh(), false);
    });

    test('returns false when the refresh call throws', () async {
      final manager = SessionManager.forTesting(
        refresh: () async => throw Exception('network error'),
      );

      expect(await manager.tryRefresh(), false);
    });

    test('concurrent callers during a failing refresh all see false',
        () async {
      var refreshCallCount = 0;
      final gate = Completer<void>();

      final manager = SessionManager.forTesting(
        refresh: () async {
          refreshCallCount++;
          await gate.future;
          return null; // refresh token invalid/expired
        },
      );

      final first = manager.tryRefresh();
      final second = manager.tryRefresh();

      await Future<void>.delayed(Duration.zero);
      gate.complete();

      final results = await Future.wait([first, second]);

      expect(refreshCallCount, 1);
      expect(results, [false, false]);
    });
  });
}
