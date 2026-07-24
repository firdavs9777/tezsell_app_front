import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/profile/reviews_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The CURRENT user's own reviews, split into a "Received" / "Given" tab
/// pair (each tab backed by the shared [ReviewsListView] load-more widget,
/// see E3's `UserReviewsScreen`). Reads the signed-in user id from
/// SharedPreferences itself rather than requiring a caller to thread it
/// through `extra`, so this route also works from a bare deep link.
class MyReviewsScreen extends ConsumerStatefulWidget {
  const MyReviewsScreen({super.key});

  @override
  ConsumerState<MyReviewsScreen> createState() => _MyReviewsScreenState();
}

class _MyReviewsScreenState extends ConsumerState<MyReviewsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int? _currentUserId;
  bool _isLoadingUserId = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      final userIdStr = prefs.getString('userId');
      _currentUserId = userIdStr != null ? int.tryParse(userIdStr) : null;
      _isLoadingUserId = false;
    });
  }

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
        title: Text(localizations?.myReviewsTitle ?? 'My Reviews'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: localizations?.myReviewsReceivedTab ?? 'Received'),
            Tab(text: localizations?.myReviewsGivenTab ?? 'Given'),
          ],
        ),
      ),
      body: _buildBody(colorScheme, localizations),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, AppLocalizations? localizations) {
    if (_isLoadingUserId) {
      return const Center(child: CircularProgressIndicator());
    }

    final userId = _currentUserId;
    if (userId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            localizations?.profile_loading_error ?? 'Error loading profile',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    return TabBarView(
      controller: _tabController,
      children: [
        ReviewsListView(userId: userId, type: 'received'),
        ReviewsListView(userId: userId, type: 'given'),
      ],
    );
  }
}
