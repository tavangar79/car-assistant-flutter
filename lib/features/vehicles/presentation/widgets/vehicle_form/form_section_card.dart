import 'package:flutter/material.dart';

/// White card that holds one section of the vehicle form (Stitch: 16px padding, 12px radius,
/// small shadow).
class FormSectionCard extends StatelessWidget {
  const FormSectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: child,
    );
  }
}
