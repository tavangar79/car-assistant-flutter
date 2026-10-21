import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import 'details_card.dart';

/// A details section whose records don't exist yet: its heading, then a card with a faint icon
/// and one line. No numbers are made up.
class EmptySection extends StatelessWidget {
  const EmptySection({
    super.key,
    required this.icon,
    required this.title,
    required this.emptyIcon,
    required this.message,
  });

  final IconData icon;
  final String title;
  final IconData emptyIcon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Icon(icon, size: 20, color: muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DetailsCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Icon(emptyIcon, size: 40, color: scheme.outline),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
