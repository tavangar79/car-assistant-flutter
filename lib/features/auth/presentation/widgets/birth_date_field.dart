import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import 'auth_error_text.dart';
import 'format_jalali_date.dart';
import 'profile_field_label.dart';

/// Birth date "field": a button showing the chosen Jalali date that opens the picker via [onTap].
class BirthDateField extends StatelessWidget {
  const BirthDateField({super.key, required this.date, required this.onTap, this.error});

  final DateTime? date;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final value = date;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileFieldLabel(l10n.profileBirthDateLabel, required: true),
        const SizedBox(height: 4),
        Material(
          color: scheme.surfaceContainerLowest,
          shape: RoundedRectangleBorder(
            borderRadius: AppTheme.radius,
            side: BorderSide(color: error == null ? scheme.outlineVariant : scheme.error),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: AppTheme.radius,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 64),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 20, color: tones.muted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        value == null
                            ? l10n.profileBirthDatePlaceholder
                            : formatJalaliDate(value, l10n),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: value == null ? FontWeight.w400 : FontWeight.w600,
                          color: value == null ? scheme.outline : scheme.onSurface,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        l10n.profileBirthDateChange,
                        style: theme.textTheme.labelSmall?.copyWith(color: tones.muted),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.expand_more, size: 18, color: tones.muted),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 4),
          child: Text(
            l10n.profileBirthDateHint,
            style: theme.textTheme.bodySmall?.copyWith(color: tones.muted),
          ),
        ),
        if (error case final message?) ...[const SizedBox(height: 6), AuthErrorText(message)],
      ],
    );
  }
}
