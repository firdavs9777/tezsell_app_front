import 'package:flutter/material.dart';

/// A shimmer loading effect widget for chat list and messages
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: const [
                Color(0xFFEBEBEB),
                Color(0xFFF5F5F5),
                Color(0xFFEBEBEB),
              ],
              stops: [
                0.0,
                (_animation.value + 2) / 4,
                1.0,
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/// Chat list shimmer placeholder
class ChatListShimmer extends StatelessWidget {
  final int itemCount;

  const ChatListShimmer({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
        thickness: 0.5,
        indent: 80,
        color: Theme.of(context).colorScheme.outlineVariant,
      ),
      itemBuilder: (context, index) => const _ChatListTileShimmer(),
    );
  }
}

class _ChatListTileShimmer extends StatefulWidget {
  const _ChatListTileShimmer();

  @override
  State<_ChatListTileShimmer> createState() => _ChatListTileShimmerState();
}

class _ChatListTileShimmerState extends State<_ChatListTileShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar placeholder
              _ShimmerBox(
                width: 52,
                height: 52,
                borderRadius: 26,
                animation: _controller,
              ),
              const SizedBox(width: 12),
              // Content placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _ShimmerBox(
                          width: 120,
                          height: 16,
                          borderRadius: 4,
                          animation: _controller,
                        ),
                        const Spacer(),
                        _ShimmerBox(
                          width: 40,
                          height: 12,
                          borderRadius: 4,
                          animation: _controller,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _ShimmerBox(
                      width: double.infinity,
                      height: 14,
                      borderRadius: 4,
                      animation: _controller,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final AnimationController animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF5F5F5),
                Color(0xFFE8E8E8),
              ],
              stops: [
                (animation.value - 0.3).clamp(0.0, 1.0),
                animation.value.clamp(0.0, 1.0),
                (animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Message list shimmer placeholder
class MessageListShimmer extends StatelessWidget {
  final int itemCount;

  const MessageListShimmer({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => _MessageBubbleShimmer(
        isOwnMessage: index % 3 == 0,
      ),
    );
  }
}

class _MessageBubbleShimmer extends StatefulWidget {
  final bool isOwnMessage;

  const _MessageBubbleShimmer({required this.isOwnMessage});

  @override
  State<_MessageBubbleShimmer> createState() => _MessageBubbleShimmerState();
}

class _MessageBubbleShimmerState extends State<_MessageBubbleShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bubbleWidth = screenWidth * (0.4 + (widget.isOwnMessage ? 0.1 : 0.2));

    return Align(
      alignment:
          widget.isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: _ShimmerBox(
          width: bubbleWidth,
          height: 60,
          borderRadius: 12,
          animation: _controller,
        ),
      ),
    );
  }
}
