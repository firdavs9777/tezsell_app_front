import 'notification_model.dart';

class NotificationResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationModel> results;

  NotificationResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => NotificationModel.fromJson(item))
              .toList() ??
          [],
    );
  }
}

