import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showChangePasswordFlow(BuildContext context, WidgetRef ref) {
  _showCurrentPasswordDialog(context, ref);
}

void _showCurrentPasswordDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final primary = Theme.of(context).primaryColor;
  final currentPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.security, color: primary),
          const SizedBox(width: 8),
          Text(localizations?.change_password ?? 'Change Password'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
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
              prefixIcon: Icon(Icons.lock, color: primary),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final currentPassword = currentPasswordController.text.trim();
            if (currentPassword.isEmpty) {
              SecurityToast.showError(
                  dialogContext, 'Please enter your current password');
              return;
            }
            Navigator.pop(dialogContext);
            await _requestPasswordUpdate(context, ref, currentPassword);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Continue'),
        ),
      ],
    ),
  );
}

Future<void> _requestPasswordUpdate(
  BuildContext context,
  WidgetRef ref,
  String currentPassword,
) async {
  final primary = Theme.of(context).primaryColor;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        Center(child: CircularProgressIndicator(color: primary)),
  );

  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.requestPasswordUpdate(
    currentPassword: currentPassword,
  );

  if (!context.mounted) return;
  Navigator.pop(context);

  if (result['success']) {
    SecurityToast.showSuccess(context, result['message']);
    _showVerificationDialog(context, ref);
  } else {
    SecurityToast.showError(context, result['error']);
  }
}

void _showVerificationDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final primary = Theme.of(context).primaryColor;
  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscureNew = true;
  bool obscureConfirm = true;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setDialogState) => AlertDialog(
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
                    prefixIcon: Icon(Icons.pin, color: primary),
                    counterText: '',
                    hintText: '000000',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localizations?.enter_code ??
                          'Enter verification code';
                    }
                    if (value.length != 6) {
                      return localizations?.code_must_be_6_digits ??
                          'Code must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: newPasswordController,
                  obscureText: obscureNew,
                  decoration: InputDecoration(
                    labelText:
                        localizations?.new_password ?? 'New Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: primary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 2),
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
                    if (value == null || value.isEmpty) {
                      return localizations?.enter_new_password ??
                          'Enter new password';
                    }
                    if (value.length < 8) {
                      return localizations?.minimum_8_characters ??
                          'Minimum 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: obscureConfirm,
                  decoration: InputDecoration(
                    labelText: localizations?.confirm_password ??
                        'Confirm Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_clock, color: primary),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primary, width: 2),
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
                    if (value != newPasswordController.text) {
                      return localizations?.passwords_do_not_match ??
                          'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                    _showCurrentPasswordDialog(context, ref);
                  },
                  icon: Icon(Icons.refresh, size: 18, color: primary),
                  label: Text(
                    localizations?.resend_code ?? 'Resend Code',
                    style: TextStyle(color: primary),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(localizations?.cancel ?? 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              Navigator.pop(dialogContext);
              await _submitPasswordChange(
                context,
                ref,
                otp: otpController.text,
                newPassword: newPasswordController.text,
                confirmPassword: confirmPasswordController.text,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
            child:
                Text(localizations?.change_password ?? 'Change Password'),
          ),
        ],
      ),
    ),
  );
}

Future<void> _submitPasswordChange(
  BuildContext context,
  WidgetRef ref, {
  required String otp,
  required String newPassword,
  required String confirmPassword,
}) async {
  final primary = Theme.of(context).primaryColor;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        Center(child: CircularProgressIndicator(color: primary)),
  );

  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.updatePassword(
    verificationCode: otp,
    newPassword: newPassword,
    confirmPassword: confirmPassword,
  );

  if (!context.mounted) return;
  Navigator.pop(context);

  if (result['success']) {
    SecurityToast.showSuccess(context, result['message']);
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;
    await authService.logout();

    if (!context.mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  } else {
    SecurityToast.showError(context, result['error']);
    _showVerificationDialog(context, ref);
  }
}
