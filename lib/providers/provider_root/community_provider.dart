import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';
import 'package:app/service/token_store.dart';
import 'package:app/service/session_manager.dart';

class CommunityProvider {
  Future<Map<String, String>> _authHeaders() async {
    final token = await TokenStore.instance.getAccessToken();
    return {if (token != null) 'Authorization': 'Token $token'};
  }

  /// Parses a non-2xx [resp] body as a DRF-style field-error map and throws a
  /// [CommunityApiException] carrying it, so callers can surface the specific
  /// reason (e.g. an image size/type/count validation message) instead of a
  /// generic failure.
  ///
  /// The backend's custom exception handler nests raised `ValidationError`s
  /// under a `details` key (e.g. `{"success": false, "error": "...",
  /// "details": {"images": ["..."]}}`); a value there may be either a list
  /// (Django `ValidationError.messages`) or a bare string (a manually raised
  /// `ValidationError({'images': '...'})`) — both are normalized to
  /// `List<String>`. Falls back to [genericMessage] alone when the body isn't
  /// JSON, has no usable field map, or is a plain-text error page.
  Never _throwFieldError(http.Response resp, String genericMessage) {
    final fieldErrors = <String, List<String>>{};
    try {
      final decoded = json.decode(resp.body);
      if (decoded is Map<String, dynamic>) {
        final details = decoded['details'];
        final fields = details is Map<String, dynamic>
            ? details
            : (decoded.containsKey('details') ? null : decoded);
        if (fields != null) {
          for (final entry in fields.entries) {
            final value = entry.value;
            if (value is List) {
              fieldErrors[entry.key] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              fieldErrors[entry.key] = [value];
            }
          }
        }
      }
    } catch (_) {
      // Non-JSON body — fieldErrors stays empty, generic message is used.
    }
    throw CommunityApiException(resp.statusCode, fieldErrors, genericMessage);
  }

  Future<List<CommunityPost>> getFeed({
    int? districtId,
    String? category,
    String? query,
    String? sort,
    int page = 1,
  }) async {
    final qp = <String, String>{'page': '$page'};
    if (districtId != null) qp['district_id'] = '$districtId';
    if (category != null && category != 'all') qp['category'] = category;
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.length >= 2) qp['q'] = trimmedQuery;
    if (sort == 'popular') qp['sort'] = 'popular';
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/').replace(queryParameters: qp);
    final resp = await authedHttp(() async => http.get(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body);
      final results = (data['results'] as List?) ?? const [];
      return results.map((e) => CommunityPost.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Failed to load community feed (${resp.statusCode})');
  }

  /// Category post counts for the chip badges — six keys matching
  /// [communityCategories] minus `all` (question/recommend/free/lostfound/
  /// alert/general).
  Future<Map<String, int>> getCounts({int? districtId}) async {
    final qp = <String, String>{};
    if (districtId != null) qp['district_id'] = '$districtId';
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/counts/')
        .replace(queryParameters: qp.isEmpty ? null : qp);
    final resp = await authedHttp(() async => http.get(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      return data.map((k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0));
    }
    throw Exception('Failed to load community counts (${resp.statusCode})');
  }

  /// Author-only edit of a post's body/category.
  Future<CommunityPost> updatePost(
    int postId, {
    required String body,
    required String category,
  }) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/');
    final resp = await authedHttp(() async {
      final headers = await _authHeaders();
      headers['Content-Type'] = 'application/json';
      return http.patch(
        uri,
        headers: headers,
        body: json.encode({'body': body, 'category': category}),
      );
    });
    if (resp.statusCode == 200) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    _throwFieldError(resp, 'Failed to update post (${resp.statusCode})');
  }

  /// Author-only delete of a post.
  Future<void> deletePost(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/');
    final resp = await authedHttp(() async => http.delete(uri, headers: await _authHeaders()));
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception('Failed to delete post (${resp.statusCode})');
    }
  }

