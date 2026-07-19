import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/community/community_labels.dart';
import 'package:app/pages/community/widgets/poll_card.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/widgets/report_content_dialog.dart';

class CommunityDetail extends ConsumerStatefulWidget {
  const CommunityDetail({super.key, required this.postId});
  final int postId;

  @override
  ConsumerState<CommunityDetail> createState() => _CommunityDetailState();
}

class _CommunityDetailState extends ConsumerState<CommunityDetail> {
  final _controller = TextEditingController();
  final _inputFocusNode = FocusNode();

  CommunityPost? _post;
  bool _postError = false;

  List<CommunityComment>? _comments;
  bool _commentsError = false;
  bool _loadingMoreComments = false;
  int _commentPage = 1;
  bool _hasMoreComments = false;

  bool _sending = false;
  bool _liking = false;
  final Set<int> _likingComments = {};
  final Set<int> _expandedReplies = {};
  CommunityComment? _replyingTo;

  @override
  void initState() {
    super.initState();
    _loadPost();
    _loadComments();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadPost() async {
    setState(() => _postError = false);
    try {
      final post = await ref.read(communityProvider).getPost(widget.postId);
      if (!mounted) return;
      setState(() => _post = post);
    } catch (_) {
      if (mounted) setState(() => _postError = true);
    }
  }

  /// Silently re-syncs the post (used after add/delete comment so the
  /// comment count stays authoritative without a visible loading state).
  Future<void> _refreshPostSilently() async {
    try {
      final post = await ref.read(communityProvider).getPost(widget.postId);
      if (mounted) setState(() => _post = post);
    } catch (_) {
      // Keep the locally-adjusted view; a manual pull/refresh will reconcile.
    }
  }

  Future<void> _loadComments() async {
    setState(() => _commentsError = false);
    try {
      final page = await ref.read(communityProvider).getComments(widget.postId, page: 1);
      if (!mounted) return;
      setState(() {
        _comments = page.comments;
        _commentPage = 1;
        _hasMoreComments = page.hasMore;
      });
    } catch (_) {
      if (mounted) setState(() => _commentsError = true);
    }
  }

  Future<void> _loadMoreComments() async {
    if (_loadingMoreComments || !_hasMoreComments) return;
    setState(() => _loadingMoreComments = true);
    try {
      final nextPage = _commentPage + 1;
      final page = await ref.read(communityProvider).getComments(widget.postId, page: nextPage);
      if (!mounted) return;
      setState(() {
        _comments = [...?_comments, ...page.comments];
        _commentPage = nextPage;
        _hasMoreComments = page.hasMore;
      });
    } catch (_) {
      // Leave _hasMoreComments as-is so the button remains available to retry.
    } finally {
      if (mounted) setState(() => _loadingMoreComments = false);
    }
  }

  Future<void> _toggleLike() async {
    final current = _post;
    if (current == null || _liking) return;
    setState(() => _liking = true);
    final optimistic = current.copyWith(
      isLiked: !current.isLiked,
      likeCount: current.isLiked ? current.likeCount - 1 : current.likeCount + 1,
    );
    setState(() => _post = optimistic);
    try {
      final result = await ref.read(communityProvider).toggleLike(widget.postId);
      if (!mounted) return;
      setState(() => _post = optimistic.copyWith(
            isLiked: result['liked'] as bool? ?? optimistic.isLiked,
            likeCount: result['like_count'] as int? ?? optimistic.likeCount,
          ));
    } catch (_) {
      if (mounted) setState(() => _post = current);
    } finally {
      if (mounted) setState(() => _liking = false);
    }
  }

  void _startReply(CommunityComment topLevelComment) {
    setState(() => _replyingTo = topLevelComment);
    _inputFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() => _replyingTo = null);
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    final parent = _replyingTo;
    setState(() => _sending = true);
    try {
      final created = await ref
          .read(communityProvider)
          .addComment(widget.postId, text, parentId: parent?.id);
      if (!mounted) return;
      setState(() {
        if (parent == null) {
          _comments = [...?_comments, created];
        } else {
          _comments = (_comments ?? const []).map((c) {
            if (c.id != parent.id) return c;
            return c.copyWith(
              replies: [...c.replies, created],
              replyCount: c.replyCount + 1,
            );
          }).toList();
          _expandedReplies.add(parent.id);
        }
        _replyingTo = null;
      });
      _controller.clear();
      _refreshPostSilently();
    } catch (_) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l?.communityPostFailed ?? 'Failed to post')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  /// Applies [update] to the comment (or nested reply) matching [commentId]
  /// across the loaded top-level comment list.
  void _updateComment(int commentId, CommunityComment Function(CommunityComment) update) {
    if (_comments == null) return;
    setState(() {
      _comments = _comments!.map((c) {
        if (c.id == commentId) return update(c);
        if (c.replies.any((r) => r.id == commentId)) {
          return c.copyWith(
            replies: c.replies.map((r) => r.id == commentId ? update(r) : r).toList(),
          );
        }
        return c;
      }).toList();
    });
  }

