import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/community_post_model.dart';

void main() {
  test('CommunityPost.fromJson parses core fields', () {
    final json = {
      'id': 7,
      'category': 'question',
      'body': 'Any dentist open Sundays?',
      'author': {'id': 3, 'username': 'aziza'},
      'region_name': 'Tashkent',
      'images': [],
      'like_count': 2,
      'comment_count': 5,
      'is_liked': true,
      'created_at': '2026-07-19T10:00:00Z',
    };
    final post = CommunityPost.fromJson(json);
    expect(post.id, 7);
    expect(post.category, 'question');
    expect(post.authorName, 'aziza');
    expect(post.likeCount, 2);
    expect(post.isLiked, true);
  });
}
