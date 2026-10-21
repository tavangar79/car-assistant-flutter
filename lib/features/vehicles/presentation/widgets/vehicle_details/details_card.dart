import 'package:flutter/material.dart';

/// White card of the vehicle details page (Stitch: 16px padding, 12px radius, small shadow).
class DetailsCard extends StatelessWidget {
  const DetailsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
      ),
      child: child,
    );
  }
}
