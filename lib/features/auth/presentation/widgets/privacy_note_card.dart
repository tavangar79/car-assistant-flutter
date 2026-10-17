import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// Card explaining why personal details are stored.
class PrivacyNoteCard extends StatelessWidget {
  const PrivacyNoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.verified_user_outlined, size: 18, color: tones.muted),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profilePrivacyTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.profilePrivacyBody,
                  style: theme.textTheme.bodySmall?.copyWith(color: tones.muted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
