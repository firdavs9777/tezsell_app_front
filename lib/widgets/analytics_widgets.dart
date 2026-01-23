import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/providers/provider_models/analytics_model.dart';

/// Stat card for analytics dashboard
class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (iconColor ?? colorScheme.primary).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: iconColor ?? colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Analytics dashboard grid
class AnalyticsDashboard extends StatelessWidget {
  final SellerAnalytics analytics;
  final VoidCallback? onViewProducts;
  final VoidCallback? onViewServices;
  final VoidCallback? onViewOffers;
  final VoidCallback? onViewTransactions;

  const AnalyticsDashboard({
    super.key,
    required this.analytics,
    this.onViewProducts,
    this.onViewServices,
    this.onViewOffers,
    this.onViewTransactions,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overview stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Overview',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.4,
          children: [
            AnalyticsStatCard(
              title: 'Total Views',
              value: formatter.format(analytics.totalViews),
              icon: Icons.visibility_rounded,
              iconColor: Colors.blue,
            ),
            AnalyticsStatCard(
              title: 'Total Likes',
              value: formatter.format(analytics.totalLikes),
              icon: Icons.favorite_rounded,
              iconColor: Colors.red,
            ),
            AnalyticsStatCard(
              title: 'Favorites',
              value: formatter.format(analytics.favorites.total),
              icon: Icons.star_rounded,
              iconColor: Colors.amber,
            ),
            AnalyticsStatCard(
              title: 'Offers',
              value: formatter.format(analytics.offers.totalReceived),
              icon: Icons.local_offer_rounded,
              iconColor: Colors.green,
              subtitle: '${analytics.offers.pending} pending',
              onTap: onViewOffers,
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Products stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Products',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _buildProductsSection(context, formatter),
        const SizedBox(height: 16),
        // Services stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Services',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        _buildServicesSection(context, formatter),
        const SizedBox(height: 16),
        // Trust Score
        _buildTrustScoreSection(context),
      ],
    );
  }

  Widget _buildProductsSection(BuildContext context, NumberFormat formatter) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onViewProducts,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.inventory_2_rounded,
                  color: Colors.orange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${analytics.products.total} Products',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${analytics.products.active} active • ${analytics.products.sold} sold',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(formatter.format(analytics.products.totalViews)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(formatter.format(analytics.products.totalLikes)),
                    ],
                  ),
                ],
              ),
              if (onViewProducts != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServicesSection(BuildContext context, NumberFormat formatter) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: onViewServices,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.design_services_rounded,
                  color: Colors.purple,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${analytics.services.total} Services',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Active listings',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.visibility, size: 14, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(formatter.format(analytics.services.totalViews)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.favorite, size: 14, color: Colors.red),
                      const SizedBox(width: 4),
                      Text(formatter.format(analytics.services.totalLikes)),
                    ],
                  ),
                ],
              ),
              if (onViewServices != null) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrustScoreSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trustScore = analytics.trustScore;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Trust Score',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getTrustColor(trustScore.level).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getTrustEmoji(trustScore.temperature),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${trustScore.temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getTrustColor(trustScore.level),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTrustStat(
                    context,
                    Icons.star_rounded,
                    '${trustScore.averageRating.toStringAsFixed(1)}',
                    'Rating',
                    Colors.amber,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTrustStat(
                    context,
                    Icons.rate_review_rounded,
                    '${trustScore.reviewsReceived}',
                    'Reviews',
                    colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustStat(
    BuildContext context,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getTrustColor(String level) {
    switch (level) {
      case 'cold':
        return Colors.blue;
      case 'cool':
        return Colors.lightBlue;
      case 'normal':
        return Colors.amber;
      case 'warm':
        return Colors.orange;
      case 'hot':
        return Colors.deepOrange;
      case 'fire':
        return Colors.red;
      default:
        return Colors.amber;
    }
  }

  String _getTrustEmoji(double temp) {
    if (temp < 20) return '🥶';
    if (temp < 30) return '😐';
    if (temp < 36.5) return '🙂';
    if (temp < 45) return '😊';
    if (temp < 60) return '😄';
    return '🔥';
  }
}

/// Compact analytics summary for listings
class ListingAnalyticsSummary extends StatelessWidget {
  final int views;
  final int likes;
  final int favorites;

  const ListingAnalyticsSummary({
    super.key,
    required this.views,
    required this.likes,
    required this.favorites,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact();

    return Row(
      children: [
        _buildStat(Icons.visibility, formatter.format(views), Colors.blue),
        const SizedBox(width: 16),
        _buildStat(Icons.favorite, formatter.format(likes), Colors.red),
        const SizedBox(width: 16),
        _buildStat(Icons.star, formatter.format(favorites), Colors.amber),
      ],
    );
  }

  Widget _buildStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
