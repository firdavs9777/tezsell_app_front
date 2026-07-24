import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/review_model.dart';
import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/reviews_provider.dart';
import 'package:app/widgets/review_tags.dart';
import 'package:app/widgets/star_rating.dart';

/// Screen for leaving a Karrot-style review (rating + quick tags + optional
/// text) for a completed transaction.
///
/// Callers should prefer passing the richer, already-known fields
/// ([isBuyerReview], [counterpartyName], [itemTitle], ...) via the
/// constructor/route `extra` to avoid an extra network round trip. If those
/// are omitted (e.g. deep link with only a transaction id), the screen
/// degrades gracefully by fetching the transaction list and resolving them.
///
/// [isBuyerReview] only selects which quick-tag set is shown client-side —
/// the backend derives the reviewer's buyer/seller role from the request
/// user, so it is never sent. When the role cannot be established (no value
/// passed and the transaction can't be resolved), the screen surfaces an
/// error and disables submit rather than guessing.
class WriteReviewScreen extends ConsumerStatefulWidget {
  final int transactionId;
  final bool? isBuyerReview;
  final String? counterpartyName;
  final String? counterpartyAvatar;
  final String? itemTitle;
  final String? itemImage;

  const WriteReviewScreen({
    super.key,
    required this.transactionId,
    this.isBuyerReview,
    this.counterpartyName,
    this.counterpartyAvatar,
    this.itemTitle,
    this.itemImage,
  });

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  int _rating = 0;
  List<int> _selectedTagIds = [];
  final _textController = TextEditingController();
  bool _isSubmitting = false;
  bool _isResolving = false;
  bool _resolveAttempted = false;

  bool? _resolvedIsBuyerReview;
  String? _resolvedCounterpartyName;
  String? _resolvedItemTitle;
  String? _resolvedItemImage;

  /// Whether we must fetch the transaction to fill in missing fields.
  bool get _needsResolution =>
      widget.isBuyerReview == null || widget.counterpartyName == null;

  /// The reviewer's buyer/seller role, or null when still unknown. Never
  /// defaulted — a null here means "cannot determine".
  bool? get _isBuyerReview => widget.isBuyerReview ?? _resolvedIsBuyerReview;

  bool get _roleKnown => _isBuyerReview != null;

  /// True once we've tried and failed to establish the role. Callers who
  /// passed the role explicitly never hit this.
  bool get _roleResolutionFailed =>
      widget.isBuyerReview == null && _resolveAttempted && !_roleKnown;

  String? get _counterpartyName => widget.counterpartyName ?? _resolvedCounterpartyName;
  String? get _itemTitle => widget.itemTitle ?? _resolvedItemTitle;
  String? get _counterpartyAvatar => widget.counterpartyAvatar;
  String? get _itemImage => widget.itemImage ?? _resolvedItemImage;

