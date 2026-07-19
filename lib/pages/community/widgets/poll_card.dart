import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

/// Poll question + tappable options for a community post, with live,
/// animated results once the signed-in user has voted.
///
/// Renders the same widget in the feed (`compact: true`, denser rows) and
/// the post detail screen (`compact: false`, full size). Vote/revote is
/// optimistic: the tap immediately re-renders with locally-adjusted counts,
/// then reconciles with the server's response (or reverts on error).
///
/// This widget owns the poll's mutable state itself rather than relying on
/// the parent rebuilding with a fresh [CommunityPost] — the feed's post list
/// comes from a `FutureProvider` that isn't re-fetched on every vote, so the
/// state has to live somewhere durable. [onVoted] bubbles the
/// server-confirmed poll back up so the parent (feed card / detail page)
/// can keep its own copy of the post in sync too.
class PollCard extends ConsumerStatefulWidget {
  const PollCard({
    super.key,
    required this.postId,
    required this.poll,
    required this.onVoted,
    this.compact = false,
  });

  final int postId;
  final CommunityPoll poll;
  final ValueChanged<CommunityPoll> onVoted;
  final bool compact;

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  late CommunityPoll _poll;
  bool _voting = false;

  @override
  void initState() {
    super.initState();
    _poll = widget.poll;
  }

  @override
  void didUpdateWidget(covariant PollCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.poll, widget.poll) && !_voting) {
      _poll = widget.poll;
    }
  }

  /// Builds a locally-adjusted poll so the UI reflects the new vote
  /// immediately, without waiting on the network round-trip. Percents are
  /// recomputed from the adjusted counts; the server's response (which wins
  /// once it lands) is the source of truth.
  CommunityPoll _optimisticVote(int optionId) {
    final previousOptionId = _poll.myOptionId;
    if (previousOptionId == optionId) return _poll;

    final addedFirstVote = previousOptionId == null;
    final newTotal = addedFirstVote ? _poll.totalVotes + 1 : _poll.totalVotes;

    final adjustedOptions = _poll.options.map((o) {
      var count = o.voteCount;
      if (o.id == previousOptionId) count -= 1;
      if (o.id == optionId) count += 1;
      final percent = newTotal > 0 ? ((count * 100) / newTotal).round() : 0;
      return o.copyWith(voteCount: count, percent: percent);
    }).toList();

    return _poll.copyWith(
      totalVotes: newTotal,
      myOptionId: optionId,
      options: adjustedOptions,
    );
  }

  Future<void> _vote(int optionId) async {
    if (_voting) return;
    final previous = _poll;
    setState(() {
      _poll = _optimisticVote(optionId);
      _voting = true;
    });
    try {
      final result = await ref.read(communityProvider).votePoll(widget.postId, optionId);
      if (!mounted) return;
      setState(() => _poll = result);
      widget.onVoted(result);
    } catch (_) {
      if (mounted) {
        setState(() => _poll = previous);
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l?.errorGeneric ?? 'Something went wrong')),
        );
      }
    } finally {
      if (mounted) setState(() => _voting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final voted = _poll.myOptionId != null;
    final rowGap = widget.compact ? 6.0 : 8.0;

    return Container(
      margin: EdgeInsets.only(top: widget.compact ? 8 : 12),
      padding: EdgeInsets.all(widget.compact ? 10 : 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📊', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _poll.question,
                  style: (widget.compact ? theme.textTheme.bodyMedium : theme.textTheme.bodyLarge)
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          SizedBox(height: rowGap),
          for (final option in _poll.options) ...[
            voted
                ? _ResultRow(
                    option: option,
                    isMine: option.id == _poll.myOptionId,
                    compact: widget.compact,
                    onTap: _voting ? null : () => _vote(option.id),
                  )
                : _OptionRow(
                    option: option,
                    compact: widget.compact,
                    onTap: _voting ? null : () => _vote(option.id),
                  ),
            SizedBox(height: rowGap),
          ],
          Text(
            l?.communityPollVotes(_poll.totalVotes) ?? '${_poll.totalVotes} votes',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// Not-voted-yet state: a plain bordered, tappable row.
class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.option, required this.compact, required this.onTap});
  final CommunityPollOption option;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: compact ? 8 : 12),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(option.text, style: theme.textTheme.bodyMedium),
      ),
    );
  }
}

/// Voted state: an animated result bar showing the option's share of votes.
/// Still tappable — tapping a different option revotes.
class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.option,
    required this.isMine,
    required this.compact,
    required this.onTap,
  });
  final CommunityPollOption option;
  final bool isMine;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final widthFactor = (option.percent.clamp(0, 100)) / 100;
    final fillColor = isMine
        ? theme.colorScheme.primary.withValues(alpha: 0.18)
        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.10);
    final borderColor = isMine ? theme.colorScheme.primary : theme.colorScheme.outlineVariant;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: borderColor)),
          child: Stack(
            children: [
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedFractionallySizedBox(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    widthFactor: widthFactor,
                    heightFactor: 1,
                    child: Container(color: fillColor),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: compact ? 8 : 12),
                child: Row(
                  children: [
                    if (isMine) ...[
                      Icon(Icons.check_circle, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        option.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: isMine ? FontWeight.w600 : FontWeight.normal,
                          color: isMine ? null : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Text(
                      '${option.percent}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isMine ? FontWeight.w600 : FontWeight.normal,
                        color: isMine ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
