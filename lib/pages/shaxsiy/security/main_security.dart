import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_change_password_flow.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_delete_account_flow.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_logout_all_dialog.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettingsPage extends ConsumerStatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  ConsumerState<SecuritySettingsPage> createState() =>
      _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<SecuritySettingsPage> {
  final bool _isTwoFactorEnabled = false;
  final bool _isBiometricEnabled = false;
  final bool _isLoginAlertsEnabled = true;

  int get _securityScore {
    int score = 50;
    if (_isTwoFactorEnabled) score += 25;
    if (_isBiometricEnabled) score += 15;
    if (_isLoginAlertsEnabled) score += 10;
    return score;
  }

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
              colors: [primary, primary.withOpacity(0.8)],
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
            _buildSecurityScoreCard(theme, primary, localizations),
            SecuritySection(
              title: localizations?.password_security ??
                  'Password & Authentication',
              icon: Icons.lock,
              children: [
                SecurityOption(
                  icon: Icons.key,
                  title: localizations?.change_password ?? 'Change Password',
                  subtitle: localizations?.last_changed_days ??
                      'Last changed 30 days ago',
                  trailing:
                      const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => showChangePasswordFlow(context, ref),
                ),
              ],
            ),
            _buildDangerZone(theme, localizations),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityScoreCard(
    ThemeData theme,
    Color primary,
    AppLocalizations? localizations,
  ) {
    final isSecure = _securityScore >= 70;
    final accentColor = isSecure ? primary : const Color(0xFFFF9800);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            isSecure ? Icons.verified_user : Icons.warning,
            size: 48,
            color: accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            isSecure
                ? (localizations?.account_secure ?? 'Account Secure')
                : (localizations?.improve_security ?? 'Improve Security'),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${localizations?.security_score ?? "Security Score"}: '
            '$_securityScore/100',
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _securityScore / 100,
            minHeight: 8,
            backgroundColor: theme.colorScheme.outlineVariant,
            valueColor: AlwaysStoppedAnimation(accentColor),
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(ThemeData theme, AppLocalizations? localizations) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.3)),
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
            title: localizations?.logout_all_devices ?? 'Logout All Devices',
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
