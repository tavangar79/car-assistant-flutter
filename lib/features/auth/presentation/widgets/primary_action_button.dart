import 'package:flutter/material.dart';

/// Full-width 64dp primary button that shows a spinner while [loading].
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(64),
        textStyle: Theme.of(context).textTheme.titleMedium,
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 3, color: scheme.primary),
            )
          : Text(label),
    );
  }
}
