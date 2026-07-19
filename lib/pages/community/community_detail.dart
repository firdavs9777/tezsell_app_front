import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/community/community_labels.dart';
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
  late Future<CommunityPost> _post;
  late Future<List<CommunityComment>> _comments;
  bool _sending = false;
  bool _liking = false;

  @override
  void initState() {
    super.initState();
    _post = ref.read(communityProvider).getPost(widget.postId);
    _comments = ref.read(communityProvider).getComments(widget.postId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleLike(CommunityPost current) async {
    if (_liking) return;
    setState(() => _liking = true);
    final optimistic = current.copyWith(
      isLiked: !current.isLiked,
      likeCount: current.isLiked ? current.likeCount - 1 : current.likeCount + 1,
    );
    setState(() => _post = Future.value(optimistic));
    try {
      final result = await ref.read(communityProvider).toggleLike(widget.postId);
      final reconciled = optimistic.copyWith(
        isLiked: result['liked'] as bool? ?? optimistic.isLiked,
        likeCount: result['like_count'] as int? ?? optimistic.likeCount,
      );
      if (mounted) setState(() => _post = Future.value(reconciled));
    } catch (_) {
      if (mounted) setState(() => _post = Future.value(current));
    } finally {
      if (mounted) setState(() => _liking = false);
    }
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      await ref.read(communityProvider).addComment(widget.postId, text);
      if (!mounted) return;
      _controller.clear();
      setState(
          () => _comments = ref.read(communityProvider).getComments(widget.postId));
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

  void _invalidateFeedAndCounts() {
    ref.invalidate(communityFeedProvider);
    ref.invalidate(communityCountsProvider);
  }

  Future<void> _editPost(CommunityPost post) async {
    final updated = await context.push<bool>('/community/${post.id}/edit', extra: post);
    if (updated == true && mounted) {
      _invalidateFeedAndCounts();
      setState(() => _post = ref.read(communityProvider).getPost(widget.postId));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.communityPostTitle ?? 'Post'),
        actions: [
          FutureBuilder<CommunityPost>(
            future: _post,
            builder: (context, snap) {
              if (!snap.hasData) return const SizedBox.shrink();
              final post = snap.data!;
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
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                FutureBuilder<CommunityPost>(
                  future: _post,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Center(
                        child: Text(l?.errorGeneric ?? 'Something went wrong'),
                      );
                    }
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final post = snap.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              child: Text(
                                post.authorName.isNotEmpty
                                    ? post.authorName[0].toUpperCase()
                                    : '?',
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _liking ? null : () => _toggleLike(post),
                              icon: Icon(
                                post.isLiked ? Icons.favorite : Icons.favorite_border,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text('${post.likeCount}', style: theme.textTheme.bodyMedium),
                            const SizedBox(width: 16),
                            Icon(Icons.visibility_outlined,
                                size: 18, color: theme.colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text('${post.viewCount}', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        const Divider(height: 24),
                      ],
                    );
                  },
                ),
                FutureBuilder<List<CommunityComment>>(
                  future: _comments,
                  builder: (context, snap) {
                    if (snap.hasError) {
                      return Center(
                        child: Text(l?.errorGeneric ?? 'Something went wrong'),
                      );
                    }
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final comments = snap.data!;
                    if (comments.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(l?.communityNoComments ?? 'No comments yet'),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, i) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          child: Text(
                            comments[i].userName.isNotEmpty
                                ? comments[i].userName[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(comments[i].userName),
                        subtitle: Text(comments[i].text),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
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
            ),
          ),
        ],
      ),
    );
  }
}
