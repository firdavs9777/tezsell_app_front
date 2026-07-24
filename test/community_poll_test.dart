import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_models/community_post_model.dart';

/// Tests for the pure optimistic-vote math extracted from `poll_card.dart`
/// (`PollCard._optimisticVote`) onto `CommunityPoll.optimisticVote`, so it
/// can be exercised without pumping the widget.
void main() {
  const noVoteYet = CommunityPoll(
    question: 'Best day?',
    totalVotes: 0,
    myOptionId: null,
    options: [
      CommunityPollOption(id: 1, text: 'Saturday', voteCount: 0, percent: 0),
      CommunityPollOption(id: 2, text: 'Sunday', voteCount: 0, percent: 0),
    ],
  );

  test('first vote: total +1, my_option set, chosen option count +1 with 100%', () {
    final result = noVoteYet.optimisticVote(1);

    expect(result.totalVotes, 1);
    expect(result.myOptionId, 1);
    expect(result.options.firstWhere((o) => o.id == 1).voteCount, 1);
    expect(result.options.firstWhere((o) => o.id == 1).percent, 100);
    expect(result.options.firstWhere((o) => o.id == 2).voteCount, 0);
    expect(result.options.firstWhere((o) => o.id == 2).percent, 0);
  });

  test('switch vote: total unchanged, old option -1, new option +1', () {
    const votedForA = CommunityPoll(
      question: 'Best day?',
      totalVotes: 3,
      myOptionId: 1,
      options: [
        CommunityPollOption(id: 1, text: 'Saturday', voteCount: 2, percent: 67),
        CommunityPollOption(id: 2, text: 'Sunday', voteCount: 1, percent: 33),
      ],
    );

    final result = votedForA.optimisticVote(2);

    expect(result.totalVotes, 3, reason: 'switching a vote does not change the total');
    expect(result.myOptionId, 2);
    expect(result.options.firstWhere((o) => o.id == 1).voteCount, 1);
    expect(result.options.firstWhere((o) => o.id == 2).voteCount, 2);
  });

  test('tapping the already-selected option is a no-op (returns same instance)', () {
    const votedForA = CommunityPoll(
      question: 'Best day?',
      totalVotes: 1,
      myOptionId: 1,
      options: [
        CommunityPollOption(id: 1, text: 'Saturday', voteCount: 1, percent: 100),
        CommunityPollOption(id: 2, text: 'Sunday', voteCount: 0, percent: 0),
      ],
    );

    final result = votedForA.optimisticVote(1);

    expect(identical(result, votedForA), isTrue);
  });

  test('percents are always non-negative and each option is at most 100', () {
    const threeWay = CommunityPoll(
      question: 'Pick one',
      totalVotes: 7,
      myOptionId: 1,
      options: [
        CommunityPollOption(id: 1, text: 'A', voteCount: 5, percent: 71),
        CommunityPollOption(id: 2, text: 'B', voteCount: 1, percent: 14),
        CommunityPollOption(id: 3, text: 'C', voteCount: 1, percent: 14),
      ],
    );

    // Switch from A to C: exercises both a decrement and an increment
    // within the same recompute.
    final result = threeWay.optimisticVote(3);

    for (final option in result.options) {
      expect(option.percent, greaterThanOrEqualTo(0));
      expect(option.percent, lessThanOrEqualTo(100));
      expect(option.voteCount, greaterThanOrEqualTo(0));
    }
    expect(result.options.firstWhere((o) => o.id == 1).voteCount, 4);
    expect(result.options.firstWhere((o) => o.id == 3).voteCount, 2);
  });

  test('first vote on an empty poll (0 total) never divides by zero', () {
    const empty = CommunityPoll(
      question: 'Empty?',
      totalVotes: 0,
      myOptionId: null,
      options: [
        CommunityPollOption(id: 1, text: 'Only option', voteCount: 0, percent: 0),
      ],
    );

    final result = empty.optimisticVote(1);

    expect(result.totalVotes, 1);
    expect(result.options.first.percent, 100);
  });
}
