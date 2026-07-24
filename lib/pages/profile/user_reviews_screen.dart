import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/review_model.dart';
import 'package:app/providers/provider_root/reviews_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/review_tags.dart';
import 'package:app/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

/// Paginated list of reviews a user has RECEIVED, backed by the public
/// `GET /api/reviews/users/<user_id>/reviews/` endpoint. Mirrors the
/// load-more pattern used by `ProductsList`/`ServicesList`, but driven by
/// the backend's own `page`/`page_size`/`total_pages` envelope rather than
/// a client-side "results.length >= pageSize" heuristic.
class UserReviewsScreen extends ConsumerStatefulWidget {
  final int userId;

  const UserReviewsScreen({super.key, required this.userId});

  @override
  ConsumerState<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends ConsumerState<UserReviewsScreen> {
  static const _pageSize = 10;

  final ScrollController _scrollController = ScrollController();
  final List<Review> _reviews = [];

  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _isDisposed = false;
  Object? _initialError;
  int _currentPage = 1;
  int _totalCount = 0;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMore();
      }
    }
  }

  Future<void> _loadInitial() async {
    final thisGeneration = ++_loadGeneration;
    setState(() {
      _isInitialLoading = true;
      _initialError = null;
    });

    try {
      final page = await ref
          .read(reviewsServiceProvider)
          .getUserReviewsPage(widget.userId, page: 1, pageSize: _pageSize);

      if (!mounted || _isDisposed || thisGeneration != _loadGeneration) return;
      setState(() {
        _reviews
          ..clear()
          ..addAll(page.reviews);
        _currentPage = page.page;
        _totalCount = page.total;
        _hasMoreData = page.hasMore;
        _isInitialLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed || thisGeneration != _loadGeneration) return;
      setState(() {
        _initialError = e;
        _isInitialLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMoreData || !mounted || _isDisposed) return;

    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final page = await ref
          .read(reviewsServiceProvider)
          .getUserReviewsPage(widget.userId, page: nextPage, pageSize: _pageSize);

      if (!mounted || _isDisposed) return;
      setState(() {
        _reviews.addAll(page.reviews);
        _currentPage = page.page;
        _totalCount = page.total;
        _hasMoreData = page.hasMore;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;
      setState(() {
        _isLoadingMore = false;
        // Stop retrying automatically on error; pull-to-refresh /
        // re-entering the screen will retry the initial page.
        _hasMoreData = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
        title: Text(
          localizations?.profile_reviews_count(_totalCount) ??
              'Reviews ($_totalCount)',
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(theme, colorScheme, localizations, locale),
    );
  }

  Widget _buildBody(
    ThemeData theme,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
    String locale,
  ) {
    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_initialError != null && _reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                localizations?.profile_loading_error ?? 'Error loading profile',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                AppErrorHandler.getErrorMessage(_initialError),
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _loadInitial,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(localizations?.profile_retry ?? 'Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_reviews.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_outline_rounded,
                size: 48,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                localizations?.profile_no_reviews_yet ?? 'No reviews yet',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                localizations?.profile_user_no_reviews ??
                    "This user hasn't received any reviews yet",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _reviews.length + 1,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
      ),
      itemBuilder: (context, index) {
        if (index < _reviews.length) {
          return _ReviewTile(review: _reviews[index], locale: locale);
        }

        if (_hasMoreData || _isLoadingMore) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              localizations?.no_more_reviews ?? 'No more reviews to load',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.locale});

  final Review review;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasAvatar = (review.reviewer.avatar ?? '').isNotEmpty;
    final reviewerName =
        review.reviewer.username.isNotEmpty ? review.reviewer.username : '—';
    final reviewText = review.reviewText?.trim() ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: colorScheme.primaryContainer,
                child: hasAvatar
                    ? ClipOval(
                        child: CachedNetworkImageWidget(
                          imageUrl: review.reviewer.avatar!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Text(
                        reviewerName[0].toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reviewerName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM d, yyyy').format(review.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    StarRatingDisplay(
                      rating: review.rating.toDouble(),
                      size: 14,
                      showValue: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (review.tags.isNotEmpty) ...[
            const SizedBox(height: 8),
            ReviewTagsDisplay(tags: review.tags, size: 0.9, locale: locale),
          ],
          if (reviewText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              reviewText,
              softWrap: true,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
