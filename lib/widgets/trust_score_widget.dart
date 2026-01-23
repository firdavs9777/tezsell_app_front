import 'package:flutter/material.dart';
import 'package:app/providers/provider_models/trust_score_model.dart';

/// Trust Score Widget - Displays manner temperature like Karrot/당근마켓
class TrustScoreWidget extends StatelessWidget {
  final double temperature;
  final String? level;
  final String? emoji;
  final bool showLabel;
  final double size;

  const TrustScoreWidget({
    super.key,
    required this.temperature,
    this.level,
    this.emoji,
    this.showLabel = true,
    this.size = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final tempLevel = level ?? TrustScore.getLevel(temperature);
    final tempEmoji = emoji ?? TrustScore.getEmoji(temperature);
    final tempColor = Color(TrustScore.getTemperatureColor(tempLevel));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Temperature indicator
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8 * size,
            vertical: 4 * size,
          ),
          decoration: BoxDecoration(
            color: tempColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12 * size),
            border: Border.all(
              color: tempColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${temperature.toStringAsFixed(1)}°C',
                style: TextStyle(
                  fontSize: 14 * size,
                  fontWeight: FontWeight.w600,
                  color: tempColor,
                ),
              ),
              SizedBox(width: 4 * size),
              Text(
                tempEmoji,
                style: TextStyle(fontSize: 14 * size),
              ),
            ],
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: 8 * size),
          Text(
            _getLevelLabel(tempLevel),
            style: TextStyle(
              fontSize: 12 * size,
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }

  String _getLevelLabel(String level) {
    switch (level) {
      case 'cold':
        return 'New';
      case 'cool':
        return 'Building Trust';
      case 'normal':
        return 'Good';
      case 'warm':
        return 'Trusted';
      case 'hot':
        return 'Very Trusted';
      case 'fire':
        return 'Top Rated';
      default:
        return '';
    }
  }
}

/// Compact trust badge for list items
class TrustBadgeCompact extends StatelessWidget {
  final double temperature;
  final double size;

  const TrustBadgeCompact({
    super.key,
    required this.temperature,
    this.size = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final level = TrustScore.getLevel(temperature);
    final emoji = TrustScore.getEmoji(temperature);
    final color = Color(TrustScore.getTemperatureColor(level));

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 6 * size,
        vertical: 2 * size,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8 * size),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${temperature.toStringAsFixed(1)}°',
            style: TextStyle(
              fontSize: 11 * size,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            emoji,
            style: TextStyle(fontSize: 10 * size),
          ),
        ],
      ),
    );
  }
}

/// Large trust score display for profile pages
class TrustScoreCard extends StatelessWidget {
  final TrustScore trustScore;

  const TrustScoreCard({
    super.key,
    required this.trustScore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tempColor =
        Color(TrustScore.getTemperatureColor(trustScore.temperatureLevel));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tempColor.withOpacity(0.1),
            tempColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: tempColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Main temperature display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildThermometer(tempColor),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${trustScore.temperature.toStringAsFixed(1)}°C',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: tempColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        trustScore.temperatureEmoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                    ],
                  ),
                  Text(
                    'Manner Temperature',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                '${trustScore.completedTransactions}',
                'Completed',
                Icons.check_circle_outline,
              ),
              _buildStatItem(
                context,
                trustScore.averageRating.toStringAsFixed(1),
                'Rating',
                Icons.star_outline,
              ),
              _buildStatItem(
                context,
                '${trustScore.responseRate.toStringAsFixed(0)}%',
                'Response',
                Icons.speed_outlined,
              ),
            ],
          ),
          // Badges
          if (trustScore.badges.isNotEmpty) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: trustScore.badges
                  .map((badge) => _buildBadge(context, badge))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThermometer(Color color) {
    // Calculate fill percentage (0-100 maps to 0-99.9 temperature)
    final fillPercent = (trustScore.temperature / 100).clamp(0.0, 1.0);

    return Container(
      width: 24,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Fill
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: 24,
            height: 80 * fillPercent,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.7),
                  color,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          // Bulb at bottom
          Positioned(
            bottom: 0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(BuildContext context, UserBadge badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Color(badge.colorValue).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(badge.colorValue).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(badge.icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            badge.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(badge.colorValue),
            ),
          ),
        ],
      ),
    );
  }
}

/// Badge display widget
class UserBadgeWidget extends StatelessWidget {
  final UserBadge badge;
  final double size;

  const UserBadgeWidget({
    super.key,
    required this.badge,
    this.size = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: badge.description ?? badge.name,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 8 * size,
          vertical: 4 * size,
        ),
        decoration: BoxDecoration(
          color: Color(badge.colorValue).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12 * size),
          border: Border.all(
            color: Color(badge.colorValue).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge.icon, style: TextStyle(fontSize: 12 * size)),
            SizedBox(width: 4 * size),
            Text(
              badge.name,
              style: TextStyle(
                fontSize: 11 * size,
                fontWeight: FontWeight.w500,
                color: Color(badge.colorValue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row of badges
class UserBadgesRow extends StatelessWidget {
  final List<UserBadge> badges;
  final int maxVisible;

  const UserBadgesRow({
    super.key,
    required this.badges,
    this.maxVisible = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox.shrink();

    final visibleBadges = badges.take(maxVisible).toList();
    final remaining = badges.length - maxVisible;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...visibleBadges.map(
          (badge) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: UserBadgeWidget(badge: badge, size: 0.9),
          ),
        ),
        if (remaining > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+$remaining',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
