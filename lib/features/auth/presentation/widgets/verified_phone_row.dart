import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'masked_phone_card.dart';
import 'profile_field_label.dart';

/// Read-only row with the signed-in user's masked phone and a "verified" badge.
class VerifiedPhoneRow extends StatelessWidget {
  const VerifiedPhoneRow({super.key, required this.phone});

  /// Normalized `09xxxxxxxxx`.
  final String phone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileFieldLabel(l10n.profilePhoneLabel),
        const SizedBox(height: 4),
        Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: scheme.surfaceContainer, borderRadius: AppTheme.radius),
          child: Row(
            children: [
              Icon(Icons.smartphone, size: 20, color: tones.muted),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    MaskedPhoneCard.mask(phone, l10n.localeName),
                    textDirection: TextDirection.ltr,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: scheme.onSurface,
                    ),
                  ),
                ),
              ),
              _VerifiedBadge(label: l10n.profilePhoneVerified),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tone = AppTones.of(context).emerald;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: tone.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, size: 14, color: tone.chipForeground),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(fontWeight: FontWeight.w600, color: tone.chipForeground),
          ),
        ],
      ),
    );
  }
}
