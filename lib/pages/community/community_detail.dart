import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/community_comment_model.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

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

  String _categoryLabel(AppLocalizations? l, String key) {
    switch (key) {
      case 'all':
        return l?.communityAll ?? 'All';
      case 'question':
        return l?.communityQuestion ?? 'Question';
      case 'recommend':
        return l?.communityRecommend ?? 'Tips';
      case 'free':
        return l?.communityFree ?? 'Free';
      case 'lostfound':
        return l?.communityLostFound ?? 'Lost & Found';
      case 'alert':
        return l?.communityAlert ?? 'Alert';
      default:
        return l?.communityGeneral ?? 'General';
    }
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
      _controller.clear();
      setState(
          () => _comments = ref.read(communityProvider).getComments(widget.postId));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l?.communityPostTitle ?? 'Post')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                FutureBuilder<CommunityPost>(
                  future: _post,
                  builder: (context, snap) {
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
                            Text(post.authorName, style: theme.textTheme.labelLarge),
                            const Spacer(),
                            Chip(
                              label: Text(_categoryLabel(l, post.category)),
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
