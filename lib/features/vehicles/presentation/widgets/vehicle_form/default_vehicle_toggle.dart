import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import 'form_section_card.dart';

/// Star tile, title, description and a switch that makes this the default vehicle.
class DefaultVehicleToggle extends StatelessWidget {
  const DefaultVehicleToggle({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return FormSectionCard(
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: tones.info.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.star_border, size: 22, color: tones.info.foreground),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.vehicleDefaultTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.vehicleDefaultBody,
                    style: theme.textTheme.bodySmall?.copyWith(color: tones.muted, height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: value,
              onChanged: onChanged,
              activeTrackColor: scheme.primary,
              activeThumbColor: scheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
