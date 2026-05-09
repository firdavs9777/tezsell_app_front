import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/admin/admin_dashboard.dart';
import 'package:app/pages/real_estate/agent/agent_dashboard_page.dart';
import 'package:app/pages/real_estate/agent/become_agent_page.dart';
import 'package:app/pages/shaxsiy/properties/saved_properties.dart';
import 'package:app/pages/shaxsiy/widgets/profile_menu_card.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:app/utils/app_logger.dart';
import 'package:app/utils/error_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSavedPropertiesCard extends ConsumerWidget {
  const ProfileSavedPropertiesCard({super.key, this.localizations});

  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(tokenProvider);

    void navigate() => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SavedProperties()),
        );

    ProfileMenuCard card(String subtitle, {VoidCallback? onTap}) {
      return ProfileMenuCard(
        icon: Icons.real_estate_agent_rounded,
        title: localizations?.saved_properties_title ?? 'Saved Properties',
        subtitle: subtitle,
        iconColor: const Color(0xFF4CAF50),
        onTap: onTap ?? navigate,
      );
    }

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return card('Login to view saved properties');
        }

        final savedPropertiesAsync =
            ref.watch(savedPropertiesNotifierProvider(token));

        return savedPropertiesAsync.when(
          data: (response) => card('${response.count} items'),
          loading: () => card('Loading...'),
          error: (_, __) => card('0 items'),
        );
      },
      loading: () => card('Loading...', onTap: () {}),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class ProfileAgentCard extends ConsumerWidget {
  const ProfileAgentCard({
    super.key,
    this.localizations,
    required this.onAgentApplied,
  });

  final AppLocalizations? localizations;
  final VoidCallback onAgentApplied;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokenAsync = ref.watch(tokenProvider);

    return tokenAsync.when(
      data: (token) {
        if (token == null) {
          return ProfileMenuCard(
            icon: Icons.badge_rounded,
            title: localizations?.becomeAgent ?? 'Become an Agent',
            subtitle: 'Login to apply',
            iconColor: const Color(0xFF2196F3),
            onTap: () => Navigator.of(context).pushNamed('/login'),
          );
        }

        return FutureBuilder<Map<String, dynamic>>(
          future: ref
              .read(realEstateServiceProvider)
              .getAgentStatus(token: token)
              .catchError((e) =>
                  <String, dynamic>{'is_agent': false, 'is_verified': false}),
          builder: (context, snapshot) {
            final isAgent = snapshot.data?['is_agent'] ?? false;
            final isVerified = snapshot.data?['is_verified'] ?? false;

            if (isAgent && isVerified) {
              return ProfileMenuCard(
                icon: Icons.verified_user_rounded,
                title:
                    localizations?.general_verified_agent ?? 'Verified Agent',
                subtitle: localizations?.agentViewProfile ??
                    'View your agent profile',
                iconColor: const Color(0xFF4CAF50),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AgentDashboardPage()),
                ),
              );
            }

            if (isAgent && !isVerified) {
              return ProfileMenuCard(
                icon: Icons.pending_rounded,
                title: localizations?.general_application_under_review ??
                    'Application Under Review',
                subtitle:
                    localizations?.general_check_status ?? 'Check status',
                iconColor: const Color(0xFFFF9800),
                onTap: () => _showApplicationStatus(context, ref, token),
              );
            }

            return ProfileMenuCard(
              icon: Icons.badge_rounded,
              title: localizations?.becomeAgent ?? 'Become an Agent',
              subtitle: localizations?.becomeAgentSubtitle ??
                  'List properties and help clients',
              iconColor: const Color(0xFF2196F3),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const BecomeAgentPage()),
              ).then((success) {
                if (success == true) onAgentApplied();
              }),
            );
          },
        );
      },
      loading: () => ProfileMenuCard(
        icon: Icons.badge_rounded,
        title: localizations?.becomeAgent ?? 'Become an Agent',
        subtitle: 'Loading...',
        iconColor: const Color(0xFF2196F3),
        onTap: () {},
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _showApplicationStatus(
    BuildContext context,
    WidgetRef ref,
    String token,
  ) async {
    try {
      final status = await ref
          .read(realEstateServiceProvider)
          .getAgentApplicationStatus(token: token);
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
              localizations?.agentApplicationStatus ?? 'Application Status'),
          content: Text(
              status['message'] ?? 'Your application is being reviewed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations?.close ?? 'Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) {
        AppErrorHandler.showError(context, e);
      }
    }
  }
}

class ProfileAdminSection extends StatelessWidget {
  const ProfileAdminSection({
    super.key,
    required this.user,
    this.localizations,
  });

  final UserInfo user;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    final hasAdminAccess = user.hasAdminAccess;

    if (kDebugMode) {
      AppLogger.debug(
        'User admin check: userType=${user.userType}, '
        'isStaff=${user.isStaff}, isSuperuser=${user.isSuperuser}, '
        'hasAdminAccess=$hasAdminAccess',
      );
    }

    if (!hasAdminAccess) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileSectionTitle(localizations?.admin_panel ?? 'Admin Panel'),
        ProfileMenuCard(
          icon: Icons.admin_panel_settings,
          title: localizations?.admin_dashboard_title ?? 'Admin Dashboard',
          subtitle: localizations?.admin_dashboard_subtitle ??
              'Real-time overview of your platform',
          iconColor: const Color(0xFF9C27B0),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminDashboard()),
          ),
        ),
      ],
    );
  }
}
