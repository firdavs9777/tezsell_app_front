import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showDeleteAccountFlow(BuildContext context, WidgetRef ref) {
  _showPasswordConfirmDialog(context, ref);
}

void _showPasswordConfirmDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final pwdCtrl = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning, color: Theme.of(dialogContext).colorScheme.error),
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
            style: Theme.of(dialogContext)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Text(
            localizations?.what_will_be_deleted ?? 'What will be deleted:',
            style: Theme.of(dialogContext)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
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
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (pwdCtrl.text.isEmpty) {
              SecurityToast.showError(
                dialogContext,
                localizations?.please_enter_password ??
                    'Please enter your password',
              );
              return;
            }
            Navigator.pop(dialogContext);
            await _requestAccountDeletion(context, ref, pwdCtrl.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(localizations?.continue_val ?? 'Continue'),
        ),
      ],
    ),
  );
}

Future<void> _requestAccountDeletion(
  BuildContext context,
  WidgetRef ref,
  String password,
) async {
  final primary = Theme.of(context).primaryColor;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        Center(child: CircularProgressIndicator(color: primary)),
  );

  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.requestAccountDeletion(password);

  if (!context.mounted) return;
  Navigator.pop(context);

  if (result['success']) {
    SecurityToast.showSuccess(context, result['message']);
    _showOtpConfirmDialog(context, ref);
  } else {
    SecurityToast.showError(context, result['error']);
  }
}

void _showOtpConfirmDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);
  final primary = Theme.of(context).primaryColor;
  final otpController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.sms, color: primary),
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
              prefixIcon: Icon(Icons.pin, color: primary),
              counterText: '',
              hintText: '000000',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await _cancelAccountDeletion(context, ref);
          },
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (otpController.text.length != 6) {
              SecurityToast.showError(
                dialogContext,
                localizations?.please_enter_6_digit_code ??
                    'Please enter the 6-digit code',
              );
              return;
            }
            Navigator.pop(dialogContext);
            await _confirmAccountDeletion(context, ref, otpController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(dialogContext).colorScheme.error,
          ),
          child: Text(
            localizations?.delete_account ?? 'Delete Account',
            style: Theme.of(dialogContext).textTheme.titleMedium,
          ),
        ),
      ],
    ),
  );
}

Future<void> _confirmAccountDeletion(
  BuildContext context,
  WidgetRef ref,
  String otp,
) async {
  final localizations = AppLocalizations.of(context);
  final primary = Theme.of(context).primaryColor;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        Center(child: CircularProgressIndicator(color: primary)),
  );

  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.confirmAccountDeletion(otp);

  if (!context.mounted) return;
  Navigator.pop(context);

  if (result['success']) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations?.account_deleted ?? 'Your account has been deleted',
        ),
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.primary
            : const Color(0xFF43A047),
      ),
    );

    await authService.logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  } else {
    SecurityToast.showError(context, result['error']);
    _showOtpConfirmDialog(context, ref);
  }
}

Future<void> _cancelAccountDeletion(
  BuildContext context,
  WidgetRef ref,
) async {
  final localizations = AppLocalizations.of(context);
  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.cancelAccountDeletion();

  if (!context.mounted) return;
  if (result['success']) {
    SecurityToast.showSuccess(
      context,
      localizations?.deletion_cancelled ?? 'Deletion cancelled',
    );
  }
}
