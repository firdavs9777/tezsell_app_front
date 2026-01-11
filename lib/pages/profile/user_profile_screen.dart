import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/chat/chat_room.dart';
import 'package:app/providers/provider_models/user_profile_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/utils/error_handler.dart';
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
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          profileAsync.whenOrNull(
            data: (profile) => IconButton(
              icon: Icon(Icons.more_horiz, color: colorScheme.onSurface),
              onPressed: () => _showMoreOptions(context, profile),
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
                color: colorScheme.errorContainer.withOpacity(0.3),
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppErrorHandler.getErrorMessage(error),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
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
                              label: AppLocalizations.of(context)?.profile_listings ?? "Listings",
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
                    style: const TextStyle(
                      fontSize: 16,
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
                          style: TextStyle(
                            fontSize: 14,
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
                        style: TextStyle(
                          fontSize: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  if (!isOwnProfile)
                    Row(
                      children: [
                        Expanded(
                          child: _buildFollowButton(context, profile, colorScheme),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildMessageButton(context, profile, colorScheme),
                        ),
                      ],
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
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
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
          // Products Tab
          _buildProductsGrid(context, profile, colorScheme),
          // Services Tab
          _buildServicesGrid(context, profile, colorScheme),
          // Properties Tab
          _buildPropertiesGrid(context, profile, colorScheme),
        ],
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
                color: colorScheme.primary.withOpacity(0.3),
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
                          style: TextStyle(
                            fontSize: 28,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
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
                    style: const TextStyle(fontWeight: FontWeight.w600),
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
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
    );
  }

  Widget _buildMessageButton(BuildContext context, UserProfile profile, ColorScheme colorScheme) {
    final localizations = AppLocalizations.of(context);
    return OutlinedButton(
      onPressed: () => _startChatWithUser(context, profile),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        localizations?.profile_message ?? 'Message',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Future<void> _startChatWithUser(BuildContext context, UserProfile profile) async {
    final targetUserId = profile.id;
    final userName = profile.username;
    final localizations = AppLocalizations.of(context);

    // Initialize chat provider if not already initialized
    await ref.read(chatProvider.notifier).initialize();

    // Check authentication after initialization
    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.chatLoginMessage ?? 'Please log in to start a chat'),
            backgroundColor: const Color(0xFFFF9800),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Prevent chatting with yourself
    if (chatState.currentUserId == targetUserId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.cannot_chat_with_yourself ?? 'You cannot chat with yourself'),
            backgroundColor: const Color(0xFFFF9800),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show modern loading bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              localizations?.opening_chat_with(userName) ?? 'Opening chat with $userName...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              localizations?.this_will_only_take_a_moment ?? 'This will only take a moment',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      if (mounted) Navigator.of(context).pop(); // Close bottom sheet

      if (chatRoom != null && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
          ),
        );
      } else {
        throw Exception('Failed to create or retrieve chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.unable_to_start_chat ?? 'Unable to start chat. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations?.profile_retry ?? 'Retry',
              textColor: Colors.white,
              onPressed: () => _startChatWithUser(context, profile),
            ),
          ),
        );
      }
    }
  }

  Widget _buildProductsGrid(BuildContext context, UserProfile profile, ColorScheme colorScheme) {
    final productsAsync = ref.watch(userProductsProvider(profile.id));
    final localizations = AppLocalizations.of(context);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildEmptyState(
        icon: Icons.error_outline,
        title: localizations?.profile_error_occurred ?? "Error occurred",
        subtitle: localizations?.profile_error_loading_products ?? "Error loading products",
        colorScheme: colorScheme,
      ),
      data: (products) {
        if (products.isEmpty) {
          return _buildEmptyState(
            icon: Icons.inventory_2_outlined,
            title: localizations?.profile_no_products ?? "No products",
            subtitle: localizations?.profile_user_no_products ?? "This user hasn't posted any products yet",
            colorScheme: colorScheme,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => context.push('/product/${product.id}'),
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: product.images.isNotEmpty
                    ? Image.network(
                        product.images[0].image.startsWith('http')
                            ? product.images[0].image
                            : 'https://api.webtezsell.com${product.images[0].image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServicesGrid(BuildContext context, UserProfile profile, ColorScheme colorScheme) {
    final servicesAsync = ref.watch(userServicesProvider(profile.id));
    final localizations = AppLocalizations.of(context);

    return servicesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildEmptyState(
        icon: Icons.error_outline,
        title: localizations?.profile_error_occurred ?? "Error occurred",
        subtitle: localizations?.profile_error_loading_services ?? "Error loading services",
        colorScheme: colorScheme,
      ),
      data: (services) {
        if (services.isEmpty) {
          return _buildEmptyState(
            icon: Icons.handyman_outlined,
            title: localizations?.profile_no_services ?? "No services",
            subtitle: localizations?.profile_user_no_services ?? "This user hasn't posted any services yet",
            colorScheme: colorScheme,
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];
            return GestureDetector(
              onTap: () => context.push('/service/${service.id}'),
              child: Container(
                color: colorScheme.surfaceContainerHighest,
                child: service.images.isNotEmpty
                    ? Image.network(
                        service.images[0].image.startsWith('http')
                            ? service.images[0].image
                            : 'https://api.webtezsell.com${service.images[0].image}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : Icon(
                        Icons.handyman_outlined,
                        color: colorScheme.onSurfaceVariant,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPropertiesGrid(BuildContext context, UserProfile profile, ColorScheme colorScheme) {
    final localizations = AppLocalizations.of(context);
    // Properties are not in the model yet, show empty state
    return _buildEmptyState(
      icon: Icons.home_work_outlined,
      title: localizations?.profile_no_properties ?? "No properties",
      subtitle: localizations?.profile_user_no_properties ?? "This user hasn't posted any properties yet",
      colorScheme: colorScheme,
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFollowersSheet(BuildContext context, UserProfile profile) {
    final localizations = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _FollowListSheet(
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
      builder: (sheetContext) => _FollowListSheet(
        title: localizations?.profile_following ?? 'Following',
        userId: profile.id,
        isFollowers: false,
      ),
    );
  }

  void _showMoreOptions(BuildContext context, UserProfile profile) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final profileUrl = 'https://webtezsell.com/user/${profile.id}';

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(localizations?.profile_share ?? 'Share'),
              onTap: () {
                Navigator.pop(sheetContext);
                _shareProfile(context, profile, profileUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: Text(localizations?.profile_copy_link ?? 'Copy link'),
              onTap: () {
                Navigator.pop(sheetContext);
                _copyProfileLink(context, profileUrl);
              },
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, color: colorScheme.error),
              title: Text(localizations?.profile_report ?? 'Report', style: TextStyle(color: colorScheme.error)),
              onTap: () {
                Navigator.pop(sheetContext);
                _reportUser(context, profile);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _shareProfile(BuildContext context, UserProfile profile, String profileUrl) {
    final localizations = AppLocalizations.of(context);
    final shareText = '${localizations?.checkOutProfile ?? "Check out"} ${profile.username} ${localizations?.onTezsell ?? "on TezSell"}: $profileUrl';
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareText,
      subject: profile.username,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100),
    );
  }

  void _copyProfileLink(BuildContext context, String profileUrl) {
    final localizations = AppLocalizations.of(context);
    Clipboard.setData(ClipboardData(text: profileUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations?.linkCopied ?? 'Link copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _reportUser(BuildContext context, UserProfile profile) async {
    final localizations = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => ReportContentDialog(
        contentType: 'user',
        contentId: profile.id,
        contentTitle: profile.username,
      ),
    );

    if (result == true && mounted) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(localizations?.reportSubmitted ?? 'Report submitted successfully'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: colorScheme.primary,
        ),
      );
    }
  }
}

// Sliver Tab Bar Delegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this.tabBar, this.backgroundColor);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

// Follow List Bottom Sheet
class _FollowListSheet extends ConsumerWidget {
  final String title;
  final int userId;
  final bool isFollowers;

  const _FollowListSheet({
    required this.title,
    required this.userId,
    required this.isFollowers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = isFollowers
        ? ref.watch(userFollowersProvider(userId))
        : ref.watch(userFollowingProvider(userId));
    final colorScheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(height: 1, color: colorScheme.outlineVariant),
            // List
            Expanded(
              child: listAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppErrorHandler.getErrorMessage(error),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ),
                ),
                data: (response) {
                  final localizations = AppLocalizations.of(context);
                  if (response.results.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isFollowers
                                ? (localizations?.profile_no_followers_yet ?? "No followers yet")
                                : (localizations?.profile_no_following_yet ?? "Not following anyone yet"),
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: response.results.length,
                    itemBuilder: (context, index) {
                      final user = response.results[index];
                      return _FollowUserTile(user: user);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FollowUserTile extends ConsumerStatefulWidget {
  final FollowUser user;

  const _FollowUserTile({required this.user});

  @override
  ConsumerState<_FollowUserTile> createState() => _FollowUserTileState();
}

class _FollowUserTileState extends ConsumerState<_FollowUserTile> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.user.isFollowing;
  }

  Future<void> _toggleFollow() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profileService = ref.read(profileServiceProvider);
      if (_isFollowing) {
        await profileService.unfollowUser(userId: widget.user.id);
      } else {
        await profileService.followUser(userId: widget.user.id);
      }
      setState(() {
        _isFollowing = !_isFollowing;
      });
    } catch (e) {
      if (mounted) {
        AppErrorHandler.showError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return ListTile(
      onTap: () {
        Navigator.of(context).pop();
        context.push('/user/${widget.user.id}');
      },
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: colorScheme.primaryContainer,
        child: widget.user.profileImage.image.isNotEmpty
            ? ClipOval(
                child: CachedNetworkImageWidget(
                  imageUrl: widget.user.profileImage.image,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              )
            : Text(
                widget.user.initials,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
      ),
      title: Text(
        widget.user.username,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : SizedBox(
              width: 100,
              child: _isFollowing
                  ? OutlinedButton(
                      onPressed: _toggleFollow,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                        side: BorderSide(color: colorScheme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localizations?.profile_following_btn ?? 'Following',
                        style: const TextStyle(fontSize: 13),
                      ),
                    )
                  : FilledButton(
                      onPressed: _toggleFollow,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        localizations?.profile_follow ?? 'Follow',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
            ),
    );
  }
}
