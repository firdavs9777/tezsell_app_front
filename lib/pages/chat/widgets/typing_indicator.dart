import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final Map<int, bool> typingUsers;
  final List<User> participants;
  final int currentUserId;

  const TypingIndicator({
    super.key,
    required this.typingUsers,
    required this.participants,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final activeTypers = typingUsers.entries
        .where((e) => e.key != currentUserId && e.value)
        .toList();

    if (activeTypers.isEmpty) {
      return const SizedBox.shrink();
    }

    final typerNames = activeTypers.map((e) {
      final user = participants.firstWhere(
        (p) => p.id == e.key,
        orElse: () => User(id: e.key, username: 'Someone'),
      );
      return user.username;
    }).toList();

    final displayText = typerNames.length == 1
        ? '${typerNames.first} is typing'
        : typerNames.length == 2
            ? '${typerNames.join(' and ')} are typing'
            : '${typerNames.length} people are typing';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const TypingDots(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated typing dots (like iMessage/Telegram). Public (Task 20) so the
/// app bar's compact typing subtitle can reuse the same bounce animation at
/// a smaller size instead of duplicating it.
class TypingDots extends StatefulWidget {
  /// Diameter of each dot.
  final double dotSize;

  /// Whether to wrap the dots in the pill-shaped surface background used by
  /// the below-message-list indicator. The app bar's inline usage renders
  /// bare dots (no pill) to sit flush in the subtitle row.
  final bool showBackground;

  const TypingDots({super.key, this.dotSize = 6, this.showBackground = true});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Stagger the animation for each dot
            final delay = index * 0.2;
            final progress = (_controller.value + delay) % 1.0;
            final bounce = (progress < 0.5)
                ? progress * 2
                : 2.0 - (progress * 2);

            return Container(
              margin: EdgeInsets.only(left: index > 0 ? widget.dotSize * 0.67 : 0),
              child: Transform.translate(
                offset: Offset(0, -(widget.dotSize / 2) * bounce),
                child: Container(
                  width: widget.dotSize,
                  height: widget.dotSize,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );

    if (!widget.showBackground) return dots;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: dots,
    );
  }
}
