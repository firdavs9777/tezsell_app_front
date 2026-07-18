import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/pages/community/community_main.dart' show communityCategories;
import 'package:app/pages/community/community_labels.dart';

class CommunityComposer extends ConsumerStatefulWidget {
  const CommunityComposer({super.key, this.districtId});
  final int? districtId;

  @override
  ConsumerState<CommunityComposer> createState() => _CommunityComposerState();
}

class _CommunityComposerState extends ConsumerState<CommunityComposer> {
  String _category = 'general';
  final _body = TextEditingController();
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
      await ref.read(communityProvider).createPost(
            category: _category,
            body: body,
            districtId: widget.districtId,
          );
      if (!mounted) return;
      ref.invalidate(communityFeedProvider);
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
    // Reuse the same category labels as the feed, minus "all".
    final categories = communityCategories.where((c) => c != 'all').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.communityNewPost ?? 'New post'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: Text(l?.communityPublish ?? 'Post'),
          ),
        ],
      ),
      body: Padding(
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
              onChanged: (v) => setState(() => _category = v ?? 'general'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _body,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: l?.communityBodyHint ?? 'Share something with your neighborhood…',
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
