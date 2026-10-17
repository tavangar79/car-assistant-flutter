import 'package:flutter/material.dart';

/// Full-width navy button with an [icon] right of the label (Stitch: 48px high, 12px radius).
/// [onPressed] `null` disables it; [loading] shows a spinner instead of the label.
class PrimaryCtaButton extends StatelessWidget {
  const PrimaryCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon = Icons.arrow_forward,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  /// Forward arrow by default; the complete-profile page uses a check mark.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      onPressed: loading ? null : onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: loading
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onSurfaceVariant),
            )
          // The design puts the icon to the right of the label (the arrow points right).
          : Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(label, textDirection: TextDirection.rtl)),
                  const SizedBox(width: 8),
                  Icon(icon, size: 16),
                ],
              ),
            ),
    );
  }
}
