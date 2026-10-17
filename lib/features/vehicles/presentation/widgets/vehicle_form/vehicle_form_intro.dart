import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';

/// Banner at the top of the vehicle form: car tile, heading and one line of context.
class VehicleFormIntro extends StatelessWidget {
  const VehicleFormIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.directions_car, size: 20, color: scheme.onPrimary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.vehicleFormIntroTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
                Text(
                  l10n.vehicleFormIntroBody,
                  style: theme.textTheme.labelMedium?.copyWith(color: AppTones.of(context).muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
