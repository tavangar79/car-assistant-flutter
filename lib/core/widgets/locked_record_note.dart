import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_tones.dart';

/// The "مالک قبلی" chip and why the record is read-only: it was created before the current owner
/// got the vehicle by an ownership transfer.
class LockedRecordNote extends StatelessWidget {
  const LockedRecordNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final neutral = AppTones.of(context).neutral;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: neutral.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: neutral.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: neutral.chipBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 14, color: neutral.chipForeground),
                const SizedBox(width: 4),
                Text(
                  l10n.recordLockedLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: neutral.chipForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.recordLockedHint,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
