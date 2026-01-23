import 'package:flutter/material.dart';

/// Vacation Mode Toggle Widget
class VacationModeToggle extends StatelessWidget {
  final bool isActive;
  final String? message;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String?>? onMessageChange;
  final bool showMessage;

  const VacationModeToggle({
    super.key,
    required this.isActive,
    this.message,
    required this.onToggle,
    this.onMessageChange,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
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
                    color: isActive
                        ? colorScheme.primary.withValues(alpha: 0.1)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isActive ? '🏖️' : '🏠',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vacation Mode',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        isActive
                            ? 'Your listings are hidden'
                            : 'Your listings are visible',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: isActive,
                  onChanged: (value) => onToggle(value),
                ),
              ],
            ),
            if (showMessage && isActive) ...[
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Add a message (optional)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.message_outlined),
                  suffixIcon: message != null && message!.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => onMessageChange?.call(null),
                        )
                      : null,
                ),
                controller: TextEditingController(text: message),
                onChanged: onMessageChange,
                maxLength: 255,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Vacation Badge for Seller Profile
class VacationBadge extends StatelessWidget {
  final String? message;
  final bool compact;

  const VacationBadge({
    super.key,
    this.message,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏖️', style: TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            Text(
              'On vacation',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🏖️', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'On Vacation',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.amber.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (message != null && message!.isNotEmpty)
                  Text(
                    message!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  )
                else
                  Text(
                    'Currently unavailable',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Vacation Status Indicator for List Items
class VacationIndicator extends StatelessWidget {
  final bool isOnVacation;
  final double size;

  const VacationIndicator({
    super.key,
    required this.isOnVacation,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (!isOnVacation) return const SizedBox.shrink();

    return Tooltip(
      message: 'Seller is on vacation',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Center(
          child: Text(
            '🏖️',
            style: TextStyle(fontSize: size * 0.6),
          ),
        ),
      ),
    );
  }
}
