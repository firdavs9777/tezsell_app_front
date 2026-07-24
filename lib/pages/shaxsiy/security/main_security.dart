import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_change_password_flow.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_delete_account_flow.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_login_history_section.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_logout_all_dialog.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Security settings screen.
///
/// Only shows controls that are actually backed by something real: change
/// password, this device's login history, "logout all devices" (backed by
/// `POST /accounts/logout-all/`), and account deletion. There is
/// deliberately no 2FA/biometric toggle or "security score" here -- those
/// flows don't exist yet, and showing them would be misleading.
class SecuritySettingsPage extends ConsumerStatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  ConsumerState<SecuritySettingsPage> createState() =>
      _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<SecuritySettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, primary.withValues(alpha: 0.8)],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.security ?? 'Security',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            SecuritySection(
              title: localizations?.password_security ??
                  'Password & Authentication',
              icon: Icons.lock,
              children: [
                SecurityOption(
                  icon: Icons.key,
                  title: localizations?.change_password ?? 'Change Password',
                  subtitle: localizations?.verification_code_message ??
                      "We'll send a verification code to confirm it's you.",
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => showChangePasswordFlow(context, ref),
                ),
              ],
            ),
            const SecurityLoginHistorySection(),
            _buildDangerZone(theme, localizations),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZone(ThemeData theme, AppLocalizations? localizations) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: theme.colorScheme.error),
              const SizedBox(width: 8),
              Text(
                localizations?.danger_zone ?? 'Danger Zone',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecurityDangerOption(
            icon: Icons.logout,
            title: localizations?.securityLogoutAll ?? 'Logout All Devices',
            subtitle: localizations?.end_all_sessions ?? 'End all sessions',
            onTap: () => showLogoutAllDialog(context, ref),
          ),
          const Divider(height: 24),
          SecurityDangerOption(
            icon: Icons.delete_forever,
            title: localizations?.delete_account ?? 'Delete Account',
            subtitle:
                localizations?.permanently_delete ?? 'Permanently delete',
            onTap: () => showDeleteAccountFlow(context, ref),
          ),
        ],
      ),
    );
  }
}
