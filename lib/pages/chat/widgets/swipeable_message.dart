import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom swipe-to-reply widget with smooth animation (Telegram/WhatsApp style)
class SwipeableMessage extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipeReply;
  final bool enabled;

  const SwipeableMessage({
    super.key,
    required this.child,
    required this.onSwipeReply,
    this.enabled = true,
  });

  @override
  State<SwipeableMessage> createState() => _SwipeableMessageState();
}

class _SwipeableMessageState extends State<SwipeableMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragExtent = 0;
  static const double _triggerThreshold = 60;
  static const double _maxDragExtent = 100;
  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    setState(() {
      // Only allow right-to-left swipe (negative delta)
      _dragExtent = (_dragExtent - details.primaryDelta!)
          .clamp(0, _maxDragExtent);
    });

    // Haptic feedback when reaching threshold
    if (_dragExtent >= _triggerThreshold && !_hasTriggeredHaptic) {
      HapticFeedback.lightImpact();
      _hasTriggeredHaptic = true;
    } else if (_dragExtent < _triggerThreshold) {
      _hasTriggeredHaptic = false;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragExtent >= _triggerThreshold) {
      // Trigger reply
      HapticFeedback.mediumImpact();
      widget.onSwipeReply();
    }

    // Animate back to original position
    _animation = Tween<double>(begin: _dragExtent, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward(from: 0).then((_) {
      setState(() {
        _dragExtent = 0;
      });
    });
    _hasTriggeredHaptic = false;
  }

  @override
  Widget build(BuildContext context) {
    final offset = _controller.isAnimating ? _animation.value : _dragExtent;
    final progress = (offset / _triggerThreshold).clamp(0.0, 1.0);
    final isTriggered = offset >= _triggerThreshold;

    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          // Reply icon background
          if (offset > 0)
            Positioned(
              left: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -40 + (offset * 0.4).clamp(0, 40),
                      0,
                    ),
                    child: Transform.scale(
                      scale: 0.5 + (progress * 0.5),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isTriggered
                              ? const Color(0xFF3390EC)
                              : Colors.grey.withOpacity(0.3 + progress * 0.4),
                        ),
                        child: Icon(
                          Icons.reply_rounded,
                          color: isTriggered ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20 + (progress * 4),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Main message content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final currentOffset =
                  _controller.isAnimating ? _animation.value : _dragExtent;
              return Transform.translate(
                offset: Offset(-currentOffset, 0),
                child: widget.child,
              );
            },
          ),
        ],
      ),
    );
  }
}
