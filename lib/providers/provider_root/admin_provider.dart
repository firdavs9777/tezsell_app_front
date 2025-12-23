import 'dart:convert';
import 'package:app/config/app_config.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Admin Service for managing admin-related API calls
class AdminService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey);
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }

  /// Get admin dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.adminDashboardPath}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        // Backend returns: { 'success': true, 'data': {...}, 'generated_at': '...' }
        if (responseData['success'] == true && responseData['data'] != null) {
          // Return the data with stats nested as expected by the UI
          final data = responseData['data'] as Map<String, dynamic>;
          return {
            'stats': {
              'total_properties': data['overview']?['total_properties'] ?? 0,
              'total_agents': data['overview']?['total_agents'] ?? 0,
              'total_users': data['overview']?['total_users'] ?? 0,
              'total_views': data['user_activity']?['total_views'] ?? 0,
              'avg_sale_price': data['property_stats']?['avg_sale_price'] ?? 0,
              'total_portfolio_value': data['property_stats']?['total_property_value'] ?? 0,
              'avg_price_per_sqm': data['property_stats']?['avg_price_per_sqm'] ?? 0,
              'avg_views_per_property': data['engagement']?['avg_views_per_property'] ?? 0,
            },
            'last_update': responseData['generated_at'] ?? DateTime.now().toIso8601String(),
            'property_types_distribution': _extractPropertyTypesDistribution(data['property_stats']?['property_types']),
            'properties_by_city': _extractPropertiesByCity(data['property_stats']?['by_city']),
            'inquiry_types_distribution': _extractInquiryTypesDistribution(data['inquiries']?['by_type']),
            'agent_verification_rate': data['agent_stats']?['verification_rate'] ?? 0,
            'inquiry_response_rate': data['inquiries']?['response_rate'] ?? 0,
            'featured_properties': data['overview']?['featured_properties'] ?? 0,
            'properties_without_images': data['system_health']?['properties_without_images'] ?? 0,
            'missing_location_data': data['system_health']?['properties_missing_location'] ?? 0,
            'pending_agent_verification': data['system_health']?['agents_pending_verification'] ?? 0,
          };
        }
        // Fallback: return raw data if structure is different
        return responseData;
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      AppLogger.error('Error fetching dashboard stats: $e');
      rethrow;
    }
  }

  /// Helper to extract property types distribution
  Map<String, dynamic> _extractPropertyTypesDistribution(dynamic types) {
    if (types == null || types is! List) return {};
    final Map<String, dynamic> result = {};
    int total = 0;
    for (var type in types) {
      if (type is Map) {
        final countValue = type['count'] ?? 0;
        final count = countValue is num ? countValue.toInt() : (countValue is int ? countValue : 0);
        final typeName = type['property_type'] ?? '';
        if (typeName.isNotEmpty) {
          result[typeName] = count;
          total += count;
        }
      }
    }
    // Convert to percentages
    if (total > 0) {
      final Map<String, dynamic> percentages = {};
      result.forEach((key, value) {
        final valueNum = value is num ? value.toDouble() : (value is int ? value.toDouble() : 0.0);
        percentages[key] = (valueNum / total * 100);
      });
      return percentages;
    }
    return result;
  }

  /// Helper to extract properties by city
  Map<String, dynamic> _extractPropertiesByCity(dynamic cities) {
    if (cities == null || cities is! List) return {};
    final Map<String, dynamic> result = {};
    for (var city in cities) {
      if (city is Map) {
        final cityName = city['city'] ?? '';
        final countValue = city['count'] ?? 0;
        final count = countValue is num ? countValue.toInt() : (countValue is int ? countValue : 0);
        if (cityName.isNotEmpty) {
          result[cityName] = count;
        }
      }
    }
    return result;
  }

  /// Helper to extract inquiry types distribution
  Map<String, dynamic> _extractInquiryTypesDistribution(dynamic inquiries) {
    if (inquiries == null || inquiries is! List) return {};
    final Map<String, dynamic> result = {};
    for (var inquiry in inquiries) {
      if (inquiry is Map) {
        final type = inquiry['inquiry_type'] ?? '';
        final countValue = inquiry['count'] ?? 0;
        final count = countValue is num ? countValue.toInt() : (countValue is int ? countValue : 0);
        if (type.isNotEmpty) {
          result[type] = count;
        }
      }
    }
    return result;
  }

  /// Get all reports with optional filters
  Future<Map<String, dynamic>> getReports({
    String? status,
    String? contentType,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null) queryParams['status'] = status;
      if (contentType != null) queryParams['content_type'] = contentType;

      final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.adminReportsPath}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      AppLogger.error('Error fetching reports: $e');
      rethrow;
    }
  }

  /// Update report status
  Future<Map<String, dynamic>> updateReportStatus({
    required int reportId,
    required String status,
    String? action,
    String? reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'status': status,
        if (action != null) 'action': action,
        if (reason != null) 'reason': reason,
      };

      final url = AppConfig.adminReportUpdatePath.replaceAll('{id}', reportId.toString());
      final response = await http.patch(
        Uri.parse('${AppConfig.baseUrl}$url'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to update report status');
      }
    } catch (e) {
      AppLogger.error('Error updating report status: $e');
      rethrow;
    }
  }

  /// Get all users with optional filters
  Future<Map<String, dynamic>> getUsers({
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null) queryParams['search'] = search;
      if (isActive != null) queryParams['is_active'] = isActive.toString();

      final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.adminUsersPath}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      AppLogger.error('Error fetching users: $e');
      rethrow;
    }
  }

  /// Suspend a user
  Future<Map<String, dynamic>> suspendUser({
    required int userId,
    required String reason,
    int? durationDays,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'reason': reason,
        if (durationDays != null) 'duration_days': durationDays,
      };

      final url = AppConfig.adminUserSuspendPath.replaceAll('{id}', userId.toString());
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$url'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to suspend user');
      }
    } catch (e) {
      AppLogger.error('Error suspending user: $e');
      rethrow;
    }
  }

  /// Ban a user
  Future<Map<String, dynamic>> banUser({
    required int userId,
    required String reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {'reason': reason};

      final url = AppConfig.adminUserBanPath.replaceAll('{id}', userId.toString());
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$url'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to ban user');
      }
    } catch (e) {
      AppLogger.error('Error banning user: $e');
      rethrow;
    }
  }

  /// Get content (products, services, properties) with filters
  Future<Map<String, dynamic>> getContent({
    String? contentType, // 'product', 'service', 'property'
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (contentType != null) queryParams['content_type'] = contentType;
      if (search != null) queryParams['search'] = search;
      if (isActive != null) queryParams['is_active'] = isActive.toString();

      final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.adminContentPath}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load content');
      }
    } catch (e) {
      AppLogger.error('Error fetching content: $e');
      rethrow;
    }
  }

  /// Remove content
  Future<Map<String, dynamic>> removeContent({
    required int contentId,
    required String contentType,
    required String reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'content_type': contentType,
        'reason': reason,
      };

      final url = AppConfig.adminContentRemovePath.replaceAll('{id}', contentId.toString());
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$url'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to remove content');
      }
    } catch (e) {
      AppLogger.error('Error removing content: $e');
      rethrow;
    }
  }

  /// Get admin statistics (uses dashboard data)
  Future<Map<String, dynamic>> getStatistics() async {
    // Use dashboard stats which includes comprehensive statistics
    return await getDashboardStats();
  }

  /// Get dashboard charts data
  Future<Map<String, dynamic>> getDashboardCharts() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.adminDashboardChartsPath}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          return responseData['data'] as Map<String, dynamic>;
        }
        return responseData;
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load chart data');
      }
    } catch (e) {
      AppLogger.error('Error fetching dashboard charts: $e');
      rethrow;
    }
  }

  /// Get pending agent applications
  Future<Map<String, dynamic>> getPendingAgentApplications({
    String? status,
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final headers = await _getHeaders();
      final queryParams = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null) queryParams['status'] = status;
      if (search != null) queryParams['search'] = search;

      final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.adminPendingAgentsPath}')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to load pending agent applications');
      }
    } catch (e) {
      AppLogger.error('Error fetching pending agents: $e');
      rethrow;
    }
  }

  /// Verify or reject an agent
  Future<Map<String, dynamic>> verifyAgent({
    required int agentId,
    required String action, // 'approve' or 'reject'
    String? reason,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = {
        'action': action,
        if (reason != null) 'reason': reason,
      };

      final url = AppConfig.adminVerifyAgentPath.replaceAll('{id}', agentId.toString());
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}$url'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin privileges required.');
      } else {
        throw Exception('Failed to ${action} agent');
      }
    } catch (e) {
      AppLogger.error('Error verifying agent: $e');
      rethrow;
    }
  }

  /// Get total agents count from agents API
  Future<int> getTotalAgents() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.realEstateAgentsPath}?page_size=1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['count'] ?? 0;
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error fetching total agents: $e');
      return 0;
    }
  }

  /// Get total properties from stats API
  Future<int> getTotalProperties() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.realEstateStatsPath}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return data['data']['total_properties'] ?? 0;
        }
      }
      return 0;
    } catch (e) {
      AppLogger.error('Error fetching total properties: $e');
      return 0;
    }
  }

  /// Get total users from users API (admin only)
  Future<Map<String, dynamic>> getTotalUsersAndAgents() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}${AppConfig.usersPath}?page_size=1'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null && data['data']['statistics'] != null) {
          final stats = data['data']['statistics'];
          return {
            'total_users': stats['total_users'] ?? 0,
            'total_agents': stats['total_agents'] ?? 0,
            'verified_agents': stats['verified_agents'] ?? 0,
            'pending_agents': stats['pending_agents'] ?? 0,
          };
        }
      }
      return {
        'total_users': 0,
        'total_agents': 0,
        'verified_agents': 0,
        'pending_agents': 0,
      };
    } catch (e) {
      AppLogger.error('Error fetching total users: $e');
      // Return zeros if not admin or API not available
      return {
        'total_users': 0,
        'total_agents': 0,
        'verified_agents': 0,
        'pending_agents': 0,
      };
    }
  }

  /// Get comprehensive statistics using new APIs
  Future<Map<String, dynamic>> getStatisticsFromNewAPIs() async {
    try {
      // Fetch all statistics in parallel
      final results = await Future.wait([
        getTotalAgents(),
        getTotalProperties(),
        getTotalUsersAndAgents(),
      ]);

      final totalAgents = results[0] as int;
      final totalProperties = results[1] as int;
      final usersData = results[2] as Map<String, dynamic>;

      return {
        'total_agents': totalAgents,
        'total_properties': totalProperties,
        'total_users': usersData['total_users'] ?? 0,
        'verified_agents': usersData['verified_agents'] ?? 0,
        'pending_agents': usersData['pending_agents'] ?? 0,
      };
    } catch (e) {
      AppLogger.error('Error fetching statistics from new APIs: $e');
      rethrow;
    }
  }
}

// Riverpod provider
final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

