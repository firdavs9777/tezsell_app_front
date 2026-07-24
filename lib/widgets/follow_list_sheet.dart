import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/reviews_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/trust_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shared followers/following bottom sheet.
///
/// This used to exist as two near-identical copies
/// (`ProfileFollowListSheet` for the signed-in user's own profile and
/// `UserProfileFollowListSheet` for other users' profiles). Both callers
/// already resolved to the exact same data source --
/// [userFollowersProvider]/[userFollowingProvider], a `FutureProvider.family`
/// keyed by `userId` -- so there was no real data-path divergence to
/// preserve; the "own profile" caller simply passes the signed-in user's id
/// and the "other user" caller passes that profile's id. A single widget
/// parameterized by [userId]/[isFollowers]/[title] covers both call sites.
class FollowListSheet extends ConsumerWidget {
  const FollowListSheet({
    super.key,
    required this.title,
    required this.userId,
    required this.isFollowers,
  });

  final String title;
  final int userId;
  final bool isFollowers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = isFollowers
        ? ref.watch(userFollowersProvider(userId))
        : ref.watch(userFollowingProvider(userId));
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            Expanded(
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppErrorHandler.getErrorMessage(error),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ),
                data: (response) {
                  final l = AppLocalizations.of(context);
                  if (response.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isFollowers
                                ? (l?.profile_no_followers_yet ?? 'No followers yet')
                                : (l?.profile_no_following_yet ?? 'Not following anyone yet'),
                            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: response.results.length,
                    itemBuilder: (context, index) {
                      return _FollowUserTile(user: response.results[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Given whether the user was following before an optimistic tap and
/// whether the follow-service call that followed it ultimately succeeded,
/// returns what `isFollowing` should settle on.
///
/// Extracted as a pure top-level function so the optimistic-flip /
/// revert-on-failure logic in [_FollowUserTileState._toggleFollow] has a
/// unit test that doesn't need to mount the widget tree.
bool resolveFollowToggle({required bool wasFollowing, required bool succeeded}) {
  final optimistic = !wasFollowing;
  return succeeded ? optimistic : wasFollowing;
}

class _FollowUserTile extends ConsumerStatefulWidget {
  const _FollowUserTile({required this.user});

  final FollowUser user;

  @override
  ConsumerState<_FollowUserTile> createState() => _FollowUserTileState();
}

class _FollowUserTileState extends ConsumerState<_FollowUserTile> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;

    final wasFollowing = _isFollowing;
    // Optimistic: flip immediately so the tap feels instant, then revert
    // below if the request fails.
    setState(() {
      _isFollowing = !wasFollowing;
      _isLoading = true;
    });

    final profileService = ref.read(profileServiceProvider);
    bool succeeded = true;
    Object? failure;
    try {
      if (wasFollowing) {
        await profileService.unfollowUser(userId: widget.user.id);
      } else {
        await profileService.followUser(userId: widget.user.id);
      }
    } catch (e) {
      succeeded = false;
      failure = e;
    }

    if (!mounted) return;
    setState(() {
      _isFollowing = resolveFollowToggle(wasFollowing: wasFollowing, succeeded: succeeded);
      _isLoading = false;
    });
    if (failure != null) AppErrorHandler.showError(context, failure);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        context.push('/user/${widget.user.id}');
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.primaryContainer,
        child: widget.user.profileImage.image.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImageWidget(
                  imageUrl: widget.user.profileImage.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                widget.user.initials,
                style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer),
              ),
      ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              widget.user.username,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 6),
          _TrustBadge(userId: widget.user.id),
        ],
      ),
      trailing: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Builder(
              builder: (context) {
                final l = AppLocalizations.of(context);
                return SizedBox(
                  width: 100,
                  child: _isFollowing
                      ? OutlinedButton(
                          onPressed: _toggleFollow,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                            side: BorderSide(color: colorScheme.outline),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l?.profile_following_btn ?? 'Following',
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      : FilledButton(
                          onPressed: _toggleFollow,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            minimumSize: const Size(0, 32),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            l?.profile_follow ?? 'Follow',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                );
              },
            ),
    );
  }
}

/// Per-row manner-temperature badge, fed by [userTrustScoreProvider].
/// Renders nothing while loading or on error so a slow/failed trust-score
/// fetch never blocks or breaks the row (mirrors `_TrustChip` in
/// `profile_header.dart`).
///
// NOTE(plan-g): this fires one trust-score request per visible row (the
// `userTrustScoreProvider` family caches per userId, so re-scrolling the
// same list is free, but the first render of an N-row list still makes N
// requests). A batched `temperature` field on the backend follow-list
// serializer would remove these per-row calls entirely; that optimization
// is out of scope for E6 (Flutter-only).
class _TrustBadge extends ConsumerWidget {
  const _TrustBadge({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trustAsync = ref.watch(userTrustScoreProvider(userId));
    return trustAsync.when(
      data: (trustScore) => TrustBadgeCompact(temperature: trustScore.temperature, size: 0.85),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
