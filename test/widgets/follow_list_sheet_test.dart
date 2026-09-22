import 'package:flutter_test/flutter_test.dart';
import 'package:app/widgets/follow_list_sheet.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';

/// Tests for the pure optimistic follow/unfollow state transition extracted
/// from `follow_list_sheet.dart` (`_FollowUserTileState._toggleFollow`) onto
/// `resolveFollowToggle`, so the flip-then-revert-on-failure logic can be
/// exercised without mounting the widget tree.
void main() {
  _followStateResyncTests();

  _inlineTemperatureTests();

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

void _inlineTemperatureTests() {
  group('FollowUser inline temperature', () {
    test('parses the temperature the follow-list endpoint now serves', () {
      final user = FollowUser.fromJson({
        'id': 7,
        'username': 'someone',
        'is_following': true,
        'temperature': '41.2',
      });

      expect(user.temperature, 41.2);
    });

    test('is null against a backend that does not send the field', () {
      // The row then falls back to fetching the score per user, which is the
      // old behaviour — not a crash.
      final user = FollowUser.fromJson({'id': 7, 'username': 'someone'});

      expect(user.temperature, isNull);
    });

    test('survives an optimistic follow-status toggle', () {
      final user = FollowUser.fromJson({
        'id': 7,
        'username': 'someone',
        'is_following': false,
        'temperature': 38.0,
      });

      expect(user.copyWithFollowStatus(true).temperature, 38.0);
    });
  });
}

void _followStateResyncTests() {
  group('FollowUser identity for list keys', () {
    test('rows are distinguishable by id so a ValueKey is meaningful', () {
      final a = FollowUser.fromJson({'id': 1, 'username': 'a', 'is_following': true});
      final b = FollowUser.fromJson({'id': 2, 'username': 'b', 'is_following': false});

      expect(a.id == b.id, isFalse);
      expect(a.isFollowing, isNot(b.isFollowing));
    });

    test('a refresh can change is_following for the same id', () {
      // This is the case didUpdateWidget resyncs: same user, new server value.
      final before = FollowUser.fromJson({'id': 1, 'username': 'a', 'is_following': false});
      final after = FollowUser.fromJson({'id': 1, 'username': 'a', 'is_following': true});

      expect(before.id, after.id);
      expect(before.isFollowing, isNot(after.isFollowing));
    });
  });
}
