import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';

/// Section label at the start (with a red `*` when [required], or a muted "(optional)") and a
/// small [badge] note at the end. [badgeAsChip] draws the badge on a grey chip.
class FormFieldHeader extends StatelessWidget {
  const FormFieldHeader({
    super.key,
    required this.label,
    this.required = false,
    this.optional = false,
    this.badge,
    this.badgeAsChip = false,
    this.small = false,
  });

  final String label;
  final bool required;
  final bool optional;
  final String? badge;
  final bool badgeAsChip;

  /// A sub-field label (Stitch `label-md`) instead of a section label (`label-lg`).
  final bool small;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final style = small
        ? theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant)
        : theme.textTheme.labelLarge?.copyWith(color: scheme.onSurface);
    return Row(
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: label),
                if (required)
                  TextSpan(
                    text: ' *',
                    semanticsLabel: ' ${l10n.vehicleRequiredLabel}',
                    style: TextStyle(color: scheme.error),
                  ),
                if (optional)
                  TextSpan(
                    text: ' ${l10n.vehicleOptional}',
                    style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
                  ),
              ],
            ),
            style: style,
          ),
        ),
        if (badge case final badge?)
          badgeAsChip
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Text(badge, style: theme.textTheme.labelSmall?.copyWith(color: tones.muted)),
      ],
    );
  }
}
