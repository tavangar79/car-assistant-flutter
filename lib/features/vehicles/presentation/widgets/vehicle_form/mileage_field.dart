import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import 'digits_input_formatter.dart';
import 'form_field_header.dart';
import 'form_input_decoration.dart';
import 'form_section_card.dart';
import 'form_help_text.dart';

/// Required odometer reading in km, in large odometer digits with thousands separators.
class MileageField extends StatelessWidget {
  const MileageField({super.key, required this.controller, this.onChanged, this.error});

  /// Largest number of digits accepted (2,000,000 km has 7).
  static const maxDigits = 7;

  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = AppTones.of(context).muted;
    final formatter = DigitsInputFormatter(
      locale: l10n.localeName,
      maxDigits: maxDigits,
      grouped: true,
    );
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(
            label: l10n.vehicleMileageLabel,
            required: true,
            badge: l10n.vehicleMileageBadge,
            badgeAsChip: true,
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [formatter],
            style: AppTextStyles.metricOdometer.copyWith(color: theme.colorScheme.onSurface),
            decoration: formInputDecoration(
              context,
              hint: formatter.format('0'),
              hasError: error != null,
              suffix: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Text(
                  l10n.vehicleMileageUnit,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: muted,
                  ),
                ),
              ),
            ).copyWith(suffixIconConstraints: const BoxConstraints()),
          ),
          const SizedBox(height: 4),
          if (error != null)
            FormHelpText(error: error)
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(Icons.info_outline, size: 16, color: muted),
                ),
                const SizedBox(width: 6),
                Expanded(child: FormHelpText(help: l10n.vehicleMileageHelp)),
              ],
            ),
        ],
      ),
    );
  }
}
