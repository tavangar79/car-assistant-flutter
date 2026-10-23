import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';

/// The subscription banner of the profile (Stitch `4b009228766f48859e449e996af538b9`): the current
/// plan (always پایه for now) and "ارتقا یا تمدید", which opens the plans page. The free plan has
/// no billing period, so the screen's days-left line and progress bar are left out.
class ProfilePlanCard extends StatelessWidget {
  const ProfilePlanCard({super.key, required this.onUpgrade});

  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = AppTones.of(context).accentOnPrimary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.15), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.workspace_premium_outlined, size: 24, color: accent),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      l10n.profilePlanTitle,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.onPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        l10n.profilePlanBadge,
                        style: theme.textTheme.labelSmall?.copyWith(color: accent),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.profilePlanHint,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onUpgrade,
            style: FilledButton.styleFrom(
              minimumSize: const Size(48, 48),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              backgroundColor: accent,
              foregroundColor: scheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            child: Text(l10n.profilePlanUpgrade),
          ),
        ],
      ),
    );
  }
}
