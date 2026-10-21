import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// The amber "بروزرسانی کیلومتر" button at the bottom of Home, with its caption.
class UpdateOdometerCta extends StatelessWidget {
  const UpdateOdometerCta({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: scheme.tertiary,
            foregroundColor: scheme.onTertiary,
            textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          icon: const Icon(Icons.speed, size: 22),
          label: Text(l10n.vehicleDetailsUpdateMileage),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.homeUpdateOdometerHint,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
