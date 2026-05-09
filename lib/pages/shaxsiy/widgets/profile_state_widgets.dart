import 'package:app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProfileErrorState extends StatelessWidget {
  const ProfileErrorState({
    super.key,
    required this.error,
    required this.onRetry,
    required this.onLogout,
    this.localizations,
  });

  final Object? error;
  final VoidCallback onRetry;
  final VoidCallback onLogout;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final errorMessage = error is Exception
        ? error.toString().replaceFirst('Exception: ', '')
        : error.toString();

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                localizations?.failed_to_refresh ?? 'Error loading profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(localizations?.retry ?? 'Retry'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: onLogout,
                icon: Icon(Icons.logout_rounded, color: colorScheme.error),
                label: Text(
                  localizations?.logout ?? 'Logout',
                  style: TextStyle(color: colorScheme.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEmptyState extends StatelessWidget {
  const ProfileEmptyState({
    super.key,
    required this.onRefresh,
    this.localizations,
  });

  final VoidCallback onRefresh;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No user data available.',
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(localizations?.refresh ?? 'Refresh'),
          ),
        ],
      ),
    );
  }
}
