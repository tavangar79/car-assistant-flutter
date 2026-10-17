import 'package:flutter/material.dart';

/// One-line error under a field, in the theme's error color.
class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.error;
    return Row(
      children: [
        Icon(Icons.error_outline, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(message, style: theme.textTheme.bodySmall?.copyWith(color: color)),
        ),
      ],
    );
  }
}
