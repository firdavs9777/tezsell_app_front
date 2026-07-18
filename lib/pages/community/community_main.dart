import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/community/community_labels.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final args = (districtId: widget.districtId, category: _category);
    final feed = ref.watch(communityFeedProvider(args));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/community/new?districtId=${widget.districtId ?? ''}'),
        icon: const Icon(Icons.edit),
        label: Text(l?.communityWrite ?? 'Write'),
      ),
      body: Column(
        children: [
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
                return ChoiceChip(
                  label: Text(communityCategoryLabel(l, key)),
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
                      onRefresh: () async => ref.invalidate(communityFeedProvider(args)),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: posts.length,
                        itemBuilder: (context, i) => _PostCard(
                          post: posts[i],
                          categoryLabel: communityCategoryLabel(l, posts[i].category),
                          onTap: () => context.push('/community/${posts[i].id}'),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, required this.categoryLabel, required this.onTap});
  final CommunityPost post;
  final String categoryLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
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
                  Text(post.authorName, style: theme.textTheme.labelMedium),
                  const Spacer(),
                  Chip(
                    label: Text(categoryLabel),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
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
              const SizedBox(height: 8),
              Row(children: [
                Icon(post.isLiked ? Icons.favorite : Icons.favorite_border, size: 15, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text('${post.likeCount}', style: theme.textTheme.bodySmall),
                const SizedBox(width: 14),
                Icon(Icons.chat_bubble_outline, size: 15, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text('${post.commentCount}', style: theme.textTheme.bodySmall),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
