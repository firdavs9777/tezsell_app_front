import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/replies_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class CommentsService {
  Future<List<Comments>> getComments({required serviceId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl$SERVICES_URL/$serviceId/$COMMENT_URL'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      return (data as List)
          .map((postJson) => Comments.fromJson(postJson))
          .toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comments> createComment({required title, required id}) async {
    final url = Uri.parse('$baseUrl$SERVICES_URL/$id$COMMENT_URL/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.post(
      url,
      body: jsonEncode({
        'text': title,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Comments.fromJson(
          data); // Assuming 'data' is a map representing the new moment
    } else {
      throw Exception('Failed to create moment');
    }
  }

  Future<Comments> editComment(
      {required title, required serviceId, required commentId}) async {
    final url =
        Uri.parse('$baseUrl$SERVICES_URL/$serviceId$COMMENT_URL/${commentId}/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.put(
      url,
      body: jsonEncode({
        'text': title,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Comments.fromJson(
          data); // Assuming 'data' is a map representing the new moment
    } else {
      throw Exception('Failed to create moment');
    }
  }

  Future<bool> deleteComment({required serviceId, required commentId}) async {
    final url =
        Uri.parse('$baseUrl$SERVICES_URL/$serviceId$COMMENT_URL/${commentId}/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token'
        },
      );

      // Return true for successful deletion (204 or 200)
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Error deleting comment: $e');
      return false;
    }
  }

  Future<List<Reply>> getReplies({required commmentId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/services/api$COMMENT_URL/$commmentId/replies/'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final repliesResponse = RepliesResponse.fromJson(data);

      if (repliesResponse.success) {
        return repliesResponse.data; // Return List<Reply>
      } else {
        return []; // Return empty list if not successful
      }
    } else {
      throw Exception('Failed to load replies');
    }
  }

  Future<Map<String, dynamic>> replyToComment({
    required String commentId,
    required String text,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('📤 Posting reply to comment: $commentId');
      print('   Reply text: $text');

      final response = await http.post(
        Uri.parse(
            '$baseUrl/services/api/comments/$commentId/replies/'), // Full URL with baseUrl
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Token $token',
        },
        body: json.encode({
          'text': text,
        }),
      );

      print('📊 Reply response status: ${response.statusCode}');
      print('📊 Reply response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData as Map<String, dynamic>;
      } else {
        throw Exception(
            'Failed to post reply: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error posting reply: $e');
      rethrow;
    }
  }

  Future<List<Comments>> getSingleComment({required String id}) async {
    try {
      print(id);
      final response = await http.get(Uri.parse(''));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List)
            .map((commentJson) => Comments.fromJson(commentJson))
            .toList();
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      throw Exception('Failed to get comment: $e');
    }
  }
}

final commentsServiceProvider = Provider((ref) => CommentsService());

final commentsProvider =
    FutureProviderFamily<List<Comments>, String>((ref, postId) async {
  // Fetch comments and return List<Comments>
  final service = ref.read(commentsServiceProvider);
  return service.getSingleComment(id: postId); // Replace with your logic
});
