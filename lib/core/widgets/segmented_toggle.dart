import 'package:flutter/material.dart';

/// A two-way segmented control (Stitch: a grey track, the selected segment white with a shadow).
/// Each segment is at least 48px high (the export scope, the plans billing cycle).
class SegmentedToggle extends StatelessWidget {
  const SegmentedToggle({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
  });

  /// The segments; an `icon` may be `null`, and a `trailing` widget follows the label.
  final List<({IconData? icon, String label, Widget? trailing})> segments;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (final (index, segment) in segments.indexed)
            Expanded(
              child: _Segment(
                icon: segment.icon,
                label: segment.label,
                trailing: segment.trailing,
                selected: index == selected,
                onTap: () => onSelected(index),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.icon,
    required this.label,
    required this.trailing,
    required this.selected,
    required this.onTap,
  });

  final IconData? icon;
  final String label;
  final Widget? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.onSurface : scheme.secondary;
    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? scheme.surfaceContainerLowest : Colors.transparent,
        elevation: selected ? 1 : 0,
        shadowColor: scheme.shadow.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon case final icon?) ...[
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  if (trailing case final trailing?) ...[const SizedBox(width: 6), trailing],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