  Future<void> _toggleCommentLike(CommunityComment comment) async {
    if (_likingComments.contains(comment.id)) return;
    _likingComments.add(comment.id);
    final prevLiked = comment.isLiked;
    final prevCount = comment.likeCount;
    _updateComment(
      comment.id,
      (c) => c.copyWith(
        isLiked: !c.isLiked,
        likeCount: c.isLiked ? c.likeCount - 1 : c.likeCount + 1,
      ),
    );
    try {
      final result =
          await ref.read(communityProvider).toggleCommentLike(widget.postId, comment.id);
      if (!mounted) return;
      _updateComment(
        comment.id,
        (c) => c.copyWith(
          isLiked: result['liked'] as bool? ?? c.isLiked,
          likeCount: result['like_count'] as int? ?? c.likeCount,
        ),
      );
    } catch (_) {
      if (mounted) {
        _updateComment(comment.id, (c) => c.copyWith(isLiked: prevLiked, likeCount: prevCount));
      }
    } finally {
      // Must rebuild: the last frame baked in onTap: null while this id was
      // in-flight — without setState the like button stays dead until an
      // unrelated rebuild.
      if (mounted) {
        setState(() => _likingComments.remove(comment.id));
      } else {
        _likingComments.remove(comment.id);
      }
    }
  }

