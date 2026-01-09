import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/notification_model.dart';
import '../models/notification_response.dart';
import '../config/app_config.dart';
import 'authentication_service.dart';

class NotificationApiService {
  final AuthenticationService _authService;

  NotificationApiService(this._authService);

  Future<String?> _getToken() async {
    return await _authService.getStoredToken();
  }

  Map<String, String> _getHeaders(String? token) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Token $token',
      };

  /// Fetch notifications with optional filters
  Future<NotificationResponse> getNotifications({
    String? type,
    bool? isRead,
    int? page,
    int? pageSize,
  }) async {
    final token = await _getToken();
    final queryParams = <String, String>{};
    if (type != null) queryParams['type'] = type;
    if (isRead != null) queryParams['is_read'] = isRead.toString();
    if (page != null) queryParams['page'] = page.toString();
    if (pageSize != null) queryParams['page_size'] = pageSize.toString();

    final uri = Uri.parse(AppConfig.getNotificationsUrl())
        .replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      // Handle both paginated and non-paginated responses
      if (jsonData['results'] != null) {
        return NotificationResponse.fromJson(jsonData);
      } else {
        // Non-paginated response (list of notifications)
        return NotificationResponse(
          count: (jsonData as List).length,
          results: (jsonData as List)
              .map((item) => NotificationModel.fromJson(item))
              .toList(),
        );
      }
    } else {
      throw Exception('Failed to load notifications: ${response.statusCode}');
    }
  }

  /// Get unread count
  Future<int> getUnreadCount() async {
    final token = await _getToken();
    final uri = Uri.parse(AppConfig.getNotificationsUnreadCountUrl());
    final response = await http.get(uri, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['unread_count'] ?? 0;
    } else {
      throw Exception('Failed to load unread count: ${response.statusCode}');
    }
  }

  /// Mark notification as read
  Future<void> markAsRead(int notificationId) async {
    final token = await _getToken();
    final uri = Uri.parse('${AppConfig.getNotificationsUrl()}$notificationId/read/');
    final response = await http.patch(uri, headers: _getHeaders(token));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to mark as read: ${response.statusCode}');
    }
  }

  /// Mark all notifications as read
  Future<int> markAllAsRead() async {
    final token = await _getToken();
    final uri = Uri.parse(AppConfig.getNotificationsMarkAllReadUrl());
    final response = await http.post(uri, headers: _getHeaders(token));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['marked_count'] ?? 0;
    } else {
      throw Exception('Failed to mark all as read: ${response.statusCode}');
    }
  }

  /// Delete notification
  Future<void> deleteNotification(int notificationId) async {
    final token = await _getToken();
    final uri = Uri.parse('${AppConfig.getNotificationsUrl()}$notificationId/');
    final response = await http.delete(uri, headers: _getHeaders(token));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete notification: ${response.statusCode}');
    }
  }
}

