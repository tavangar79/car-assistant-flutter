import 'package:flutter/material.dart';

/// The sticky bottom bar of a wizard step (Stitch: white at 95%, level-3 shadow, 16px padding).
class WizardFooter extends StatelessWidget {
  const WizardFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 16), child: child),
      ),
    );
  }
}

/// The navy "continue" button of steps 1 and 2: [label] then an arrow pointing forward.
class WizardContinueButton extends StatelessWidget {
  const WizardContinueButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onPressed,
    style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: 8),
        // arrow_forward mirrors to point left (forward) in RTL.
        const Icon(Icons.arrow_forward, size: 20),
      ],
    ),
  );
}
