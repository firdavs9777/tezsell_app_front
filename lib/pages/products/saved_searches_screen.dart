import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/saved_search_model.dart';
import 'package:app/providers/provider_models/search_alert_model.dart';
import 'package:app/providers/provider_root/saved_searches_provider.dart';
import 'package:app/providers/provider_root/search_alerts_provider.dart';

/// Manage screen for saved searches and keyword alerts.
///
/// Both are backed by real endpoints (`/api/favorites/saved-searches/` and
/// `/api/notifications/alerts/`) — alerts are matched and delivered
/// server-side and surface through the existing notification bell, so this
/// screen only needs to read/write state, never poll locally.
class SavedSearchesScreen extends ConsumerStatefulWidget {
  const SavedSearchesScreen({super.key});

  @override
  ConsumerState<SavedSearchesScreen> createState() =>
      _SavedSearchesScreenState();
}

class _SavedSearchesScreenState extends ConsumerState<SavedSearchesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n?.savedSearchesScreenTitle ?? 'Saved Searches'),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n?.savedSearchesTabLabel ?? 'Searches'),
            Tab(text: l10n?.searchAlertsTabLabel ?? 'Alerts'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _SavedSearchesTab(),
          _SearchAlertsTab(),
        ],
      ),
    );
  }
}

class _SavedSearchesTab extends ConsumerWidget {
  const _SavedSearchesTab();

