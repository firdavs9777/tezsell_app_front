import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/providers/provider_models/review_model.dart';

/// Review Tag Selector Widget
class ReviewTagSelector extends StatelessWidget {
  final List<ReviewTag> tags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onChanged;
  final int maxSelection;
  final String locale;

  const ReviewTagSelector({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onChanged,
    this.maxSelection = 5,
    this.locale = 'en',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Separate positive and negative tags
    final positiveTags = tags.where((t) => t.isPositive).toList();
    final negativeTags = tags.where((t) => t.isNegative).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Positive tags section
        if (positiveTags.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Positive',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: positiveTags
                .map((tag) => _buildTagChip(context, tag, true))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        // Negative tags section
        if (negativeTags.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Needs Improvement',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: negativeTags
                .map((tag) => _buildTagChip(context, tag, false))
                .toList(),
          ),
        ],
        // Selection count
        if (selectedTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '${selectedTags.length}/$maxSelection selected',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTagChip(BuildContext context, ReviewTag tag, bool isPositive) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedTags.contains(tag.name);
    final canSelect = selectedTags.length < maxSelection || isSelected;

    final baseColor =
        isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFF5722);

    return GestureDetector(
      onTap: canSelect
          ? () {
              HapticFeedback.selectionClick();
              final newSelection = List<String>.from(selectedTags);
              if (isSelected) {
                newSelection.remove(tag.name);
              } else {
                newSelection.add(tag.name);
              }
              onChanged(newSelection);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? baseColor.withOpacity(0.15)
              : colorScheme.surfaceVariant.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? baseColor : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tag.icon,
              style: TextStyle(
                fontSize: 14,
                color: canSelect ? null : Colors.grey,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              tag.getLocalizedName(locale),
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? baseColor
                    : canSelect
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withOpacity(0.4),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.check,
                size: 14,
                color: baseColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Display tags (read-only) for review display
class ReviewTagsDisplay extends StatelessWidget {
  final List<String> tags;
  final double size;

  const ReviewTagsDisplay({
    super.key,
    required this.tags,
    this.size = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6 * size,
      runSpacing: 6 * size,
      children: tags.map((tagName) {
        // Find tag details from predefined tags
        final tag = ReviewTags.all.firstWhere(
          (t) => t.name == tagName,
          orElse: () => ReviewTag(
            id: 0,
            name: tagName,
            tagType: 'positive',
            icon: '👍',
          ),
        );

        final isPositive = tag.isPositive;
        final color =
            isPositive ? const Color(0xFF4CAF50) : const Color(0xFFFF5722);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 8 * size,
            vertical: 4 * size,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12 * size),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                tag.icon,
                style: TextStyle(fontSize: 11 * size),
              ),
              SizedBox(width: 4 * size),
              Text(
                tagName,
                style: TextStyle(
                  fontSize: 11 * size,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

/// Quick feedback buttons for simple reviews
class QuickFeedbackButtons extends StatelessWidget {
  final String? selected; // 'positive' or 'negative'
  final ValueChanged<String> onSelected;

  const QuickFeedbackButtons({
    super.key,
    this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            context,
            icon: '👍',
            label: 'Good',
            value: 'positive',
            color: const Color(0xFF4CAF50),
            isSelected: selected == 'positive',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildButton(
            context,
            icon: '👎',
            label: 'Not Good',
            value: 'negative',
            color: const Color(0xFFFF5722),
            isSelected: selected == 'negative',
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String icon,
    required String label,
    required String value,
    required Color color,
    required bool isSelected,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onSelected(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : colorScheme.outline.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
