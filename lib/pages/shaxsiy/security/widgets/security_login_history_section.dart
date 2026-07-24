import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/chat/widgets/chat_helpers.dart';
import 'package:app/pages/shaxsiy/security/widgets/security_option_card.dart';
import 'package:app/service/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Real "active sessions" replacement: shows the user's actual login
/// history from `GET /accounts/login-history/` (device, method, relative
/// time, "new device" badge) instead of a fake toggle-driven score.
class SecurityLoginHistorySection extends ConsumerStatefulWidget {
  const SecurityLoginHistorySection({super.key});

  @override
  ConsumerState<SecurityLoginHistorySection> createState() =>
      _SecurityLoginHistorySectionState();
}

class _SecurityLoginHistorySectionState
    extends ConsumerState<SecurityLoginHistorySection> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() {
    return ref.read(authenticationServiceProvider).getLoginHistory();
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SecuritySection(
      title: localizations?.securityLoginHistory ?? 'Login History',
      icon: Icons.history,
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              );
            }

            final result = snapshot.data;
            final success = result != null && result['success'] == true;
            if (!success) {
              final message = (result != null ? result['error'] as String? : null) ??
                  snapshot.error?.toString();
              return _LoginHistoryError(
                message: message,
                onRetry: _retry,
                localizations: localizations,
              );
            }

            final entries = ((result['results'] as List?) ?? const [])
                .cast<Map<String, dynamic>>();

            if (entries.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  localizations?.securityNoHistory ?? 'No login history yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              );
            }

            return Column(
              children: [
                for (final entry in entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _LoginHistoryTile(
                      entry: entry,
                      localizations: localizations,
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LoginHistoryTile extends StatelessWidget {
  const _LoginHistoryTile({required this.entry, required this.localizations});

  final Map<String, dynamic> entry;
  final AppLocalizations? localizations;

  IconData get _deviceIcon {
    switch (entry['device'] as String? ?? 'unknown') {
      case 'mobile':
        return Icons.phone_android;
      case 'ios':
        return Icons.phone_iphone;
      case 'windows':
      case 'mac':
      case 'linux':
        return Icons.laptop_mac;
      default:
        return Icons.devices_other;
    }
  }

  String get _methodLabel {
    switch (entry['login_method'] as String? ?? 'password') {
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      case 'token_refresh':
        return 'Token refresh';
      default:
        return 'Password';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final success = entry['success'] as bool? ?? true;
    final isNewDevice = entry['is_new_device'] as bool? ?? false;

    DateTime? createdAt;
    final createdAtRaw = entry['created_at'] as String?;
    if (createdAtRaw != null) {
      createdAt = DateTime.tryParse(createdAtRaw)?.toLocal();
    }
    final timeLabel = createdAt != null
        ? ChatHelpers.relativeTimeShort(createdAt, localizations)
        : '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            _deviceIcon,
            color: success
                ? theme.primaryColor
                : theme.colorScheme.error,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _methodLabel,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isNewDevice) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          localizations?.securityNewDevice ?? 'New device',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  timeLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!success)
            Icon(Icons.error_outline, color: theme.colorScheme.error, size: 18),
        ],
      ),
    );
  }
}

class _LoginHistoryError extends StatelessWidget {
  const _LoginHistoryError({
    required this.message,
    required this.onRetry,
    required this.localizations,
  });

  final String? message;
  final VoidCallback onRetry;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message?.isNotEmpty == true
                  ? message!
                  : (localizations?.something_went_wrong ??
                      'Something went wrong'),
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(localizations?.retry ?? 'Retry'),
          ),
        ],
      ),
    );
  }
}
