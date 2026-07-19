import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/community_post_model.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/pages/community/community_main.dart' show communityCategories;
import 'package:app/pages/community/community_labels.dart';

/// Author-only edit screen for an existing community post — mirrors
/// [CommunityComposer] (category + body) but PATCHes the existing post
/// instead of creating a new one. Poll/images are not editable here (C9
/// scope); only body + category, per the C7 contract.
class CommunityEditPage extends ConsumerStatefulWidget {
  const CommunityEditPage({super.key, required this.post});
  final CommunityPost post;

  @override
  ConsumerState<CommunityEditPage> createState() => _CommunityEditPageState();
}

class _CommunityEditPageState extends ConsumerState<CommunityEditPage> {
  late String _category = widget.post.category;
  late final _body = TextEditingController(text: widget.post.body);
  bool _submitting = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final body = _body.text.trim();
    if (body.isEmpty || _submitting) return;

    setState(() => _submitting = true);
    try {
      await ref.read(communityProvider).updatePost(
            widget.post.id,
            body: body,
            category: _category,
          );
      if (!mounted) return;
      ref.invalidate(communityFeedProvider);
      ref.invalidate(communityCountsProvider);
      Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.communityPostFailed ?? 'Failed to post')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final categories = communityCategories.where((c) => c != 'all').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.chatEdit ?? 'Edit'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: Text(l?.communityPublish ?? 'Post'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _category,
                isExpanded: true,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(communityCategoryLabel(l, c))))
                    .toList(),
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _body,
                minLines: 6,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: l?.communityBodyHint ?? 'Share something with your neighborhood…',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
