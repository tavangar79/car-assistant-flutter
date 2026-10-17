import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';

/// Card with the masked number the code went to (`۰۹۱۲ ••• ۶۷۸۹`) and an "edit number" button.
class MaskedPhoneCard extends StatelessWidget {
  const MaskedPhoneCard({super.key, required this.phone, required this.onEdit});

  /// Normalized `09xxxxxxxxx`.
  final String phone;
  final VoidCallback onEdit;

  /// `09121236789` → `0912 ••• 6789` with the digits of [locale].
  static String mask(String phone, String locale) {
    if (phone.length < 8) return localizeDigits(phone, locale);
    final start = localizeDigits(phone.substring(0, 4), locale);
    final end = localizeDigits(phone.substring(phone.length - 4), locale);
    return '$start ••• $end';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: AppTheme.cardRadius,
        border: Border.all(color: scheme.outlineVariant),
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.smartphone, size: 20, color: tones.label),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.authPhoneLabel,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 11, color: scheme.outline),
                ),
                const SizedBox(height: 2),
                Text(
                  mask(phone, l10n.localeName),
                  textDirection: TextDirection.ltr,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                    color: scheme.primary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              backgroundColor: scheme.surface,
              foregroundColor: scheme.secondary,
              side: BorderSide(color: scheme.outlineVariant),
              textStyle: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(child: Text(l10n.authEditPhone)),
                const SizedBox(width: 6),
                Icon(Icons.edit_outlined, size: 14, color: tones.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
