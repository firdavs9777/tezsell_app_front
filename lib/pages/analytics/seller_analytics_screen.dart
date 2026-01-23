import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/providers/provider_models/analytics_model.dart';
import 'package:app/providers/provider_root/analytics_provider.dart';
import 'package:app/widgets/analytics_widgets.dart';
import 'package:app/widgets/skeleton_loader.dart' show ShimmerEffect, SkeletonBox;

class SellerAnalyticsScreen extends ConsumerStatefulWidget {
  const SellerAnalyticsScreen({super.key});

  @override
  ConsumerState<SellerAnalyticsScreen> createState() => _SellerAnalyticsScreenState();
}

class _SellerAnalyticsScreenState extends ConsumerState<SellerAnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    await ref.read(analyticsProvider.notifier).loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final analyticsState = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            onPressed: _loadAnalytics,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: localizations?.refresh ?? 'Refresh',
          ),
        ],
      ),
      body: _buildBody(analyticsState, colorScheme, localizations),
    );
  }

  Widget _buildBody(
    AnalyticsState state,
    ColorScheme colorScheme,
    AppLocalizations? localizations,
  ) {
    if (state.isLoading && state.analytics == null) {
      return const _AnalyticsSkeleton();
    }

    if (state.error != null && state.analytics == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                state.error!,
                style: TextStyle(color: colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _loadAnalytics,
                icon: const Icon(Icons.refresh),
                label: Text(localizations?.retry ?? 'Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.analytics == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics_outlined,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No analytics data available',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start listing products and services to see your analytics',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnalytics,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            // Quick Stats Header
            _buildQuickStatsHeader(state.analytics!, colorScheme),
            // Full Analytics Dashboard
            AnalyticsDashboard(
              analytics: state.analytics!,
              onViewProducts: () => context.push('/profile/my-products'),
              onViewServices: () => context.push('/profile/my-services'),
              onViewOffers: () => context.push('/offers'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStatsHeader(
    SellerAnalytics analytics,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer,
            colorScheme.primaryContainer.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.insights_rounded,
                color: colorScheme.onPrimaryContainer,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Performance Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildMiniStat(
                  icon: Icons.visibility_rounded,
                  value: _formatNumber(analytics.totalViews),
                  label: 'Total Views',
                  colorScheme: colorScheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildMiniStat(
                  icon: Icons.favorite_rounded,
                  value: _formatNumber(analytics.totalLikes),
                  label: 'Total Likes',
                  colorScheme: colorScheme,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
              ),
              Expanded(
                child: _buildMiniStat(
                  icon: Icons.inventory_2_rounded,
                  value: '${analytics.products.total + analytics.services.total}',
                  label: 'Listings',
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required String value,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Column(
      children: [
        Icon(icon, color: colorScheme.onPrimaryContainer, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _AnalyticsSkeleton extends StatelessWidget {
  const _AnalyticsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ShimmerEffect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header skeleton
            const SkeletonBox(height: 140, borderRadius: 20),
            const SizedBox(height: 24),
            // Stats grid skeleton
            const SkeletonBox(height: 24, width: 100),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: List.generate(
                4,
                (_) => const SkeletonBox(height: 100, borderRadius: 12),
              ),
            ),
            const SizedBox(height: 24),
            // Products section skeleton
            const SkeletonBox(height: 24, width: 80),
            const SizedBox(height: 12),
            const SkeletonBox(height: 100, borderRadius: 12),
            const SizedBox(height: 24),
            // Services section skeleton
            const SkeletonBox(height: 24, width: 80),
            const SizedBox(height: 12),
            const SkeletonBox(height: 100, borderRadius: 12),
          ],
        ),
      ),
    );
  }
}
