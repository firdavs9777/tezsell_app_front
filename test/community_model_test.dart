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
    // Fields absent from this payload fall back to safe defaults.
    expect(post.viewCount, 0);
    expect(post.isEdited, false);
    expect(post.poll, isNull);
  });

  test('CommunityPost.fromJson parses view_count, is_edited and poll', () {
    final json = {
      'id': 8,
      'category': 'general',
      'body': 'Anyone up for a park cleanup?',
      'author': {'id': 4, 'username': 'bek'},
      'region_name': 'Tashkent',
      'images': [],
      'like_count': 0,
      'comment_count': 0,
      'is_liked': false,
      'created_at': '2026-07-19T10:00:00Z',
      'view_count': 42,
      'is_edited': true,
      'poll': {
        'question': 'Best day?',
        'options': ['Saturday', 'Sunday'],
      },
    };
    final post = CommunityPost.fromJson(json);
    expect(post.viewCount, 42);
    expect(post.isEdited, true);
    expect(post.poll, isNotNull);
    expect(post.poll!['question'], 'Best day?');
  });

  test('CommunityPost.copyWith overrides only the given fields', () {
    final original = CommunityPost(
      id: 1,
      category: 'question',
      body: 'Original body',
      authorId: 3,
      authorName: 'aziza',
      regionName: 'Tashkent',
      imageUrls: const [],
      likeCount: 2,
      commentCount: 1,
      isLiked: false,
      createdAt: DateTime.parse('2026-07-19T10:00:00Z'),
      viewCount: 5,
      isEdited: false,
    );

    final updated = original.copyWith(
      body: 'Edited body',
      category: 'general',
      isEdited: true,
    );

    expect(updated.id, original.id);
    expect(updated.body, 'Edited body');
    expect(updated.category, 'general');
    expect(updated.isEdited, true);
    expect(updated.likeCount, original.likeCount);
    expect(updated.viewCount, original.viewCount);
    expect(updated.authorName, original.authorName);
  });
}