  Future<void> _openSearch(
    BuildContext context,
    WidgetRef ref,
    SavedSearch search,
  ) async {
    // Fire-and-forget: bumps use_count server-side; no need to block
    // navigation on it.
    ref.read(savedSearchesProvider.notifier).useSavedSearch(search.id);

    final queryParams = <String, String>{'q': search.query};
    if ((search.region ?? '').isNotEmpty) {
      queryParams['region'] = search.region!;
    }
    if ((search.district ?? '').isNotEmpty) {
      queryParams['district'] = search.district!;
    }
    final uri = Uri(path: '/product/search', queryParameters: queryParams);
    context.push(uri.toString());
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SavedSearch search,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          l10n?.savedSearchDeleteConfirmTitle ?? 'Delete saved search?',
        ),
        content: Text(
          l10n?.savedSearchDeleteConfirmMessage ??
              'This will remove the saved search. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success =
        await ref.read(savedSearchesProvider.notifier).deleteSavedSearch(
              search.id,
            );

    if (!context.mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (l10n?.savedSearchDeletedSuccess ?? 'Saved search deleted')
              : (l10n?.savedSearchDeleteError ??
                  'Failed to delete saved search'),
        ),
        backgroundColor: success ? colorScheme.primary : colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(savedSearchesProvider);
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(savedSearchesProvider.notifier).fetchSavedSearches(),
      child: _buildBody(
        context: context,
        ref: ref,
        colorScheme: colorScheme,
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: state.searches.isEmpty,
        emptyTitle: l10n?.savedSearchesEmptyTitle ?? 'No saved searches yet',
        emptySubtitle: l10n?.savedSearchesEmptySubtitle ??
            'Save a search to quickly find it again later',
        loadErrorMessage:
            l10n?.savedSearchesLoadError ?? 'Failed to load saved searches',
        emptyIcon: Icons.bookmark_border,
        listBuilder: () => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.searches.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: colorScheme.outlineVariant),
          itemBuilder: (context, index) {
            final search = state.searches[index];
            final locationParts = [
              if ((search.district ?? '').isNotEmpty) search.district!,
              if ((search.region ?? '').isNotEmpty) search.region!,
            ];
            final subtitleParts = <String>[
              if (locationParts.isNotEmpty) locationParts.join(', '),
              l10n?.savedSearchUseCount(search.useCount) ??
                  'Used ${search.useCount} times',
            ];

            return ListTile(
              leading: Icon(Icons.search, color: colorScheme.primary),
              title: Text(
                search.displayName,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(subtitleParts.join(' • ')),
              onTap: () => _openSearch(context, ref, search),
              trailing: IconButton(
                icon: Icon(Icons.delete_outline, color: colorScheme.error),
                tooltip: l10n?.savedSearchDeleteTooltip ?? 'Delete saved search',
                onPressed: () => _delete(context, ref, search),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SearchAlertsTab extends ConsumerWidget {
  const _SearchAlertsTab();

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    SearchAlert alert,
  ) async {
    final l10n = AppLocalizations.of(context);
    final success =
        await ref.read(searchAlertsProvider.notifier).toggleAlert(alert.id);

    if (!success && context.mounted) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n?.searchAlertToggleError ?? 'Failed to update alert',
          ),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    SearchAlert alert,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.searchAlertDeleteConfirmTitle ?? 'Delete alert?'),
        content: Text(
          l10n?.searchAlertDeleteConfirmMessage ??
              'You will no longer be notified about new matches for this keyword.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final success =
        await ref.read(searchAlertsProvider.notifier).deleteAlert(alert.id);

    if (!context.mounted) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? (l10n?.searchAlertDeletedSuccess ?? 'Alert deleted')
              : (l10n?.searchAlertDeleteError ?? 'Failed to delete alert'),
        ),
        backgroundColor: success ? colorScheme.primary : colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchAlertsProvider);
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () => ref.read(searchAlertsProvider.notifier).fetchAlerts(),
      child: _buildBody(
        context: context,
        ref: ref,
        colorScheme: colorScheme,
        isLoading: state.isLoading,
        error: state.error,
        isEmpty: state.alerts.isEmpty,
        emptyTitle: l10n?.searchAlertsEmptyTitle ?? 'No alerts yet',
        emptySubtitle: l10n?.searchAlertsEmptySubtitle ??
            'Save a search and turn on notifications to get alerted about new matches',
        loadErrorMessage:
            l10n?.searchAlertsLoadError ?? 'Failed to load alerts',
        emptyIcon: Icons.notifications_none,
        listBuilder: () => ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: state.alerts.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: colorScheme.outlineVariant),
          itemBuilder: (context, index) {
            final alert = state.alerts[index];
            final locationParts = [
              if ((alert.district ?? '').isNotEmpty) alert.district!,
              if ((alert.region ?? '').isNotEmpty) alert.region!,
            ];

            return ListTile(
              leading: Icon(
                Icons.notifications_active_outlined,
                color: alert.isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              title: Text(
                alert.keyword,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: locationParts.isNotEmpty
                  ? Text(locationParts.join(', '))
                  : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch.adaptive(
                    value: alert.isActive,
                    onChanged: (_) => _toggle(context, ref, alert),
                  ),
                  IconButton(
                    icon:
                        Icon(Icons.delete_outline, color: colorScheme.error),
                    tooltip: l10n?.searchAlertDeleteTooltip ?? 'Delete alert',
                    onPressed: () => _delete(context, ref, alert),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildBody({
  required BuildContext context,
  required WidgetRef ref,
  required ColorScheme colorScheme,
  required bool isLoading,
  required String? error,
  required bool isEmpty,
  required String emptyTitle,
  required String emptySubtitle,
  required String loadErrorMessage,
  required IconData emptyIcon,
  required Widget Function() listBuilder,
}) {
  if (isLoading && isEmpty) {
    return Center(
      child: CircularProgressIndicator(color: colorScheme.primary),
    );
  }

  if (error != null && isEmpty) {
    return ListView(
      // Wrapped in a scrollable so RefreshIndicator still works from the
      // error state.
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 64, color: colorScheme.error),
              const SizedBox(height: 16),
              Text(
                loadErrorMessage,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  if (isEmpty) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
          child: Column(
            children: [
              Icon(emptyIcon, size: 72, color: colorScheme.outlineVariant),
              const SizedBox(height: 16),
              Text(
                emptyTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                emptySubtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  return listBuilder();
}
