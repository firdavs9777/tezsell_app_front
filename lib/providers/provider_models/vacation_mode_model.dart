/// Vacation Mode Status Model
class VacationStatus {
  final bool isOnVacation;
  final String? vacationMessage;
  final DateTime? vacationStartedAt;

  VacationStatus({
    this.isOnVacation = false,
    this.vacationMessage,
    this.vacationStartedAt,
  });

  factory VacationStatus.fromJson(Map<String, dynamic> json) {
    return VacationStatus(
      isOnVacation: json['is_on_vacation'] ?? false,
      vacationMessage: json['vacation_message'],
      vacationStartedAt: json['vacation_started_at'] != null
          ? DateTime.parse(json['vacation_started_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_on_vacation': isOnVacation,
      'vacation_message': vacationMessage,
      'vacation_started_at': vacationStartedAt?.toIso8601String(),
    };
  }

  VacationStatus copyWith({
    bool? isOnVacation,
    String? vacationMessage,
    DateTime? vacationStartedAt,
  }) {
    return VacationStatus(
      isOnVacation: isOnVacation ?? this.isOnVacation,
      vacationMessage: vacationMessage ?? this.vacationMessage,
      vacationStartedAt: vacationStartedAt ?? this.vacationStartedAt,
    );
  }

  /// Get days on vacation
  int get daysOnVacation {
    if (!isOnVacation || vacationStartedAt == null) return 0;
    return DateTime.now().difference(vacationStartedAt!).inDays;
  }

  /// Display message or default
  String get displayMessage {
    if (vacationMessage != null && vacationMessage!.isNotEmpty) {
      return vacationMessage!;
    }
    return 'Currently unavailable';
  }
}

/// Vacation Mode Toggle Response
class VacationToggleResponse {
  final bool success;
  final String message;
  final bool isOnVacation;
  final DateTime? vacationStartedAt;

  VacationToggleResponse({
    required this.success,
    required this.message,
    required this.isOnVacation,
    this.vacationStartedAt,
  });

  factory VacationToggleResponse.fromJson(Map<String, dynamic> json) {
    return VacationToggleResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      isOnVacation: json['is_on_vacation'] ?? false,
      vacationStartedAt: json['vacation_started_at'] != null
          ? DateTime.parse(json['vacation_started_at'])
          : null,
    );
  }
}

/// Request model for enabling vacation mode
class VacationModeRequest {
  final String? message;

  VacationModeRequest({this.message});

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
    };
  }
}
