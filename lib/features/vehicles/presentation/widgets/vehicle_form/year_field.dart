import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';
import 'form_field_header.dart';
import 'form_help_text.dart';
import 'form_section_card.dart';

/// Model year "field": a button showing the chosen Jalali [year] that opens the picker via [onTap].
class YearField extends StatelessWidget {
  const YearField({super.key, required this.year, required this.onTap, this.error});

  final int? year;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final value = year;
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(
            label: l10n.vehicleYearLabel,
            required: true,
            badge: l10n.vehicleYearBadge,
          ),
          const SizedBox(height: 4),
          Material(
            color: scheme.surfaceContainerLow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: error == null ? scheme.outlineVariant : scheme.error),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 20, color: muted),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          value == null
                              ? l10n.vehicleYearHint
                              : localizeDigits('$value', l10n.localeName),
                          style: value == null
                              ? theme.textTheme.bodyLarge?.copyWith(color: scheme.outline)
                              : theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onSurface,
                                ),
                        ),
                      ),
                      Icon(Icons.expand_more, size: 20, color: muted),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (error != null) ...[const SizedBox(height: 4), FormHelpText(error: error)],
        ],
      ),
    );
  }
}
