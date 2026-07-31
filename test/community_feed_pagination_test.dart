import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/community/community_main.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

CommunityPost _post(int id) => CommunityPost(
      id: id,
      category: 'general',
      body: 'Post #$id',
      authorId: 1,
      authorName: 'aziza',
      regionName: 'Tashkent',
      imageUrls: const [],
      likeCount: 0,
      commentCount: 0,
      isLiked: false,
      createdAt: DateTime.parse('2026-07-19T10:00:00Z'),
    );

void main() {
  group('mergeCommunityFeedPages (infinite-scroll append)', () {
    test('appends later pages after the first page in order', () {
      final firstPage = [_post(3), _post(2), _post(1)];
      final laterPages = [_post(0)];

      final merged = mergeCommunityFeedPages(firstPage, laterPages);

      expect(merged.map((p) => p.id), [3, 2, 1, 0]);
    });

    test('returns just the first page when nothing has been loaded yet', () {
      final firstPage = [_post(1), _post(2)];

      final merged = mergeCommunityFeedPages(firstPage, const []);

      expect(merged, firstPage);
    });

    test(
        'drops a later-page post that also reappears on a freshly refetched '
        'first page (e.g. a new post pushed everything else down one slot)',
        () {
      final firstPage = [_post(10), _post(9)];
      // Accumulated from a stale page 2 before the refetch — id 9 now
      // collides with the fresh first page.
      final laterPages = [_post(9), _post(8), _post(7)];

      final merged = mergeCommunityFeedPages(firstPage, laterPages);

      // No duplicate ids, and no duplicate ValueKey(9) in the rendered list.
      expect(merged.map((p) => p.id), [10, 9, 8, 7]);
      expect(merged.map((p) => p.id).toSet().length, merged.length);
    });
  });

  group('CommunityApiException.friendlyMessage', () {
    test('prefers the images field error over other fields', () {
      final e = CommunityApiException(400, {
        'images': ['Each photo must be under 5MB.'],
        'body': ['This field may not be blank.'],
      });

      expect(e.friendlyMessage(), 'Each photo must be under 5MB.');
    });

    test('falls back to the first message of any other field when there is '
        'no images error', () {
      final e = CommunityApiException(400, {
        'poll_question': ['Required when creating a poll.'],
      });

      expect(e.friendlyMessage(), 'Required when creating a poll.');
    });

    test('falls back to the generic message when fieldErrors is empty '
        '(e.g. a non-JSON body)', () {
      final e = CommunityApiException(500, {}, 'Failed to create post (500)');

      expect(e.friendlyMessage(fallback: 'Failed to post'), 'Failed to create post (500)');
    });

    test('falls back to the fallback param when both fieldErrors and '
        'message are empty', () {
      final e = CommunityApiException(500, {});

      expect(e.friendlyMessage(fallback: 'Failed to post'), 'Failed to post');
    });
  });
}
