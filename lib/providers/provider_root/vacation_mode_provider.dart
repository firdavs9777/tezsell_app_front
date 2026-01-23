import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/vacation_mode_service.dart';
import '../provider_models/vacation_mode_model.dart';

// ==================== Vacation Mode State ====================

class VacationModeState {
  final VacationStatus status;
  final bool isLoading;
  final String? error;
  final String? message;

  VacationModeState({
    VacationStatus? status,
    this.isLoading = false,
    this.error,
    this.message,
  }) : status = status ?? VacationStatus();

  VacationModeState copyWith({
    VacationStatus? status,
    bool? isLoading,
    String? error,
    String? message,
  }) {
    return VacationModeState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      message: message,
    );
  }

  bool get isOnVacation => status.isOnVacation;
  String? get vacationMessage => status.vacationMessage;
  int get daysOnVacation => status.daysOnVacation;
}

class VacationModeNotifier extends StateNotifier<VacationModeState> {
  final VacationModeService _service;

  VacationModeNotifier(this._service) : super(VacationModeState());

  Future<void> fetchStatus() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final status = await _service.getVacationStatus();
      state = state.copyWith(
        status: status,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<bool> toggleVacationMode({String? message}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _service.toggleVacationMode(message: message);

      if (response.success) {
        state = state.copyWith(
          status: VacationStatus(
            isOnVacation: response.isOnVacation,
            vacationMessage: message,
            vacationStartedAt: response.vacationStartedAt,
          ),
          isLoading: false,
          message: response.message,
        );
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error: response.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  Future<bool> enableVacationMode({String? message}) async {
    if (state.isOnVacation) return true;
    return toggleVacationMode(message: message);
  }

  Future<bool> disableVacationMode() async {
    if (!state.isOnVacation) return true;
    return toggleVacationMode();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void clearMessage() {
    state = state.copyWith(message: null);
  }
}

// ==================== Providers ====================

final vacationModeServiceProvider = Provider<VacationModeService>((ref) {
  return VacationModeService();
});

final vacationModeProvider =
    StateNotifierProvider<VacationModeNotifier, VacationModeState>((ref) {
  final service = ref.watch(vacationModeServiceProvider);
  final notifier = VacationModeNotifier(service);
  notifier.fetchStatus();
  return notifier;
});

// Quick access providers
final isOnVacationProvider = Provider<bool>((ref) {
  return ref.watch(vacationModeProvider).isOnVacation;
});

final vacationMessageProvider = Provider<String?>((ref) {
  return ref.watch(vacationModeProvider).vacationMessage;
});