  /// The signed-in user's id (mirrors the storage key `authentication_service`
  /// writes on login), used to gate own-post edit/delete/report actions.
  Future<int?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('userId');
    if (raw == null) return null;
    return int.tryParse(raw);
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
    String? pollQuestion,
    List<String>? pollOptions,
  }) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/');
    // Rebuilt fresh on every call so a post-refresh retry doesn't replay an
    // already-consumed MultipartRequest (they're single-use).
    final resp = await authedHttp(() async {
      final req = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _authHeaders())
        ..fields['category'] = category
        ..fields['body'] = body;
      if (districtId != null) req.fields['district_id'] = '$districtId';
      if (lat != null) req.fields['latitude'] = '$lat';
      if (lng != null) req.fields['longitude'] = '$lng';
      if (countryCode != null) req.fields['country_code'] = countryCode;
      if (regionName != null) req.fields['region_name'] = regionName;
      if (pollQuestion != null && pollQuestion.isNotEmpty) {
        req.fields['poll_question'] = pollQuestion;
      }
      if (pollOptions != null && pollOptions.isNotEmpty) {
        req.fields['poll_options'] = json.encode(pollOptions);
      }
      for (final img in images) {
        req.files.add(await http.MultipartFile.fromPath('images', img.path));
      }
      final streamed = await req.send();
      return http.Response.fromStream(streamed);
    });
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    _throwFieldError(resp, 'Failed to create post (${resp.statusCode})');
  }

  Future<CommunityPost> getPost(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/');
    final resp = await authedHttp(() async => http.get(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      return CommunityPost.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to load post (${resp.statusCode})');
  }

  /// Casts (or changes) the signed-in user's vote on a post's poll, and
  /// returns the fresh poll payload (question/options/percents/my_option_id)
  /// so the caller can reconcile its optimistic local state.
  Future<CommunityPoll> votePoll(int postId, int optionId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/poll/vote/');
    final resp = await authedHttp(() async {
      final headers = await _authHeaders();
      headers['Content-Type'] = 'application/json';
      return http.post(
        uri,
        headers: headers,
        body: json.encode({'option_id': optionId}),
      );
    });
    if (resp.statusCode == 200) {
      return CommunityPoll.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to vote (${resp.statusCode})');
  }

  Future<Map<String, dynamic>> toggleLike(int postId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/like/');
    final resp = await authedHttp(() async => http.post(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle like (${resp.statusCode})');
  }

  /// Fetches one page of top-level comments (page_size 20 server-side).
  /// Each result carries its full, chronological `replies` list nested
  /// inline — replies are never paginated separately.
  Future<CommunityCommentsPage> getComments(int postId, {int page = 1}) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/')
        .replace(queryParameters: {'page': '$page'});
    final resp = await authedHttp(() async => http.get(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      final data = json.decode(resp.body) as Map<String, dynamic>;
      final results = (data['results'] as List?) ?? const [];
      final comments = results
          .map((e) => CommunityComment.fromJson(e as Map<String, dynamic>))
          .toList();
      final count = (data['count'] as num?)?.toInt() ?? comments.length;
      return (comments: comments, count: count, hasMore: data['next'] != null);
    }
    throw Exception('Failed to load comments (${resp.statusCode})');
  }

  Future<CommunityComment> addComment(int postId, String text, {int? parentId}) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/');
    final body = <String, String>{'text': text};
    if (parentId != null) body['parent'] = '$parentId';
    final resp = await authedHttp(
      () async => http.post(uri, headers: await _authHeaders(), body: body),
    );
    if (resp.statusCode == 200 || resp.statusCode == 201) {
      return CommunityComment.fromJson(json.decode(resp.body) as Map<String, dynamic>);
    }
    throw Exception('Failed to add comment (${resp.statusCode})');
  }

  /// Toggles the current user's like on a comment or reply.
  Future<Map<String, dynamic>> toggleCommentLike(int postId, int commentId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/$commentId/like/');
    final resp = await authedHttp(() async => http.post(uri, headers: await _authHeaders()));
    if (resp.statusCode == 200) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to toggle comment like (${resp.statusCode})');
  }

  /// Deletes a comment or reply (allowed for its author, or for the post's
  /// author).
  Future<void> deleteComment(int postId, int commentId) async {
    final uri = Uri.parse('$baseUrl$COMMUNITY_URL/$postId/comments/$commentId/');
    final resp = await authedHttp(() async => http.delete(uri, headers: await _authHeaders()));
    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception('Failed to delete comment (${resp.statusCode})');
    }
  }
}

/// Thrown by [CommunityProvider.createPost]/[updatePost] on a non-2xx
/// response, carrying the backend's per-field validation messages (when the
/// body could be parsed as one) alongside a generic fallback.
class CommunityApiException implements Exception {
  CommunityApiException(this.statusCode, this.fieldErrors, [this.message]);

  final int statusCode;

  /// Raw per-field messages, e.g. `{"images": ["Each photo must be under
  /// 5MB."]}`. Empty when the body wasn't a parseable field-error map.
  final Map<String, List<String>> fieldErrors;

  /// Generic fallback text (e.g. "Failed to create post (400)") used when
  /// [fieldErrors] is empty.
  final String? message;

  /// The single most relevant message to show the user: prefers `images`
  /// (the most common actionable validation — size/type/count), then the
  /// first message of any other field, then [message]/[fallback].
  String friendlyMessage({String fallback = 'Something went wrong'}) {
    final imageErrors = fieldErrors['images'];
    if (imageErrors != null && imageErrors.isNotEmpty) return imageErrors.first;
    for (final errors in fieldErrors.values) {
      if (errors.isNotEmpty) return errors.first;
    }
    return message ?? fallback;
  }

  @override
  String toString() => 'CommunityApiException($statusCode, $fieldErrors)';
}

/// One page of top-level comments plus enough envelope data to drive
/// pagination in the UI.
typedef CommunityCommentsPage = ({
  List<CommunityComment> comments,
  int count,
  bool hasMore,
});

final communityProvider = Provider<CommunityProvider>((ref) => CommunityProvider());

typedef CommunityFeedArgs = ({
  int? districtId,
  String? category,
  String? query,
  String sort,
});

// autoDispose: without it, every distinct (district, category, query, sort)
// combination — including one per search keystroke — mints a
// permanently-retained provider instance for the life of the app session,
// growing memory unbounded. Usages are all ref.watch (rebuilds while the
// screen is mounted) or ref.invalidate (recomputes on demand), neither of
// which depends on the cache surviving after the last listener unsubscribes.
final communityFeedProvider = FutureProvider.autoDispose
    .family<List<CommunityPost>, CommunityFeedArgs>((ref, args) {
  return ref.read(communityProvider).getFeed(
        districtId: args.districtId,
        category: args.category,
        query: args.query,
        sort: args.sort,
      );
});

/// Category post counts for the chip badges, keyed by district.
final communityCountsProvider = FutureProvider.autoDispose
    .family<Map<String, int>, int?>((ref, districtId) {
  return ref.read(communityProvider).getCounts(districtId: districtId);
});

/// The signed-in user's id, used app-wide in Community screens to gate
/// own-post edit/delete/report affordances.
final communityCurrentUserIdProvider = FutureProvider<int?>((ref) {
  return ref.read(communityProvider).getCurrentUserId();
});
