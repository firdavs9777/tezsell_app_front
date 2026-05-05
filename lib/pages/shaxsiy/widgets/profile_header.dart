import 'package:app/constants/constants.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.totalListings,
    required this.currentUserId,
    required this.onShowListings,
    required this.onShowFollowers,
    required this.onShowFollowing,
    required this.onEditProfile,
  });

  final UserInfo user;
  final int totalListings;
  final int? currentUserId;
  final VoidCallback onShowListings;
  final VoidCallback onShowFollowers;
  final VoidCallback onShowFollowing;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);

    int followersCount = 0;
    int followingCount = 0;

    if (currentUserId != null) {
      final profileAsync = ref.watch(userProfileProvider(currentUserId!));
      profileAsync.whenData((profile) {
        followersCount = profile.followersCount;
        followingCount = profile.followingCount;
      });
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(user: user, colorScheme: colorScheme),
              const SizedBox(width: 24),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatColumn(
                      count: totalListings,
                      label: localizations?.profile_listings ?? "E'lonlar",
                      onTap: onShowListings,
                    ),
                    _StatColumn(
                      count: followersCount,
                      label: localizations?.profile_followers ?? 'Obunachilar',
                      onTap: onShowFollowers,
                    ),
                    _StatColumn(
                      count: followingCount,
                      label: localizations?.profile_following ?? 'Obunalar',
                      onTap: onShowFollowing,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(user.username, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.email_outlined,
                size: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (user.location != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.location!.region}, ${user.location!.district}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onEditProfile,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: BorderSide(color: colorScheme.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                localizations?.editProfileModalTitle ??
                    'Profilni tahrirlash',
                style: theme.textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

String? _resolveProfileImageUrl(UserInfo user) {
  final image = user.profileImage?.image;
  if (image == null || image.isEmpty) return null;
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return image;
  }
  return '$baseUrl$image';
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user, required this.colorScheme});

  final UserInfo user;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final imageUrl = _resolveProfileImageUrl(user);
    final imageProvider =
        imageUrl != null ? NetworkImage(imageUrl) : null;

    return GestureDetector(
      onTap: imageUrl == null
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewer(
                    imageUrl: imageUrl,
                    title: user.username,
                  ),
                ),
              );
            },
      child: Container(
        width: 86,
        height: 86,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.tertiary],
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
          child: CircleAvatar(
            radius: 38,
            backgroundColor: colorScheme.primaryContainer,
            backgroundImage: imageProvider,
            child: imageProvider == null
                ? Text(
                    user.username.isNotEmpty
                        ? user.username[0].toUpperCase()
                        : '?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.count,
    required this.label,
    this.onTap,
  });

  final int count;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Text(
              _formatCount(count),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
