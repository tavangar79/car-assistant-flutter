import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import 'form_section_card.dart';

/// Star tile, title, description and a switch that makes this the default vehicle.
///
/// When [locked] (editing the current default vehicle) the switch stays on and disabled, with a
/// helper line saying the default changes by making another vehicle the default (Stitch edit
/// screen `25ad5d184ff94cf2976c21640ca21f1f`).
class DefaultVehicleToggle extends StatelessWidget {
  const DefaultVehicleToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.locked = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool locked;

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
                  if (locked) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.info_outline, size: 16, color: tones.muted),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.vehicleDefaultLocked,
                            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            Switch(
              value: locked || value,
              onChanged: locked ? null : onChanged,
              activeTrackColor: scheme.primary,
              activeThumbColor: scheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
