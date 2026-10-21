import 'package:flutter/material.dart';

/// A small pill chip of the fuel and expense forms: navy when [selected], else a
/// `surface-container-low` fill (Stitch date chips and quick-add chips).
class QuickChip extends StatelessWidget {
  const QuickChip({
    super.key,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.icon,
  });

  final String label;
  final bool selected;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: selected ? scheme.primary : scheme.surfaceContainerLow,
        foregroundColor: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
        textStyle: theme.textTheme.labelSmall?.copyWith(
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon case final icon?) ...[Icon(icon, size: 14), const SizedBox(width: 4)],
          Text(label),
        ],
      ),
    );
  }
}
