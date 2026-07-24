import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/authentication/login.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showLogoutAllDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(localizations?.securityLogoutAll ?? 'Logout All Devices?'),
      content: Text(localizations?.securityLogoutAllConfirm ??
          "This will sign you out on every device where you're currently "
              'logged in, including this one.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            await _performLogoutAll(context, ref);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          child: Text(localizations?.logout_all ?? 'Logout All'),
        ),
      ],
    ),
  );
}

Future<void> _performLogoutAll(BuildContext context, WidgetRef ref) async {
  final localizations = AppLocalizations.of(context);
  final primary = Theme.of(context).primaryColor;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) =>
        Center(child: CircularProgressIndicator(color: primary)),
  );

  final authService = ref.read(authenticationServiceProvider);
  final result = await authService.logoutAll();

  if (!context.mounted) return;
  Navigator.pop(context); // dismiss the loading spinner

  if (result['success'] == true) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations?.securitySignedOutEverywhere ??
              "You've been signed out of all devices",
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  } else {
    // Local session state is cleared by logoutAll() regardless of the
    // backend outcome, so still route to login below even though the
    // network call failed -- there is no valid local session to stay on.
    SecurityToast.showError(
      context,
      result['error'] as String? ??
          (localizations?.something_went_wrong ?? 'Something went wrong'),
    );
  }

  if (!context.mounted) return;
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => const Login()),
    (route) => false,
  );
}
