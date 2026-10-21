import 'package:flutter/material.dart';

/// A small label over an input (Stitch step 2/3: `label-md` on-surface-variant, 6px gap), with an
/// optional [badge] at the label's end (e.g. "مشترک").
class WizardField extends StatelessWidget {
  const WizardField({super.key, required this.label, required this.child, this.badge});

  final String label;
  final String? badge;
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
                style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
            if (badge case final badge?)
              Text(badge, style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary)),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Borderless input on a `surface-container-low` fill, 12px radius (Stitch wizard inputs).
/// [hasError] draws the error border instead.
InputDecoration wizardInputDecoration(
  BuildContext context, {
  String? hint,
  Widget? prefixIcon,
  Widget? suffix,
  bool hasError = false,
}) {
  final scheme = Theme.of(context).colorScheme;
  OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: width),
  );
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(color: scheme.outline),
    counterText: '',
    isDense: true,
    filled: true,
    fillColor: scheme.surfaceContainerLow,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIcon: prefixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    suffixIcon: suffix,
    suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
    border: border(Colors.transparent),
    enabledBorder: hasError ? border(scheme.error) : border(Colors.transparent),
    focusedBorder: hasError ? border(scheme.error, 2) : border(scheme.primary, 2),
  );
}