  Future<void> _deleteComment(CommunityComment comment, {CommunityComment? parent}) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(l?.communityDeleteCommentConfirm ?? 'Delete this comment?'),
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
      await ref.read(communityProvider).deleteComment(widget.postId, comment.id);
      if (!mounted) return;
      setState(() {
        if (parent == null) {
          _comments = (_comments ?? const []).where((c) => c.id != comment.id).toList();
        } else {
          _comments = (_comments ?? const []).map((c) {
            if (c.id != parent.id) return c;
            return c.copyWith(
              replies: c.replies.where((r) => r.id != comment.id).toList(),
              replyCount: c.replyCount > 0 ? c.replyCount - 1 : 0,
            );
          }).toList();
        }
        // Compare by id — copyWith replaces instances on like toggles, so
        // identity would miss and leave a dangling reply banner.
        if (comment.id == _replyingTo?.id) _replyingTo = null;
      });
      _refreshPostSilently();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l?.errorGeneric ?? 'Something went wrong')),
        );
      }
    }
  }

  void _invalidateFeedAndCounts() {
    ref.invalidate(communityFeedProvider);
    ref.invalidate(communityCountsProvider);
  }

  Future<void> _editPost(CommunityPost post) async {
    final updated = await context.push<bool>('/community/${post.id}/edit', extra: post);
    if (updated == true && mounted) {
      _invalidateFeedAndCounts();
      _loadPost();
    }
  }

  Future<void> _deletePost(CommunityPost post) async {
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
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        final l = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l?.errorGeneric ?? 'Something went wrong')),
        );
      }
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
    final theme = Theme.of(context);
    final currentUserId = ref.watch(communityCurrentUserIdProvider).valueOrNull;
    final post = _post;
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.communityPostTitle ?? 'Post'),
        actions: [
          if (post != null)
            Builder(builder: (context) {
              final isOwn = currentUserId != null && post.authorId == currentUserId;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () => _sharePost(post),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _editPost(post);
                          break;
                        case 'delete':
                          _deletePost(post);
                          break;
                        case 'report':
                          _reportPost(post);
                          break;
                      }
                    },
                    itemBuilder: (context) => isOwn
                        ? [
                            PopupMenuItem(value: 'edit', child: Text(l?.chatEdit ?? 'Edit')),
                            PopupMenuItem(value: 'delete', child: Text(l?.chatDelete ?? 'Delete')),
                          ]
                        : [
                            PopupMenuItem(value: 'report', child: Text(l?.profile_report ?? 'Report')),
                          ],
                  ),
                ],
              );
            }),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _buildPostSection(context, l, theme, post, currentUserId),
                _buildCommentsSection(context, l, theme, post, currentUserId),
              ],
            ),
          ),
          _buildInputBar(context, l),
        ],
      ),
    );
  }

  Widget _buildPostSection(
    BuildContext context,
    AppLocalizations? l,
    ThemeData theme,
    CommunityPost? post,
    int? currentUserId,
  ) {
    if (_postError) {
      return Center(child: Text(l?.errorGeneric ?? 'Something went wrong'));
    }
    if (post == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(
                post.authorName.isNotEmpty ? post.authorName[0].toUpperCase() : '?',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(post.authorName, style: theme.textTheme.labelLarge),
            ),
            if (post.isEdited) ...[
              Text(
                '(${l?.chatEdited ?? "edited"})',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(width: 8),
            ],
            Chip(
              label: Text(communityCategoryLabel(l, post.category)),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(post.body, style: theme.textTheme.bodyLarge),
        if (post.imageUrls.isNotEmpty) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              post.imageUrls.first,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        if (post.poll != null)
          PollCard(
            postId: post.id,
            poll: post.poll!,
            onVoted: (updated) => setState(() => _post = post.copyWith(poll: updated)),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: _liking ? null : _toggleLike,
              icon: Icon(
                post.isLiked ? Icons.favorite : Icons.favorite_border,
                color: theme.colorScheme.primary,
              ),
            ),
            Text('${post.likeCount}', style: theme.textTheme.bodyMedium),
            const SizedBox(width: 16),
            Icon(Icons.visibility_outlined, size: 18, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text('${post.viewCount}', style: theme.textTheme.bodyMedium),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  Widget _buildCommentsSection(
    BuildContext context,
    AppLocalizations? l,
    ThemeData theme,
    CommunityPost? post,
    int? currentUserId,
  ) {
    if (_commentsError) {
      return Center(child: Text(l?.errorGeneric ?? 'Something went wrong'));
    }
    final comments = _comments;
    if (comments == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (comments.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text(l?.communityNoComments ?? 'No comments yet')),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final comment in comments)
          _buildCommentTile(context, l, theme, post, currentUserId, comment),
        if (_hasMoreComments)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: _loadingMoreComments
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : TextButton(
                      onPressed: _loadMoreComments,
                      child: Text(l?.communityLoadMoreComments ?? 'Load more comments'),
                    ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentTile(
    BuildContext context,
    AppLocalizations? l,
    ThemeData theme,
    CommunityPost? post,
    int? currentUserId,
    CommunityComment comment,
  ) {
    final expanded = _expandedReplies.contains(comment.id);
    final visibleReplies = expanded ? comment.replies : comment.replies.take(2).toList();
    final remainingCount = comment.replies.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCommentRow(context, l, theme, post, currentUserId, comment, isReply: false),
          for (final reply in visibleReplies)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: _buildCommentRow(context, l, theme, post, currentUserId, reply,
                  isReply: true, parent: comment),
            ),
          if (!expanded && remainingCount > 2)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: TextButton(
                onPressed: () => setState(() => _expandedReplies.add(comment.id)),
                child: Text(
                  l?.communityViewReplies(remainingCount) ?? 'View $remainingCount replies',
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCommentRow(
    BuildContext context,
    AppLocalizations? l,
    ThemeData theme,
    CommunityPost? post,
    int? currentUserId,
    CommunityComment comment, {
    required bool isReply,
    CommunityComment? parent,
  }) {
    final isPostAuthorComment = post != null && comment.userId == post.authorId;
    final canDelete = currentUserId != null &&
        (comment.userId == currentUserId || (post != null && post.authorId == currentUserId));
    final liking = _likingComments.contains(comment.id);
    return GestureDetector(
      onLongPress: canDelete ? () => _deleteComment(comment, parent: parent) : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: isReply ? 12 : 16,
              child: Text(
                comment.userName.isNotEmpty ? comment.userName[0].toUpperCase() : '?',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.userName,
                          style: theme.textTheme.labelLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isPostAuthorComment) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            l?.communityAuthorBadge ?? 'Author',
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(comment.text, style: theme.textTheme.bodyMedium),
                  Row(
                    children: [
                      InkWell(
                        onTap: liking ? null : () => _toggleCommentLike(comment),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                          child: Row(
                            children: [
                              Icon(
                                comment.isLiked ? Icons.favorite : Icons.favorite_border,
                                size: 16,
                                color: theme.colorScheme.primary,
                              ),
                              if (comment.likeCount > 0) ...[
                                const SizedBox(width: 4),
                                Text('${comment.likeCount}', style: theme.textTheme.bodySmall),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (!isReply) ...[
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () => _startReply(comment),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                            child: Text(l?.chatReply ?? 'Reply', style: theme.textTheme.bodySmall),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, AppLocalizations? l) {
    final replyingTo = _replyingTo;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (replyingTo != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l?.replying_to(replyingTo.userName) ??
                            'Replying to ${replyingTo.userName}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _cancelReply,
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _inputFocusNode,
                    decoration: InputDecoration(
                      hintText: l?.communityAddComment ?? 'Add a comment…',
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sending ? null : _send,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
