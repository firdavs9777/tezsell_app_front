import 'package:flutter_test/flutter_test.dart';
import 'package:app/widgets/follow_list_sheet.dart';

/// Tests for the pure optimistic follow/unfollow state transition extracted
/// from `follow_list_sheet.dart` (`_FollowUserTileState._toggleFollow`) onto
/// `resolveFollowToggle`, so the flip-then-revert-on-failure logic can be
/// exercised without mounting the widget tree.
void main() {
  group('resolveFollowToggle', () {
    test('follow succeeds: was not following -> ends following', () {
      final result = resolveFollowToggle(wasFollowing: false, succeeded: true);
      expect(result, true);
    });

    test('unfollow succeeds: was following -> ends not following', () {
      final result = resolveFollowToggle(wasFollowing: true, succeeded: true);
      expect(result, false);
    });

    test('follow fails: was not following -> reverts to not following', () {
      final result = resolveFollowToggle(wasFollowing: false, succeeded: false);
      expect(result, false);
    });

    test('unfollow fails: was following -> reverts to following', () {
      final result = resolveFollowToggle(wasFollowing: true, succeeded: false);
      expect(result, true);
    });
  });
}
