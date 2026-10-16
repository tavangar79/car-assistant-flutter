import 'package:flutter/material.dart';

/// Headline plus a short muted subtitle at the top of an auth page.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.headlineLarge!.copyWith(color: scheme.onSurface)),
        const SizedBox(height: 8),
        Text(subtitle, style: text.bodyMedium!.copyWith(color: scheme.onSurfaceVariant)),
      ],
    );
  }
}
