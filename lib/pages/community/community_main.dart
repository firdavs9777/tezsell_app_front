import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/community/community_labels.dart';
import 'package:app/pages/community/widgets/poll_card.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/widgets/skeleton_loader.dart';

/// Mirrors the backend's `CommunityFeedPagination.page_size` — used purely
/// as a heuristic to detect the last page (a response shorter than this
/// means there's nothing more to fetch), matching the pattern used for
/// products/services pagination elsewhere in the app.
const _kCommunityPageSize = 10;

const communityCategories = <String>[
  'all', 'question', 'recommend', 'free', 'lostfound', 'alert', 'general',
];

/// Merges the first feed page (from `communityFeedProvider`) with
/// locally-accumulated later pages fetched via infinite scroll,
/// de-duplicating by post id. Without this, a post created/edited between
/// the first-page fetch and an already-accumulated later page could appear
/// twice — which would also violate the `ValueKey`-per-card contract in the
/// feed's `ListView.builder`.
List<CommunityPost> mergeCommunityFeedPages(
  List<CommunityPost> firstPage,
  List<CommunityPost> laterPages,
) {
  final firstPageIds = firstPage.map((p) => p.id).toSet();
  return [
    ...firstPage,
    ...laterPages.where((p) => !firstPageIds.contains(p.id)),
  ];
}

class CommunityMain extends ConsumerStatefulWidget {
  const CommunityMain({super.key, required this.districtId});
  final int? districtId;

  @override
  ConsumerState<CommunityMain> createState() => _CommunityMainState();
}

class _CommunityMainState extends ConsumerState<CommunityMain> {
  String _category = 'all';
  String _sort = 'fresh';

  bool _searchActive = false;
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  int _searchGeneration = 0;
  String? _query;

