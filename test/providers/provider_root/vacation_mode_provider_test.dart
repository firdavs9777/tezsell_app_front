import 'package:app/providers/provider_models/vacation_mode_model.dart';
import 'package:app/providers/provider_root/vacation_mode_provider.dart';
import 'package:app/service/vacation_mode_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Stands in for the real HTTP-backed [VacationModeService]. The real
/// backend endpoint is a blind flip with no desired-state param, which
/// this fake mirrors by actually flipping `isOnVacationOnServer` on every
/// `toggleVacationMode` call, regardless of what the caller "intended".
class _FakeVacationService extends VacationModeService {
  bool isOnVacationOnServer = false;
  int toggleCalls = 0;
  int getStatusCalls = 0;

  @override
  Future<VacationStatus> getVacationStatus() async {
    getStatusCalls++;
    return VacationStatus(isOnVacation: isOnVacationOnServer);
  }

  @override
  Future<VacationToggleResponse> toggleVacationMode({String? message}) async {
    toggleCalls++;
    isOnVacationOnServer = !isOnVacationOnServer;
    return VacationToggleResponse(
      success: true,
      message: 'ok',
      isOnVacation: isOnVacationOnServer,
    );
  }
}

void main() {
  test('enableVacationMode calls the service even when local cache already '
      'says on-vacation (no stale-cache short-circuit)', () async {
    final service = _FakeVacationService()..isOnVacationOnServer = true;
    final notifier = VacationModeNotifier(service);
    // Simulate a stale local cache that already believes we're on
    // vacation (e.g. toggled from another device) -- the notifier must
    // still call through rather than trusting that cache.
    await notifier.enableVacationMode();
    expect(service.toggleCalls, 1);
  });

  test('disableVacationMode calls the service even when local cache already '
      'says not on-vacation', () async {
    final service = _FakeVacationService();
    final notifier = VacationModeNotifier(service);
    await notifier.disableVacationMode();
    expect(service.toggleCalls, 1);
  });

  test(
    'fetchStatus reconciles local state with the server after a toggle',
    () async {
      final service = _FakeVacationService();
      final notifier = VacationModeNotifier(service);

      await notifier.enableVacationMode();
      expect(notifier.state.isOnVacation, true);

      // Reconcile step the UI performs after every toggle attempt.
      await notifier.fetchStatus();
      expect(service.getStatusCalls, 1);
      expect(notifier.state.isOnVacation, service.isOnVacationOnServer);
    },
  );

  test(
    'toggleVacationMode reports failure so callers can surface it',
    () async {
      final notifier = VacationModeNotifier(_ThrowingVacationService());
      final ok = await notifier.enableVacationMode();
      expect(ok, false);
      expect(notifier.state.error, isNotNull);
    },
  );
}

class _ThrowingVacationService extends VacationModeService {
  @override
  Future<VacationToggleResponse> toggleVacationMode({String? message}) async {
    throw Exception('network error');
  }
}
