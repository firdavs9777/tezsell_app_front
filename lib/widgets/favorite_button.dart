import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Animated Favorite Button with heart animation
class FavoriteButton extends StatefulWidget {
  final bool isFavorited;
  final VoidCallback onToggle;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool showBorder;

  const FavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onToggle,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.showBorder = false,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -5),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -5, end: 0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -2),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -2, end: 0),
        weight: 25,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _controller.forward(from: 0);
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = widget.activeColor ?? Colors.red;
    final inactiveColor =
        widget.inactiveColor ?? colorScheme.onSurface.withOpacity(0.4);

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: EdgeInsets.all(widget.size * 0.2),
                decoration: widget.showBorder
                    ? BoxDecoration(
                        color: widget.isFavorited
                            ? activeColor.withOpacity(0.1)
                            : colorScheme.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isFavorited
                              ? activeColor.withOpacity(0.3)
                              : colorScheme.outline.withOpacity(0.2),
                          width: 1,
                        ),
                      )
                    : null,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    widget.isFavorited
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    key: ValueKey(widget.isFavorited),
                    size: widget.size,
                    color: widget.isFavorited ? activeColor : inactiveColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Favorite Button with count display
class FavoriteButtonWithCount extends StatelessWidget {
  final bool isFavorited;
  final int count;
  final VoidCallback onToggle;
  final double size;

  const FavoriteButtonWithCount({
    super.key,
    required this.isFavorited,
    required this.count,
    required this.onToggle,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FavoriteButton(
          isFavorited: isFavorited,
          onToggle: onToggle,
          size: size,
        ),
        if (count > 0) ...[
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: size * 0.6,
              fontWeight: FontWeight.w500,
              color: isFavorited
                  ? Colors.red
                  : colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ],
    );
  }
}

/// Floating Favorite Button for detail pages
class FloatingFavoriteButton extends StatelessWidget {
  final bool isFavorited;
  final VoidCallback onToggle;

  const FloatingFavoriteButton({
    super.key,
    required this.isFavorited,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: FavoriteButton(
        isFavorited: isFavorited,
        onToggle: onToggle,
        size: 28,
      ),
    );
  }
}

/// Price Drop Badge Widget
class PriceDropBadge extends StatelessWidget {
  final String? percentage;
  final String? originalPrice;
  final String currentPrice;
  final bool compact;

  const PriceDropBadge({
    super.key,
    this.percentage,
    this.originalPrice,
    required this.currentPrice,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompact(context);
    }
    return _buildFull(context);
  }

  Widget _buildCompact(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.trending_down,
            size: 12,
            color: Color(0xFF4CAF50),
          ),
          if (percentage != null) ...[
            const SizedBox(width: 2),
            Text(
              percentage!,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFull(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF4CAF50).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_down,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Dropped!',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (originalPrice != null) ...[
                      Text(
                        originalPrice!,
                        style: TextStyle(
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward,
                        size: 12,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      currentPrice,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF388E3C),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (percentage != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                percentage!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Notify Price Drop Toggle
class NotifyPriceDropToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const NotifyPriceDropToggle({
    super.key,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => onChanged(!enabled),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: enabled
              ? const Color(0xFF4CAF50).withOpacity(0.1)
              : colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: enabled
                ? const Color(0xFF4CAF50).withOpacity(0.3)
                : colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              enabled
                  ? Icons.notifications_active
                  : Icons.notifications_outlined,
              size: 18,
              color: enabled
                  ? const Color(0xFF4CAF50)
                  : colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(width: 8),
            Text(
              'Notify on price drop',
              style: TextStyle(
                fontSize: 13,
                fontWeight: enabled ? FontWeight.w500 : FontWeight.w400,
                color: enabled
                    ? const Color(0xFF4CAF50)
                    : colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 20,
              decoration: BoxDecoration(
                color: enabled ? const Color(0xFF4CAF50) : Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    enabled ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
