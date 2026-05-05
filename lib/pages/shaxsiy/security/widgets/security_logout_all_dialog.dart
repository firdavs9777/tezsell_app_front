import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/authentication/login.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void showLogoutAllDialog(BuildContext context, WidgetRef ref) {
  final localizations = AppLocalizations.of(context);

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(localizations?.logout_all_devices_confirm ??
          'Logout All Devices?'),
      content: Text(localizations?.logout_all_devices_message ??
          'This will end all active sessions on all devices.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(localizations?.cancel ?? 'Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final authService = ref.read(authenticationServiceProvider);
            await authService.logout();

            if (!context.mounted) return;
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
