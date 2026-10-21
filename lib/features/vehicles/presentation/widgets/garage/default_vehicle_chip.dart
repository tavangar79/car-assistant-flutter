import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';

/// Top of a garage card: the amber "خودروی پیش‌فرض" badge on the default vehicle, else the
/// "انتخاب به عنوان پیش‌فرض" button ([onSetDefault]).
class DefaultVehicleChip extends StatelessWidget {
  const DefaultVehicleChip({super.key, required this.isDefault, required this.onSetDefault});

  final bool isDefault;
  final VoidCallback onSetDefault;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    if (isDefault) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: tones.amber.background,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, size: 16, color: tones.dueSoon.foreground),
            const SizedBox(width: 6),
            Text(
              l10n.garageDefaultBadge,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: tones.amber.chipForeground,
              ),
            ),
          ],
        ),
      );
    }
    return TextButton.icon(
      onPressed: onSetDefault,
      style: TextButton.styleFrom(
        backgroundColor: scheme.surfaceContainer,
        foregroundColor: scheme.secondary,
        shape: const StadiumBorder(),
        minimumSize: const Size(0, 28),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        textStyle: theme.textTheme.labelSmall,
      ),
      icon: const Icon(Icons.check_circle_outline, size: 16),
      label: Text(l10n.garageSetDefault),
    );
  }
}
