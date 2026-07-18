import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';

class CommunityProvider {
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {if (token != null) 'Authorization': 'Token $token'};
  }

  Future<List<CommunityPost>> getFeed({int? districtId, String? category, int page = 1}) async {
    final qp = <String, String>{'page': '$page'};
    if (districtId != null) qp['district_id'] = '$districtId';
    if (category != null && category != 'all') qp['category'] = category;
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/').replace(queryParameters: qp);
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final results = (data['results'] as List?) ?? const [];
      return results.map((e) => CommunityPost.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load community feed (${resp.statusCode})');
  }

  Future<CommunityPost> createPost({
    required String category,
    required String body,
    int? districtId,
    double? lat,
    double? lng,
    String? countryCode,
    String? regionName,
    List<File> images = const [],
  }) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/');
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll(await _authHeaders())
      ..fields['category'] = category
      ..fields['body'] = body;
    if (districtId != null) req.fields['district_id'] = '$districtId';
    if (lat != null) req.fields['latitude'] = '$lat';
    if (lng != null) req.fields['longitude'] = '$lng';
    if (countryCode != null) req.fields['country_code'] = countryCode;
    if (regionName != null) req.fields['region_name'] = regionName;
    for (final img in images) {
      req.files.add(await http.MultipartFile.fromPath('images', img.path));
    }
    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to create post (${resp.statusCode})');
  }

  Future<CommunityPost> getPost(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/');
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to load post (${resp.statusCode})');
  }

  Future<Map<String, dynamic>> toggleLike(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/like/');
    final resp = await http.post(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle like (${resp.statusCode})');
  }

  Future<List<CommunityComment>> getComments(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/');
    final resp = await http.get(uri, headers: await _authHeaders());
    if (resp.statusCode == 200) {
      final list = (json.decode(resp.body) as List?) ?? const [];
      return list.map((e) => CommunityComment.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load comments (${resp.statusCode})');
  }

  Future<CommunityComment> addComment(int postId, String text) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/');
    final resp = await http.post(uri, headers: await _authHeaders(), body: {'text': text});
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityComment.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to add comment (${resp.statusCode})');
  }
}

final communityProvider = Provider<CommunityProvider>((ref) => CommunityProvider());

typedef CommunityFeedArgs = ({int? districtId, String? category});

final communityFeedProvider =
    FutureProvider.family<List<CommunityPost>, CommunityFeedArgs>((ref, args) {
  return ref.read(communityProvider).getFeed(
        districtId: args.districtId,
        category: args.category,
      );
});
