import 'package:flutter/material.dart';

/// A section label over a control on the expense page (Stitch: `label-lg` on-surface, an
/// optional `label-sm` hint at its end, 6px gap).
class ExpenseField extends StatelessWidget {
  const ExpenseField({super.key, required this.label, required this.child, this.hint});

  final String label;
  final String? hint;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface),
              ),
            ),
            if (hint case final hint?)
              Text(
                hint,
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
