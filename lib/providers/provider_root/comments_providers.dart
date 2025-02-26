import 'dart:convert';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';

import 'package:http/http.dart' as http;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsService {
  Future<List<Comments>> getComments({required serviceId}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl$SERVICES_URL/$serviceId$COMMENT_URL'),
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
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Comments.fromJson(
          data); // Assuming 'data' is a map representing the new moment
    } else {
      throw Exception('Failed to create moment');
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
