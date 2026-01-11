import 'package:app/pages/authentication/login.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecuritySettingsPage extends ConsumerStatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  ConsumerState<SecuritySettingsPage> createState() =>
      _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends ConsumerState<SecuritySettingsPage> {
  bool _isTwoFactorEnabled = false;
  bool _isBiometricEnabled = false;
  bool _isLoginAlertsEnabled = true;
  late Future<UserInfo> _userInfoFuture;

  int get _securityScore {
    int score = 50;
    if (_isTwoFactorEnabled) score += 25;
    if (_isBiometricEnabled) score += 15;
    if (_isLoginAlertsEnabled) score += 10;
    return score;
  }

  Color get _primaryColor => Theme.of(context).primaryColor;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo();
  }

  Future<UserInfo> fetchUserInfo() async {
    return await ref.read(profileServiceProvider).getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              colors: [
                _primaryColor,
                _primaryColor.withOpacity(0.8),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations?.security ?? 'Security',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: theme.colorScheme.onPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Security Status
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _primaryColor.withOpacity(0.1),
                    _primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    _securityScore >= 70 ? Icons.verified_user : Icons.warning,
                    size: 48,
                    color: _securityScore >= 70 ? theme.colorScheme.primary : const Color(0xFFFF9800),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _securityScore >= 70
                        ? (localizations?.account_secure ?? 'Account Secure')
                        : (localizations?.improve_security ??
                            'Improve Security'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color:
                          _securityScore >= 70 ? theme.colorScheme.primary : const Color(0xFFFF9800),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                      '${localizations?.security_score ?? "Security Score"}: $_securityScore/100'),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _securityScore / 100,
                    minHeight: 8,
                    backgroundColor: theme.colorScheme.outlineVariant,
                    valueColor: AlwaysStoppedAnimation(
                      _securityScore >= 70 ? theme.colorScheme.primary : const Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ),

            // Password & Authentication
            _buildSection(
              localizations?.password_security ?? 'Password & Authentication',
              Icons.lock,
              theme,
              [
                _buildOption(
                  Icons.key,
                  localizations?.change_password ?? 'Change Password',
                  localizations?.last_changed_days ??
                      'Last changed 30 days ago',
                  const Icon(Icons.arrow_forward_ios, size: 16),
                  _showChangePasswordDialog,
                ),
              ],
            ),

            // Danger Zone
            Container(
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDangerOption(
                    Icons.logout,
                    localizations?.logout_all_devices ?? 'Logout All Devices',
                    localizations?.end_all_sessions ?? 'End all sessions',
                    _showLogoutAll,
                  ),
                  const Divider(height: 24),
                  _buildDangerOption(
                    Icons.delete_forever,
                    localizations?.delete_account ?? 'Delete Account',
                    localizations?.permanently_delete ?? 'Permanently delete',
                    _showDeleteAccount,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, IconData icon, ThemeData theme, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _primaryColor),
              const SizedBox(width: 8),
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ...children.map((e) =>
              Padding(padding: const EdgeInsets.only(bottom: 12), child: e)),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, String subtitle,
      Widget trailing, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildDangerOption(
      IconData icon, String title, String subtitle, VoidCallback onTap) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.error, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error)),
                Text(subtitle,
                    style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.error.withOpacity(0.7)),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() async {
    if (!mounted) return;
    final localizations = AppLocalizations.of(context);
    final currentPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: _primaryColor),
            const SizedBox(width: 8),
            Text(localizations?.change_password ?? 'Change Password'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your current password to verify your identity',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock, color: _primaryColor),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final currentPassword = currentPasswordController.text.trim();
              if (currentPassword.isEmpty) {
                _showError('Please enter your current password');
                return;
              }
              Navigator.pop(context);
              await _requestPasswordUpdate(currentPassword);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPasswordUpdate(String currentPassword) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: _primaryColor)),
    );

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.requestPasswordUpdate(
      currentPassword: currentPassword,
    );

    if (mounted) Navigator.pop(context);

    if (result['success']) {
      if (mounted) {
        _showSuccess(result['message']);
        _showPasswordUpdateDialog();
      }
    } else {
      if (mounted) {
        _showError(result['error']);
      }
    }
  }

  void _showPasswordUpdateDialog() {
    final localizations = AppLocalizations.of(context);
    final otpController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(localizations?.enter_verification_code ??
              'Enter Verification Code'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      labelText: localizations?.verification_code ??
                          'Verification Code',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin, color: _primaryColor),
                      counterText: '',
                      hintText: '000000',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return localizations?.enter_code ??
                            'Enter verification code';
                      if (value.length != 6)
                        return localizations?.code_must_be_6_digits ??
                            'Code must be 6 digits';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: localizations?.new_password ?? 'New Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock, color: _primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscureNew
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () =>
                            setDialogState(() => obscureNew = !obscureNew),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return localizations?.enter_new_password ??
                            'Enter new password';
                      if (value.length < 8)
                        return localizations?.minimum_8_characters ??
                            'Minimum 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText:
                          localizations?.confirm_password ?? 'Confirm Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_clock, color: _primaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: _primaryColor, width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () => setDialogState(
                            () => obscureConfirm = !obscureConfirm),
                      ),
                    ),
                    validator: (value) {
                      if (value != newPasswordController.text)
                        return localizations?.passwords_do_not_match ??
                            'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showChangePasswordDialog(); // Restart the flow
                    },
                    icon: Icon(Icons.refresh, size: 18, color: _primaryColor),
                    label: Text(
                      localizations?.resend_code ?? 'Resend Code',
                      style: TextStyle(color: _primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations?.cancel ?? 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  navigator.pop();

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                        child: CircularProgressIndicator(color: _primaryColor)),
                  );

                  final authService = ref.read(authenticationServiceProvider);
                  final result = await authService.updatePassword(
                    verificationCode: otpController.text,
                    newPassword: newPasswordController.text,
                    confirmPassword: confirmPasswordController.text,
                  );

                  if (mounted) navigator.pop();

                  if (result['success']) {
                    if (mounted) {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle,
                                  color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(result['message'])),
                            ],
                          ),
                          backgroundColor: isDark ? Theme.of(context).colorScheme.primary : const Color(0xFF43A047),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );

                      await Future.delayed(const Duration(seconds: 2));

                      if (mounted) {
                        await _handlePasswordChangeSuccess();
                      }
                    }
                  } else {
                    if (mounted) {
                      scaffoldMessenger.showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.white),
                              const SizedBox(width: 12),
                              Expanded(child: Text(result['error'])),
                            ],
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                      _showPasswordUpdateDialog();
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(localizations?.change_password ?? 'Change Password'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePasswordChangeSuccess() async {
    final authService = ref.read(authenticationServiceProvider);
    await authService.logout();

    if (!mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  void _showLogoutAll() {
    final localizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            localizations?.logout_all_devices_confirm ?? 'Logout All Devices?'),
        content: Text(localizations?.logout_all_devices_message ??
            'This will end all active sessions on all devices.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authService = ref.read(authenticationServiceProvider);
              await authService.logout();

              if (!mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(localizations?.logout_all ?? 'Logout All'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccount() {
    final localizations = AppLocalizations.of(context);
    final pwdCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 8),
            Text(localizations?.delete_account_confirm ?? 'Delete Account?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations?.delete_account_warning ??
                  'This action is PERMANENT and cannot be undone. All your data will be permanently deleted.',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              localizations?.what_will_be_deleted ?? 'What will be deleted:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(localizations?.profile_and_account_info ??
                '• Your profile and account information'),
            Text(localizations?.all_listings_and_posts ??
                '• All your listings and posts'),
            Text(localizations?.messages_and_conversations ??
                '• Your messages and conversations'),
            Text(localizations?.saved_items_and_preferences ??
                '• Saved items and preferences'),
            const SizedBox(height: 16),
            TextField(
              controller: pwdCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: localizations?.enter_password_to_continue ??
                    'Enter your password to continue',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (pwdCtrl.text.isEmpty) {
                _showError(localizations?.please_enter_password ??
                    'Please enter your password');
                return;
              }
              Navigator.pop(context);
              await _requestAccountDeletion(pwdCtrl.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(localizations?.continue_val ?? 'Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestAccountDeletion(String password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: _primaryColor)),
    );

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.requestAccountDeletion(password);

    if (mounted) Navigator.pop(context);

    if (result['success']) {
      if (mounted) {
        _showSuccess(result['message']);
        _showDeleteConfirmationDialog();
      }
    } else {
      if (mounted) {
        _showError(result['error']);
      }
    }
  }

  void _showDeleteConfirmationDialog() {
    final localizations = AppLocalizations.of(context);
    final otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.sms, color: _primaryColor),
            const SizedBox(width: 8),
            Text(localizations?.enter_confirmation_code ??
                'Enter Confirmation Code'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations?.deletion_confirmation_message ??
                  'We sent a confirmation code to your phone. Enter it below to permanently delete your account.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText:
                    localizations?.confirmation_code ?? 'Confirmation Code',
                border: const OutlineInputBorder(),
                prefixIcon: Icon(Icons.pin, color: _primaryColor),
                counterText: '',
                hintText: '000000',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _cancelAccountDeletion();
            },
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (otpController.text.length != 6) {
                _showError(localizations?.please_enter_6_digit_code ??
                    'Please enter the 6-digit code');
                return;
              }
              await _confirmAccountDeletion(otpController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: Text(
              localizations?.delete_account ?? 'Delete Account',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAccountDeletion(String otp) async {
    final localizations = AppLocalizations.of(context);
    Navigator.pop(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: _primaryColor)),
    );

    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.confirmAccountDeletion(otp);

    if (mounted) Navigator.pop(context);

    if (result['success']) {
      if (mounted) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.account_deleted ??
                'Your account has been deleted'),
            backgroundColor: isDark ? Theme.of(context).colorScheme.primary : const Color(0xFF43A047),
          ),
        );

        await authService.logout();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        _showError(result['error']);
        _showDeleteConfirmationDialog();
      }
    }
  }

  Future<void> _cancelAccountDeletion() async {
    final localizations = AppLocalizations.of(context);
    final authService = ref.read(authenticationServiceProvider);
    final result = await authService.cancelAccountDeletion();

    if (mounted) {
      if (result['success']) {
        _showSuccess(localizations?.deletion_cancelled ?? 'Deletion cancelled');
      }
    }
  }

  void _showSuccess(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isDark ? Theme.of(context).colorScheme.primary : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