  @override
  void initState() {
    super.initState();
    if (_needsResolution) {
      _resolveTransactionDetails();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _resolveTransactionDetails() async {
    setState(() => _isResolving = true);

    final notifier = ref.read(transactionsProvider.notifier);
    Transaction? tx = _findTransaction();

    if (tx == null) {
      await notifier.fetchTransactions();
      if (!mounted) return;
      tx = _findTransaction();
    }

    if (!mounted) return;

    if (tx != null) {
      final currentUserId = ref.read(currentUserIdProvider);
      // Role is derived by comparing the current user to the transaction's
      // integer buyer/seller PKs. Returns null when the user is neither
      // party (or unknown) — we do NOT default to buyer in that case.
      final isBuyer = tx.isBuyerFor(currentUserId);
      final counterpartyName = isBuyer == null
          ? null
          : (isBuyer ? tx.sellerName : tx.buyerName);
      setState(() {
        _resolvedIsBuyerReview = isBuyer;
        _resolvedCounterpartyName =
            (counterpartyName != null && counterpartyName.isNotEmpty)
                ? counterpartyName
                : null;
        _resolvedItemTitle = tx!.itemTitle.isNotEmpty ? tx.itemTitle : null;
        _resolvedItemImage = tx.itemImage;
        _isResolving = false;
        _resolveAttempted = true;
      });
    } else {
      setState(() {
        _isResolving = false;
        _resolveAttempted = true;
      });
    }
  }

  Transaction? _findTransaction() {
    final transactions = ref.read(transactionsProvider).transactions;
    for (final t in transactions) {
      if (t.id == widget.transactionId) return t;
    }
    return null;
  }

  Future<void> _submit() async {
    if (_rating < 1 || _isSubmitting || !_roleKnown) return;

    setState(() => _isSubmitting = true);

    final review = await ref.read(reviewsProvider.notifier).submitReview(
          transactionId: widget.transactionId,
          rating: _rating,
          reviewText: _textController.text,
          tags: _selectedTagIds,
        );

    if (!mounted) return;

    final l = AppLocalizations.of(context);

    if (review != null) {
      // This transaction is no longer pending for the reviewer, and the
      // reviewed user's manner temperature just moved — drop the caches so
      // the profile nudge count and the counterparty's trust dial refresh
      // instead of showing stale data (and re-routing here for an
      // already-reviewed transaction).
      ref.invalidate(pendingReviewsProvider);
      ref.invalidate(userTrustScoreProvider(review.reviewedUser.id));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l?.reviewWriteSuccess ?? 'Review submitted successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop(true);
      return;
    }

    setState(() => _isSubmitting = false);

    // The service swallows non-2xx / network errors and returns null, so
    // always show the localized error rather than a raw provider string.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l?.reviewWriteError ?? 'Failed to submit review. Please try again.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l?.reviewWriteTitle ?? 'Write a review'),
      ),
      body: SafeArea(
        child: _isResolving
            ? _buildLoading(l, colorScheme)
            : _roleResolutionFailed
                ? _buildResolutionError(l, colorScheme)
                : _buildForm(l, colorScheme),
      ),
    );
  }

  Widget _buildLoading(AppLocalizations? l, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              l?.reviewWriteLoadingTransaction ?? 'Loading transaction details…',
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResolutionError(AppLocalizations? l, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l?.reviewWriteResolveError ??
                  "We couldn't load this transaction. Please try again.",
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _resolveTransactionDetails,
              icon: const Icon(Icons.refresh),
              label: Text(l?.reviewWriteRetry ?? 'Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(AppLocalizations? l, ColorScheme colorScheme) {
    final locale = Localizations.localeOf(context).languageCode;

    // Watching the tags list (rather than only reading the notifier) makes
    // the tag section rebuild once the async fetch triggered by
    // reviewTagsProvider's creation completes.
    ref.watch(reviewTagsProvider);
    final List<ReviewTag> roleTags = _roleKnown
        ? ref
            .read(reviewTagsProvider.notifier)
            .getTagsForRole(isBuyer: _isBuyerReview!)
        : const <ReviewTag>[];

    final canSubmit = _rating >= 1 && !_isSubmitting && _roleKnown;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_counterpartyName != null || _itemTitle != null) ...[
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.primaryContainer,
                  backgroundImage:
                      _counterpartyAvatar != null ? NetworkImage(_counterpartyAvatar!) : null,
                  child: _counterpartyAvatar == null
                      ? Icon(Icons.person, color: colorScheme.onPrimaryContainer)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_counterpartyName != null)
                        Text(
                          _counterpartyName!,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      if (_itemTitle != null)
                        Text(
                          _itemTitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (_itemImage != null) ...[
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      _itemImage!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
          ],
          Text(
            l?.reviewWriteRatingLabel ?? 'How was your experience?',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Center(
            child: StarRatingInput(
              rating: _rating,
              onChanged: (value) => setState(() => _rating = value),
            ),
          ),
          if (_rating == 0) ...[
            const SizedBox(height: 8),
            Center(
              child: Text(
                l?.reviewWriteRatingRequiredHint ?? 'Select at least 1 star to submit',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),
          if (roleTags.isNotEmpty) ...[
            Text(
              l?.reviewWriteTagsLabel ?? 'What went well? (optional)',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 12),
            ReviewTagSelector(
              tags: roleTags,
              selectedTagIds: _selectedTagIds,
              onChanged: (ids) => setState(() => _selectedTagIds = ids),
              locale: locale,
            ),
            const SizedBox(height: 28),
          ],
          Text(
            l?.reviewWriteCommentLabel ?? 'Additional comments (optional)',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _textController,
            minLines: 3,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: l?.reviewWriteCommentHint ?? 'Share more about your experience…',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canSubmit ? _submit : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l?.reviewWriteSubmitButton ?? 'Submit review'),
            ),
          ),
        ],
      ),
    );
  }
}