  // --- Infinite-scroll pagination (pages beyond the first) ---
  //
  // Page 1 always comes from `communityFeedProvider` (a FutureProvider so
  // pull-to-refresh/invalidation keep working exactly as before); pages 2+
  // are fetched directly through `communityProvider.getFeed` and accumulated
  // here, since a plain FutureProvider has no notion of "append". Whenever
  // the filter/sort/query args change — or the feed is invalidated by a
  // create/edit/delete — this local state is reset alongside so stale pages
  // from the old filter combination never leak into the new one.
  final _scrollController = ScrollController();
  List<CommunityPost> _extraPosts = [];
  int _page = 1;
  bool _hasMore = true;
  bool _loadingMore = false;
  bool _loadMoreFailed = false;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _resetPaginationFields() {
    _generation++;
    _extraPosts = [];
    _page = 1;
    _hasMore = true;
    _loadingMore = false;
    _loadMoreFailed = false;
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 300) {
      return;
    }
    final args = (
      districtId: widget.districtId,
      category: _category,
      query: _query,
      sort: _sort,
    );
    final firstPage = ref.read(communityFeedProvider(args)).valueOrNull;
    if (firstPage == null) return;
    _loadMore(firstPageLength: firstPage.length);
  }

  Future<void> _loadMore({required int firstPageLength}) async {
    if (_loadingMore) return;
    // Page 1 alone was shorter than a full page — nothing more exists.
    if (_page == 1 && firstPageLength < _kCommunityPageSize) return;
    if (_page > 1 && !_hasMore) return;

    final gen = _generation;
    setState(() {
      _loadingMore = true;
      _loadMoreFailed = false;
    });
    try {
      final nextPage = _page + 1;
      final more = await ref.read(communityProvider).getFeed(
            districtId: widget.districtId,
            category: _category,
            query: _query,
            sort: _sort,
            page: nextPage,
          );
      // Staleness guard: if the filters changed (and pagination was reset)
      // while this request was in flight, its results belong to a feed that
      // no longer applies — drop them rather than appending onto the wrong
      // list.
      if (!mounted || gen != _generation) return;
      setState(() {
        _extraPosts = [..._extraPosts, ...more];
        _page = nextPage;
        _hasMore = more.length >= _kCommunityPageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted || gen != _generation) return;
      setState(() {
        _loadingMore = false;
        _loadMoreFailed = true;
      });
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final trimmed = value.trim();
    final gen = ++_searchGeneration;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || gen != _searchGeneration) return;
      setState(() {
        _query = trimmed.length >= 2 ? trimmed : null;
        _resetPaginationFields();
      });
    });
  }

  void _closeSearch() {
    _searchDebounce?.cancel();
    _searchGeneration++;
    _searchController.clear();
    setState(() {
      _searchActive = false;
      _query = null;
      _resetPaginationFields();
    });
  }

  void _invalidateFeedAndCounts() {
    ref.invalidate(communityFeedProvider);
    ref.invalidate(communityCountsProvider);
    if (mounted) setState(_resetPaginationFields);
  }

  Future<void> _confirmDelete(CommunityPost post) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l?.communityDeleteConfirm ?? 'Delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l?.chatDelete ?? 'Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ref.read(communityProvider).deletePost(post.id);
      if (!mounted) return;
      _invalidateFeedAndCounts();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l?.errorGeneric ?? 'Something went wrong')),
        );
      }
    }
  }

  Future<void> _editPost(CommunityPost post) async {
    final updated = await context.push<bool>('/community/${post.id}/edit', extra: post);
    if (updated == true && mounted) {
      _invalidateFeedAndCounts();
    }
  }

  Future<void> _reportPost(CommunityPost post) async {
    final l = AppLocalizations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ReportContentDialog(
        contentType: 'community_post',
        contentId: post.id,
      ),
    );
    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l?.reportSubmitted ?? 'Report submitted successfully')),
      );
    }
  }

  void _sharePost(CommunityPost post) {
    final l = AppLocalizations.of(context);
    final snippet = post.body.length > 100 ? '${post.body.substring(0, 100)}…' : post.body;
    final shareText =
        '$snippet\n${l?.onTezsell ?? "on TezSell"}: https://webtezsell.com/community/${post.id}';
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final args = (
      districtId: widget.districtId,
      category: _category,
      query: _query,
      sort: _sort,
    );
    final feed = ref.watch(communityFeedProvider(args));
    final counts = ref.watch(communityCountsProvider(widget.districtId)).valueOrNull;
    final currentUserId = ref.watch(communityCurrentUserIdProvider).valueOrNull;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await context
              .push<bool>('/community/new?districtId=${widget.districtId ?? ''}');
          if (created == true && mounted) {
            _invalidateFeedAndCounts();
          }
        },
        icon: const Icon(Icons.edit),
        label: Text(l?.communityWrite ?? 'Write'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: _searchActive
                      ? TextField(
                          controller: _searchController,
                          autofocus: true,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: l?.communitySearchHint ?? 'Search posts…',
                            prefixIcon: const Icon(Icons.search, size: 20),
                            border: const OutlineInputBorder(),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (_searchActive)
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _closeSearch,
                  )
                else ...[
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => setState(() => _searchActive = true),
                  ),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'fresh', label: Text(l?.sortFresh ?? 'Newest')),
                      ButtonSegment(value: 'popular', label: Text(l?.sortPopular ?? 'Popular')),
                    ],
                    selected: {_sort},
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onSelectionChanged: (selection) => setState(() {
                      _sort = selection.first;
                      _resetPaginationFields();
                    }),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: communityCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final key = communityCategories[i];
                final selected = key == _category;
                final count = key == 'all' ? null : counts?[key];
                final label = (count != null && count > 0)
                    ? '${communityCategoryLabel(l, key)} · $count'
                    : communityCategoryLabel(l, key);
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() {
                    _category = key;
                    _resetPaginationFields();
                  }),
                );
              },
            ),
          ),
          Expanded(
            child: feed.when(
              loading: () => const CommunityFeedSkeleton(),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l?.errorGeneric ?? 'Something went wrong'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => ref.invalidate(communityFeedProvider(args)),
                      child: Text(l?.retry ?? 'Retry'),
                    ),
                  ],
                ),
              ),
              data: (posts) => posts.isEmpty
                  ? Center(child: Text(l?.communityEmpty ?? 'No posts yet. Be the first!'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        setState(_resetPaginationFields);
                        await Future.wait([
                          ref.refresh(communityFeedProvider(args).future),
                          ref.refresh(communityCountsProvider(widget.districtId).future),
                        ]);
                      },
                      child: Builder(builder: (context) {
                        final combined = mergeCommunityFeedPages(posts, _extraPosts);
                        final showFooter = _loadingMore || _loadMoreFailed;
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: combined.length + (showFooter ? 1 : 0),
                          itemBuilder: (context, i) {
                            if (i >= combined.length) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: _loadMoreFailed
                                      ? TextButton(
                                          onPressed: () =>
                                              _loadMore(firstPageLength: posts.length),
                                          child: Text(
                                            l?.communityLoadMoreFailed ??
                                                "Couldn't load more. Tap to retry.",
                                          ),
                                        )
                                      : const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        ),
                                ),
                              );
                            }
                            final post = combined[i];
                            final isOwn =
                                currentUserId != null && post.authorId == currentUserId;
                            return _PostCard(
                              // Stateful card (holds in-flight poll vote state):
                              // key by post id so list reorders can't attach
                              // one post's vote UI to another slot.
                              key: ValueKey(post.id),
                              post: post,
                              categoryLabel: communityCategoryLabel(l, post.category),
                              isOwn: isOwn,
                              onTap: () => context.push('/community/${post.id}'),
                              onEdit: () => _editPost(post),
                              onDelete: () => _confirmDelete(post),
                              onReport: () => _reportPost(post),
                              onShare: () => _sharePost(post),
                            );
                          },
                        );
                      }),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatefulWidget {
  const _PostCard({
    super.key,
    required this.post,
    required this.categoryLabel,
    required this.isOwn,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onReport,
    required this.onShare,
  });
  final CommunityPost post;
  final String categoryLabel;
  final bool isOwn;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;
  final VoidCallback onShare;

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  // The feed list comes from a FutureProvider that isn't refetched on every
  // poll vote, so this card holds its own mutable copy of the post — voting
  // updates it locally (via the server's returned poll payload) rather than
  // invalidating and re-fetching the whole feed.
  late CommunityPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  @override
  void didUpdateWidget(covariant _PostCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.post, widget.post)) {
      _post = widget.post;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final post = _post;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 12, child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 11),
                  )),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post.authorName,
                      style: theme.textTheme.labelMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.isEdited) ...[
                    const SizedBox(width: 6),
                    Text(
                      '(${l?.chatEdited ?? "edited"})',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(widget.categoryLabel),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 18),
                    padding: EdgeInsets.zero,
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          widget.onEdit();
                          break;
                        case 'delete':
                          widget.onDelete();
                          break;
                        case 'report':
                          widget.onReport();
                          break;
                        case 'share':
                          widget.onShare();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      if (widget.isOwn) ...[
                        PopupMenuItem(value: 'edit', child: Text(l?.chatEdit ?? 'Edit')),
                        PopupMenuItem(value: 'delete', child: Text(l?.chatDelete ?? 'Delete')),
                      ] else
                        PopupMenuItem(value: 'report', child: Text(l?.profile_report ?? 'Report')),
                      PopupMenuItem(value: 'share', child: Text(l?.profile_share ?? 'Share')),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(post.body, maxLines: 3, overflow: TextOverflow.ellipsis),
              if (post.imageUrls.isNotEmpty) ...[
                const SizedBox(height: 8),
                CachedNetworkImageWidget(
                  imageUrl: post.imageUrls.first,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
              if (post.poll != null)
                PollCard(
                  postId: post.id,
                  poll: post.poll!,
                  compact: true,
                  onVoted: (updated) => setState(() => _post = _post.copyWith(poll: updated)),
                ),
              const SizedBox(height: 8),
              Row(children: [
                Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, size: 15, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text('${post.likeCount}', style: theme.textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(Icons.chat_bubble_outline, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.commentCount}', style: theme.textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(Icons.visibility_outlined, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.viewCount}', style: theme.textTheme.bodySmall),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
