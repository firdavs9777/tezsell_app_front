import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/profile/reviews_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Paginated list of reviews a user has RECEIVED, backed by the public
/// `GET /api/reviews/users/<user_id>/reviews/` endpoint. Just chrome
/// (AppBar with a live review count) around the shared [ReviewsListView],
/// which owns the actual load-more pagination logic.
class UserReviewsScreen extends ConsumerStatefulWidget {
  final int userId;

  const UserReviewsScreen({super.key, required this.userId});

  @override
  ConsumerState<UserReviewsScreen> createState() => _UserReviewsScreenState();
}

class _UserReviewsScreenState extends ConsumerState<UserReviewsScreen> {
  int _totalCount = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

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
      body: ReviewsListView(
        userId: widget.userId,
        type: 'received',
        onCountChanged: (count) {
          if (!mounted) return;
          setState(() => _totalCount = count);
        },
      ),
    );
  }
}
