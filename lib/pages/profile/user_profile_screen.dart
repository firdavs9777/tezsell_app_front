import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/profile/widgets/sliver_tab_bar_delegate.dart';
import 'package:app/pages/profile/widgets/user_profile_grids.dart';
import 'package:app/pages/profile/widgets/user_profile_more_options.dart';
import 'package:app/providers/provider_models/trust_score_model.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/reviews_provider.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/follow_list_sheet.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/service_rating_badge.dart';
import 'package:app/widgets/trust_score_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _isFollowLoading = false;
  int? _currentUserId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      final userIdStr = prefs.getString('userId');
      _currentUserId = userIdStr != null ? int.tryParse(userIdStr) : null;
    });
  }

  Future<void> _toggleFollow(UserProfile profile) async {
    if (_isFollowLoading) return;

    setState(() {
      _isFollowLoading = true;
    });

    try {
      final profileService = ref.read(profileServiceProvider);
      if (profile.isFollowing) {
        await profileService.unfollowUser(userId: profile.id);
      } else {
        await profileService.followUser(userId: profile.id);
      }
      ref.invalidate(userProfileProvider(widget.userId));
    } catch (e) {
      if (mounted) {
        AppErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFollowLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider(widget.userId));
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        title: profileAsync.whenOrNull(
          data: (profile) => Text(
            profile.username,
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          profileAsync.whenOrNull(
            data: (profile) => IconButton(
              icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
              onPressed: () => showUserProfileMoreOptions(context, profile),
            ),
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error, colorScheme),
        data: (profile) => _buildProfileContent(profile, theme, colorScheme),
      ),
    );
  }

  Widget _buildErrorState(Object error, ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_off_outlined,
                size: 48,
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)?.profile_loading_error ?? 'Error loading profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppErrorHandler.getErrorMessage(error),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.invalidate(userProfileProvider(widget.userId));
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(AppLocalizations.of(context)?.profile_retry ?? 'Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    UserProfile profile,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final isOwnProfile = _currentUserId != null && profile.id == _currentUserId;

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header Row
                  Row(
                    children: [
                      // Profile Avatar
                      _buildProfileAvatar(profile, colorScheme),
                      const SizedBox(width: 24),
                      // Stats Row
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatColumn(
                              count: profile.totalListings,
                              label: AppLocalizations.of(context)?.profile_listings ?? 'Listings',
                              onTap: null,
                            ),
                            _buildStatColumn(
                              count: profile.followersCount,
                              label: AppLocalizations.of(context)?.profile_followers ?? 'Followers',
                              onTap: () => _showFollowersSheet(context, profile),
                            ),
                            _buildStatColumn(
                              count: profile.followingCount,
                              label: AppLocalizations.of(context)?.profile_following ?? 'Following',
                              onTap: () => _showFollowingSheet(context, profile),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Username and Info
                  Text(
                    profile.username,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Location
                  if (profile.location.shortAddress.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          profile.location.shortAddress,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                  // Member since
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${AppLocalizations.of(context)?.profile_member_since ?? 'Member since'}: ${profile.memberSinceFormatted}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Trust surface (Karrot-style manner temperature, rating,
                  // badges, reviews). Vacation status is intentionally NOT
                  // shown here -- see _buildTrustSection for why.
                  _buildTrustSection(context, theme, colorScheme),
                  const SizedBox(height: 16),

                  // Action Buttons
                  // Chats start from listings (see 2026-07-19 chat spec); direct DM entry removed
                  if (!isOwnProfile)
                    SizedBox(
                      width: double.infinity,
                      child: _buildFollowButton(context, profile, colorScheme),
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          // Navigate to edit profile
                          context.push('/settings/profile');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: BorderSide(color: colorScheme.outline),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.of(context)?.editProfileModalTitle ?? 'Edit Profile',
                          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverPersistentHeader(
            pinned: true,
            delegate: SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                indicatorColor: colorScheme.primary,
                indicatorWeight: 2,
                labelColor: colorScheme.primary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on_rounded, size: 24)),
                  Tab(icon: Icon(Icons.handyman_outlined, size: 24)),
                  Tab(icon: Icon(Icons.home_work_outlined, size: 24)),
                ],
              ),
              colorScheme.surface,
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          UserProfileProductsGrid(profile: profile),
          UserProfileServicesGrid(profile: profile),
          const UserProfilePropertiesGrid(),
        ],
      ),
    );
  }

  /// Karrot-style trust surface: manner-temperature dial, rating + review
  /// count, badges, and a tappable "Reviews (N)" row that opens the full
  /// paginated reviews list.
  ///
  /// Keyed per `widget.userId` via the `userTrustScoreProvider` FutureProvider
  /// family (NOT the shared non-family `trustScoreProvider`), so navigating
  /// from user A's profile to user B's never leaks A's trust data.
  ///
  /// `ReviewsService.getTrustScore` already catches network/parse failures
  /// and resolves to `TrustScore.defaultScore(...)` (36.5°, zero reviews)
  /// rather than throwing, so in practice this Future never rejects -- the
  /// `error` branch below is just a defensive fallback so a genuinely
  /// unexpected error still renders something instead of leaving a
  /// permanently-loading widget.
  ///
  /// TODO(plan-g): Vacation badge omitted here on purpose. `VacationBadge`
  /// exists but `vacationModeProvider`/`isOnVacationProvider` only expose the
  /// CURRENTLY-LOGGED-IN user's vacation status (no per-user family, no
  /// userId param -- see vacation_mode_provider.dart), and neither
  /// `UserProfile` nor the trust-score payload expose another user's
  /// vacation status publicly. Wiring the current-user provider here would
  /// wrongly show the viewer's own vacation state on someone else's profile.
  /// Surfacing this correctly needs a public per-user vacation field added
  /// to the profile/trust-score API first.
  Widget _buildTrustSection(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final trustAsync = ref.watch(userTrustScoreProvider(widget.userId));
    final localizations = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return trustAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (trustScore) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TrustScoreWidget(
            temperature: trustScore.temperature,
            level: trustScore.temperatureLevel,
            emoji: trustScore.temperatureEmoji,
            showLabel: false,
          ),
          if (trustScore.badges.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildBadgesRow(trustScore.badges, locale),
          ],
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => context.push('/user/${widget.userId}/reviews'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      trustScore.reviewsReceived > 0
                          ? (localizations
                                  ?.profile_reviews_count(trustScore.reviewsReceived) ??
                              'Reviews (${trustScore.reviewsReceived})')
                          : (localizations?.profile_no_reviews_yet ??
                              'No reviews yet'),
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trustScore.reviewsReceived > 0) ...[
                    ServiceRatingBadge(
                      ratingAvg: trustScore.averageRating,
                      ratingCount: trustScore.reviewsReceived,
                      compact: true,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesRow(List<UserBadge> badges, String locale) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final badge = badges[index];
          final color = Color(badge.colorValue);

          return Tooltip(
            message: badge.description ?? badge.getLocalizedName(locale),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(badge.icon, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 4),
                  Text(
                    badge.getLocalizedName(locale),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileAvatar(UserProfile profile, ColorScheme colorScheme) {
    final hasImage = profile.profileImage.image.isNotEmpty;

    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewer(
                    imageUrl: profile.profileImage.image,
                    title: profile.username,
                  ),
                ),
              );
            }
          : null,
      child: Hero(
        tag: 'profile_image_${profile.id}',
        child: Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.tertiary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surface,
            ),
            padding: const EdgeInsets.all(2),
            child: ClipOval(
              child: hasImage
                  ? CachedNetworkImageWidget(
                      imageUrl: profile.profileImage.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: colorScheme.primaryContainer,
                      child: Center(
                        child: Text(
                          profile.initials,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required int count,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Text(
              _formatCount(count),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }

  Widget _buildFollowButton(BuildContext context, UserProfile profile, ColorScheme colorScheme) {
    final isFollowing = profile.isFollowing;
    final localizations = AppLocalizations.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: _isFollowLoading
          ? Container(
              height: 36,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            )
          : isFollowing
              ? OutlinedButton(
                  onPressed: () => _toggleFollow(profile),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(color: colorScheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    localizations?.profile_following_btn ?? 'Following',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                )
              : FilledButton(
                  onPressed: () => _toggleFollow(profile),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    localizations?.profile_follow ?? 'Follow',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
    );
  }

  // Chats start from listings (see 2026-07-19 chat spec); direct DM entry
  // removed -- `_buildMessageButton`/`_startChatWithUser` used to call the
  // now-staff-only `/chats/direct/` endpoint, which would 403 for regular
  // users.

  void _showFollowersSheet(BuildContext context, UserProfile profile) {
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => FollowListSheet(
        title: localizations?.profile_followers ?? 'Followers',
        userId: profile.id,
        isFollowers: true,
      ),
    );
  }

  void _showFollowingSheet(BuildContext context, UserProfile profile) {
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => FollowListSheet(
        title: localizations?.profile_following ?? 'Following',
        userId: profile.id,
        isFollowers: false,
      ),
    );
  }
}
