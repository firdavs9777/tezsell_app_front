import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_root/community_provider.dart';
import 'package:app/pages/community/community_main.dart' show communityCategories;
import 'package:app/pages/community/community_labels.dart';

const _kMaxImages = 5;
const _kMinPollOptions = 2;
const _kMaxPollOptions = 5;

/// Mirrors the backend's `MAX_IMAGE_SIZE` (community/views.py via
/// myproject/settings/base.py) so oversized photos are caught client-side
/// instead of round-tripping to the server for a 400.
const _kMaxImageBytes = 5 * 1024 * 1024;

/// Mirrors the backend's `ALLOWED_IMAGE_EXTENSIONS` for the same reason.
const _kAllowedImageExtensions = {'.jpg', '.jpeg', '.png', '.gif', '.webp'};

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

  final _picker = ImagePicker();
  final List<File> _images = [];

  bool _pollEnabled = false;
  final _pollQuestion = TextEditingController();
  final List<TextEditingController> _pollOptions = [
    TextEditingController(),
    TextEditingController(),
  ];
  String? _pollError;

  @override
  void dispose() {
    _body.dispose();
    _pollQuestion.dispose();
    for (final c in _pollOptions) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImages() async {
    final l = AppLocalizations.of(context);
    final picked = await _picker.pickMultiImage(
      maxWidth: 2560,
      maxHeight: 2560,
      imageQuality: 95,
    );
    if (picked.isEmpty || !mounted) return;

    // Client-side pre-check mirroring the backend's per-image validation
    // (extension + 5MB size cap) so obviously-invalid photos are dropped
    // before a round-trip, rather than surfacing as a post-submit 400.
    final valid = <File>[];
    var rejected = false;
    for (final p in picked) {
      final dot = p.path.lastIndexOf('.');
      final ext = dot == -1 ? '' : p.path.substring(dot).toLowerCase();
      if (!_kAllowedImageExtensions.contains(ext)) {
        rejected = true;
        continue;
      }
      final size = await p.length();
      if (size > _kMaxImageBytes) {
        rejected = true;
        continue;
      }
      valid.add(File(p.path));
    }
    if (!mounted) return;

    final combined = [..._images, ...valid];
    final trimmed = combined.length > _kMaxImages;
    setState(() {
      _images
        ..clear()
        ..addAll(combined.take(_kMaxImages));
    });
    if (!mounted) return;
    // Both can happen from a single pick (e.g. one oversized photo plus more
    // photos than the remaining slots) — show every applicable message
    // rather than only the first one checked.
    final messages = <String>[
      if (rejected)
        l?.communityImageRejected ??
            "Some photos weren't added (over 5MB or an unsupported type)",
      if (trimmed) l?.communityMaxImages ?? 'Up to 5 photos',
    ];
    if (messages.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(messages.join(' '))),
      );
    }
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
  }

  void _addPollOption() {
    if (_pollOptions.length >= _kMaxPollOptions) return;
    setState(() => _pollOptions.add(TextEditingController()));
  }

  void _removePollOption(int index) {
    if (_pollOptions.length <= _kMinPollOptions) return;
    setState(() {
      final removed = _pollOptions.removeAt(index);
      removed.dispose();
    });
  }

  /// Returns the validated (question, options) pair, or null (with
  /// [_pollError] set) if the poll fields don't satisfy the backend
  /// contract: a non-empty question and 2-5 non-empty options.
  (String, List<String>)? _validatePoll() {
    final question = _pollQuestion.text.trim();
    final options = _pollOptions.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    final valid = question.isNotEmpty &&
        options.length >= _kMinPollOptions &&
        options.length <= _kMaxPollOptions;
    if (!valid) {
      final l = AppLocalizations.of(context);
      setState(() => _pollError = l?.communityPollValidation ?? 'Add a question and 2-5 options');
      return null;
    }
    setState(() => _pollError = null);
    return (question, options);
  }

  Future<void> _submit() async {
    final body = _body.text.trim();
    if (body.isEmpty || _submitting) return;

    String? pollQuestion;
    List<String>? pollOptions;
    if (_pollEnabled) {
      final validated = _validatePoll();
      if (validated == null) return;
      pollQuestion = validated.$1;
      pollOptions = validated.$2;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(communityProvider).createPost(
            category: _category,
            body: body,
            districtId: widget.districtId,
            images: _images,
            pollQuestion: pollQuestion,
            pollOptions: pollOptions,
          );
      if (!mounted) return;
      invalidateCommunityFeed(ref);
      Navigator.of(context).pop(true);
    } on CommunityApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.friendlyMessage(
              fallback: AppLocalizations.of(context)?.communityPostFailed ?? 'Failed to post',
            )),
          ),
        );
      }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Reuse the same category labels as the feed, minus "all".
    final categories = communityCategories.where((c) => c != 'all').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(l?.communityNewPost ?? 'New post'),
        actions: [
          TextButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l?.communityPublish ?? 'Post'),
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
                onChanged: (v) => setState(() => _category = v ?? 'general'),
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
              const SizedBox(height: 16),
              _buildPhotoRow(context, theme, colorScheme, l),
              const SizedBox(height: 16),
              _buildPollSection(context, theme, colorScheme, l),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoRow(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? l,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_images.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              l?.communityPhotoCount(_images.length, _kMaxImages) ??
                  '${_images.length}/$_kMaxImages',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length + (_images.length < _kMaxImages ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == _images.length) {
                return GestureDetector(
                  onTap: _submitting ? null : _pickImages,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
                    ),
                    child: Icon(Icons.add, color: colorScheme.primary),
                  ),
                );
              }
              final file = _images[index];
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(file, width: 72, height: 72, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: GestureDetector(
                      onTap: _submitting ? null : () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(color: colorScheme.error, shape: BoxShape.circle),
                        child: Icon(Icons.close, size: 14, color: colorScheme.onError),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPollSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? l,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _pollEnabled = !_pollEnabled),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const Text('📊', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l?.communityAddPoll ?? 'Add poll',
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                Switch(
                  value: _pollEnabled,
                  onChanged: (v) => setState(() {
                    _pollEnabled = v;
                    if (!v) _pollError = null;
                  }),
                ),
              ],
            ),
          ),
        ),
        if (_pollEnabled) ...[
          const SizedBox(height: 8),
          TextField(
            controller: _pollQuestion,
            maxLength: 200,
            decoration: InputDecoration(
              labelText: l?.communityPollQuestion ?? 'Poll question',
              border: const OutlineInputBorder(),
            ),
          ),
          for (var i = 0; i < _pollOptions.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _pollOptions[i],
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: l?.communityPollOption(i + 1) ?? 'Option ${i + 1}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  if (_pollOptions.length > _kMinPollOptions)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () => _removePollOption(i),
                    ),
                ],
              ),
            ),
          if (_pollOptions.length < _kMaxPollOptions)
            TextButton.icon(
              onPressed: _addPollOption,
              icon: const Icon(Icons.add),
              label: Text(l?.communityAddOption ?? 'Add option'),
            ),
          if (_pollError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                _pollError!,
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ),
        ],
      ],
    );
  }
}
