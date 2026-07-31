import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/community/community_main.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

/// Returns page 1 as ten `#10x` posts and page 2 as ten `#20x` posts —
/// disjoint id ranges so a test can tell "did infinite-scroll append page 2"
/// apart from "is only page 1 showing" purely by which body text is present.
/// `getCounts`/`getCurrentUserId` are stubbed trivially since CommunityMain
/// watches them too but this test doesn't exercise anything gated on them.
class _FakeFeedCommunityProvider extends CommunityProvider {
  @override
  Future<List<CommunityPost>> getFeed({
    int? districtId,
    String? category,
    String? query,
    String? sort,
    int page = 1,
  }) async {
    if (page == 1) return List.generate(10, (i) => _post(100 + i));
    if (page == 2) return List.generate(10, (i) => _post(200 + i));
    return const [];
  }

  @override
  Future<Map<String, int>> getCounts({int? districtId}) async => const {};

  @override
  Future<int?> getCurrentUserId() async => null;
}

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

    test(
        'drops a duplicate id that appears in two different accumulated '
        'later-page fetches (the live feed shifted mid-scroll, so a later '
        'page re-returned a post already accumulated from an earlier one) — '
        'first occurrence wins, no duplicate ValueKey', () {
      final firstPage = [_post(20)];
      // Simulates `_extraPosts` already holding id 8 from a prior `_loadMore`
      // call, and a subsequent page re-fetch (after the feed shifted)
      // returning id 8 again alongside genuinely-new posts.
      final laterPages = [_post(9), _post(8), _post(8), _post(7)];

      final merged = mergeCommunityFeedPages(firstPage, laterPages);

      expect(merged.map((p) => p.id), [20, 9, 8, 7]);
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

  group('CommunityMain resets local pagination on an external invalidation',
      () {
    testWidgets(
        'clears accumulated later pages after '
        'communityFeedGenerationProvider is bumped from elsewhere — e.g. '
        'CommunityDetail editing/deleting a post while this screen sits '
        'mounted-but-occluded underneath it', (tester) async {
      final container = ProviderContainer(
        overrides: [
          communityProvider.overrideWithValue(_FakeFeedCommunityProvider()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: CommunityMain(districtId: null)),
        ),
      );
      // Two plain pumps (never `pumpAndSettle` here): the loading skeleton's
      // ShimmerEffect repeats forever, so `pumpAndSettle` would time out
      // while any FutureProvider is still pending.
      await tester.pump();
      await tester.pump();

      expect(find.text('Post #100'), findsOneWidget);
      expect(find.text('Post #200'), findsNothing);

      // Scroll the feed to the bottom to trigger infinite-scroll `_loadMore`.
      await tester.drag(
        find.byKey(const ValueKey('communityFeedListView')),
        const Offset(0, -5000),
      );
      await tester.pump();
      await tester.pump(); // let page 2's getFeed() future resolve
      await tester.pump();

      expect(find.text('Post #200'), findsOneWidget,
          reason: 'page 2 should have been appended by infinite scroll');

      // Simulate CommunityDetail (or the edit screen) invalidating the feed
      // from elsewhere while CommunityMain stays mounted underneath it —
      // exactly what `invalidateCommunityFeed` does, called directly on the
      // container since it takes a WidgetRef this test doesn't have one of.
      container.invalidate(communityFeedProvider);
      container.invalidate(communityCountsProvider);
      container.read(communityFeedGenerationProvider.notifier).state++;

      await tester.pump();
      await tester.pump();

      // The list is lazily built (ListView.builder), and the scroll
      // controller doesn't auto-jump back to the top just because the
      // dataset shrank — scroll back up so the (now sole, 10-item) page 1 is
      // actually in the built range before asserting on it.
      await tester.drag(
        find.byKey(const ValueKey('communityFeedListView')),
        const Offset(0, 5000),
      );
      await tester.pump();

      expect(find.text('Post #100'), findsOneWidget,
          reason: 'page 1 should still be showing');
      expect(find.text('Post #200'), findsNothing,
          reason: 'accumulated page 2 must be cleared by the external bump — '
              'otherwise the next _loadMore would fetch the wrong offset and '
              'silently skip a post');
    });
  });
}
