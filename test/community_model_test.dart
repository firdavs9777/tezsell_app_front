import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';
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
        'total_votes': 3,
        'my_option_id': 101,
        'options': [
          {'id': 101, 'text': 'Saturday', 'vote_count': 2, 'percent': 66},
          {'id': 102, 'text': 'Sunday', 'vote_count': 1, 'percent': 33},
        ],
      },
    };
    final post = CommunityPost.fromJson(json);
    expect(post.viewCount, 42);
    expect(post.isEdited, true);
    expect(post.poll, isNotNull);
    expect(post.poll!.question, 'Best day?');
    expect(post.poll!.totalVotes, 3);
    expect(post.poll!.myOptionId, 101);
    expect(post.poll!.options, hasLength(2));
    expect(post.poll!.options[0].id, 101);
    expect(post.poll!.options[0].text, 'Saturday');
    expect(post.poll!.options[0].voteCount, 2);
    expect(post.poll!.options[0].percent, 66);
    expect(post.poll!.options[1].percent, 33);
  });

  test('CommunityPost.fromJson parses a poll with no votes yet (my_option_id null)', () {
    final json = {
      'id': 9,
      'category': 'general',
      'body': 'Pick a day',
      'author': {'id': 4, 'username': 'bek'},
      'region_name': 'Tashkent',
      'images': [],
      'like_count': 0,
      'comment_count': 0,
      'is_liked': false,
      'created_at': '2026-07-19T10:00:00Z',
      'poll': {
        'question': 'Best day?',
        'total_votes': 0,
        'my_option_id': null,
        'options': [
          {'id': 201, 'text': 'Saturday', 'vote_count': 0, 'percent': 0},
          {'id': 202, 'text': 'Sunday', 'vote_count': 0, 'percent': 0},
        ],
      },
    };
    final post = CommunityPost.fromJson(json);
    expect(post.poll!.myOptionId, isNull);
    expect(post.poll!.totalVotes, 0);
  });

  test('CommunityPost.copyWith swaps in a fresh poll', () {
    const oldPoll = CommunityPoll(
      question: 'Best day?',
      totalVotes: 1,
      myOptionId: 101,
      options: [
        CommunityPollOption(id: 101, text: 'Saturday', voteCount: 1, percent: 100),
        CommunityPollOption(id: 102, text: 'Sunday', voteCount: 0, percent: 0),
      ],
    );
    const newPoll = CommunityPoll(
      question: 'Best day?',
      totalVotes: 2,
      myOptionId: 102,
      options: [
        CommunityPollOption(id: 101, text: 'Saturday', voteCount: 1, percent: 50),
        CommunityPollOption(id: 102, text: 'Sunday', voteCount: 1, percent: 50),
      ],
    );
    final original = CommunityPost(
      id: 1,
      category: 'general',
      body: 'Pick a day',
      authorId: 4,
      authorName: 'bek',
      regionName: 'Tashkent',
      imageUrls: const [],
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
      createdAt: DateTime.parse('2026-07-19T10:00:00Z'),
      poll: oldPoll,
    );

    final updated = original.copyWith(poll: newPoll);

    expect(updated.poll!.myOptionId, 102);
    expect(updated.poll!.totalVotes, 2);
    expect(updated.poll!.options[1].voteCount, 1);
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

  test('CommunityComment.fromJson parses a top-level comment with nested replies', () {
    final json = {
      'id': 10,
      'user': {'id': 3, 'username': 'aziza'},
      'text': 'Great post!',
      'created_at': '2026-07-19T10:00:00Z',
      'like_count': 4,
      'is_liked': true,
      'reply_count': 2,
      'replies': [
        {
          'id': 11,
          'user': {'id': 4, 'username': 'bek'},
          'text': 'Agreed',
          'created_at': '2026-07-19T10:05:00Z',
          'like_count': 1,
          'is_liked': false,
        },
        {
          'id': 12,
          'user': {'id': 5, 'username': 'dono'},
          'text': 'Same here',
          'created_at': '2026-07-19T10:06:00Z',
        },
      ],
    };
    final comment = CommunityComment.fromJson(json);
    expect(comment.id, 10);
    expect(comment.userId, 3);
    expect(comment.userName, 'aziza');
    expect(comment.likeCount, 4);
    expect(comment.isLiked, true);
    expect(comment.replyCount, 2);
    expect(comment.replies, hasLength(2));
    expect(comment.replies[0].id, 11);
    expect(comment.replies[0].userName, 'bek');
    expect(comment.replies[0].likeCount, 1);
    expect(comment.replies[1].id, 12);
    // Fields absent from the reply payload fall back to safe defaults.
    expect(comment.replies[1].likeCount, 0);
    expect(comment.replies[1].isLiked, false);
    expect(comment.replies[1].replies, isEmpty);
  });

  test('CommunityComment.fromJson falls back safely when optional fields are absent', () {
    final json = {
      'id': 20,
      'user': {'username': 'guest'},
      'text': 'hi',
      'created_at': '2026-07-19T10:00:00Z',
    };
    final comment = CommunityComment.fromJson(json);
    expect(comment.userId, 0);
    expect(comment.likeCount, 0);
    expect(comment.isLiked, false);
    expect(comment.replyCount, 0);
    expect(comment.replies, isEmpty);
  });

  test('CommunityComment.copyWith overrides only the given fields', () {
    final original = CommunityComment(
      id: 1,
      userId: 3,
      text: 'Original',
      userName: 'aziza',
      createdAt: DateTime.parse('2026-07-19T10:00:00Z'),
      likeCount: 2,
      isLiked: false,
      replyCount: 1,
      replies: [
        CommunityComment(
          id: 2,
          userId: 4,
          text: 'reply',
          userName: 'bek',
          createdAt: DateTime.parse('2026-07-19T10:05:00Z'),
        ),
      ],
    );

    final updated = original.copyWith(likeCount: 3, isLiked: true);

    expect(updated.id, original.id);
    expect(updated.likeCount, 3);
    expect(updated.isLiked, true);
    expect(updated.replyCount, original.replyCount);
    expect(updated.replies, original.replies);
    expect(updated.text, original.text);
  });
}
