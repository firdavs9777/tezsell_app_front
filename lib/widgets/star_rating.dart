import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Star Rating Input Widget
class StarRatingInput extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onChanged;
  final int maxRating;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool allowHalfRating;

  const StarRatingInput({
    super.key,
    required this.rating,
    required this.onChanged,
    this.maxRating = 5,
    this.size = 40,
    this.activeColor,
    this.inactiveColor,
    this.allowHalfRating = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final active = activeColor ?? const Color(0xFFFFB800);
    final inactive = inactiveColor ?? colorScheme.outline.withOpacity(0.3);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starValue = index + 1;
        final isActive = starValue <= rating;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onChanged(starValue);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(size * 0.1),
            child: AnimatedScale(
              scale: isActive ? 1.0 : 0.9,
              duration: const Duration(milliseconds: 150),
              child: Icon(
                isActive ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isActive ? active : inactive,
                size: size,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Star Rating Display (read-only)
class StarRatingDisplay extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? color;
  final bool showValue;

  const StarRatingDisplay({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
    this.color,
    this.showValue = true,
  });

  @override
  Widget build(BuildContext context) {
    final starColor = color ?? const Color(0xFFFFB800);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(maxRating, (index) {
          final starValue = index + 1;
          final isFull = starValue <= rating;
          final isHalf = !isFull && starValue - 0.5 <= rating;

          IconData icon;
          if (isFull) {
            icon = Icons.star_rounded;
          } else if (isHalf) {
            icon = Icons.star_half_rounded;
          } else {
            icon = Icons.star_outline_rounded;
          }

          return Icon(
            icon,
            color: isFull || isHalf
                ? starColor
                : colorScheme.outline.withOpacity(0.3),
            size: size,
          );
        }),
        if (showValue) ...[
          SizedBox(width: size * 0.3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.9,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }
}

/// Rating Summary with Distribution Bar Chart
class RatingSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final Map<int, int> distribution; // {5: 15, 4: 3, 3: 1, 2: 0, 1: 1}

  const RatingSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.distribution,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Average rating
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              StarRatingDisplay(
                rating: averageRating,
                size: 20,
                showValue: false,
              ),
              const SizedBox(height: 4),
              Text(
                '$totalReviews reviews',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        // Right: Distribution bars
        Expanded(
          flex: 3,
          child: Column(
            children: List.generate(5, (index) {
              final stars = 5 - index;
              final count = distribution[stars] ?? 0;
              final percentage =
                  totalReviews > 0 ? count / totalReviews : 0.0;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(
                      '$stars',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: const Color(0xFFFFB800),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: percentage,
                          backgroundColor: colorScheme.surfaceVariant,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFFFFB800),
                          ),
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 30,
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

/// Compact rating for list items
class RatingBadge extends StatelessWidget {
  final double rating;
  final int? reviewCount;

  const RatingBadge({
    super.key,
    required this.rating,
    this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB800).withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star_rounded,
            size: 14,
            color: Color(0xFFFFB800),
          ),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD49400),
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 4),
            Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
