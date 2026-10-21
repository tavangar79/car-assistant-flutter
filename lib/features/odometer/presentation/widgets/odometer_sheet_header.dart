import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// Drag handle, then the `speed` tile with title and subtitle, and the close button.
class OdometerSheetHeader extends StatelessWidget {
  const OdometerSheetHeader({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tile = AppTones.of(context).neutral;
    return Column(
      children: [
        Container(
          width: 48,
          height: 6,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tile.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.speed, size: 24, color: tile.foreground),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.odometerTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                  ),
                  Text(
                    l10n.odometerSubtitle,
                    style: theme.textTheme.labelSmall?.copyWith(color: AppTones.of(context).muted),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: l10n.odometerClose,
              onPressed: onClose,
              style: IconButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: scheme.surfaceContainerHigh,
                foregroundColor: scheme.onSurfaceVariant,
              ),
              icon: const Icon(Icons.close, size: 20),
            ),
          ],
        ),
      ],
    );
  }
}
