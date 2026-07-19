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
import 'package:app/widgets/report_content_dialog.dart';

const communityCategories = <String>[
  'all', 'question', 'recommend', 'free', 'lostfound', 'alert', 'general',
];

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

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    final trimmed = value.trim();
    final gen = ++_searchGeneration;
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted || gen != _searchGeneration) return;
      setState(() => _query = trimmed.length >= 2 ? trimmed : null);
    });
  }

  void _closeSearch() {
    _searchDebounce?.cancel();
    _searchGeneration++;
    _searchController.clear();
    setState(() {
      _searchActive = false;
      _query = null;
    });
  }

  void _invalidateFeedAndCounts() {
    ref.invalidate(communityFeedProvider);
    ref.invalidate(communityCountsProvider);
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
        onPressed: () => context.push('/community/new?districtId=${widget.districtId ?? ''}'),
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
                    onSelectionChanged: (selection) => setState(() => _sort = selection.first),
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
                  onSelected: (_) => setState(() => _category = key),
                );
              },
            ),
          ),
          Expanded(
            child: feed.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l?.errorGeneric ?? 'Something went wrong')),
              data: (posts) => posts.isEmpty
                  ? Center(child: Text(l?.communityEmpty ?? 'No posts yet. Be the first!'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(communityFeedProvider(args));
                        ref.invalidate(communityCountsProvider(widget.districtId));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: posts.length,
                        itemBuilder: (context, i) {
                          final post = posts[i];
                          final isOwn = currentUserId != null && post.authorId == currentUserId;
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
                      ),
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(post.imageUrls.first, height: 140, width: double.infinity, fit: BoxFit.cover),
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
