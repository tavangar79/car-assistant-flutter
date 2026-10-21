import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/form_help_text.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/mileage_field.dart';

/// "کیلومترشمار فعلی": the last recorded mileage, the large km input with the unit pinned to its
/// end, then the distance since the last reading and the reset button, or the [error].
class OdometerInputCard extends StatelessWidget {
  const OdometerInputCard({
    super.key,
    required this.controller,
    required this.currentMileageKm,
    required this.value,
    required this.lastReadingAt,
    required this.onChanged,
    required this.onReset,
    this.error,
  });

  final TextEditingController controller;

  /// The vehicle's last recorded mileage ("آخرین ثبت").
  final int currentMileageKm;

  /// The value in the input, in km.
  final int value;

  /// When the latest reading was taken, or `null` when the vehicle has none.
  final DateTime? lastReadingAt;
  final ValueChanged<String> onChanged;
  final VoidCallback onReset;
  final String? error;

  /// The input's formatter: locale digits with thousands separators.
  static DigitsInputFormatter formatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: MileageField.maxDigits, grouped: true);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final inputFormatter = formatter(l10n.localeName);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: error == null ? BorderSide.none : BorderSide(color: scheme.error),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.odometerCurrentLabel,
                  style: theme.textTheme.labelSmall?.copyWith(color: muted),
                ),
              ),
              Icon(Icons.history, size: 15, color: scheme.outline),
              const SizedBox(width: 4),
              Text(
                l10n.odometerLastRecorded(currentMileageKm),
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            inputFormatters: [inputFormatter],
            style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
            decoration: InputDecoration(
              hintText: inputFormatter.format('0'),
              hintStyle: TextStyle(color: scheme.outline),
              filled: true,
              fillColor: scheme.surfaceContainerLowest,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              border: border,
              enabledBorder: border,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: error == null ? scheme.primary : scheme.error,
                  width: 2,
                ),
              ),
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(end: 16),
                child: Text(
                  l10n.vehicleMileageUnit,
                  style: theme.textTheme.labelLarge?.copyWith(color: muted),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (error != null)
            FormHelpText(error: error)
          else
            _DiffRow(
              diff: value - currentMileageKm,
              lastReadingAt: lastReadingAt,
              onReset: onReset,
            ),
        ],
      ),
    );
  }
}

class _DiffRow extends StatelessWidget {
  const _DiffRow({required this.diff, required this.lastReadingAt, required this.onReset});

  final int diff;
  final DateTime? lastReadingAt;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final number = NumberFormat.decimalPattern(l10n.localeName).format(diff.abs());
    final date = lastReadingAt;
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: scheme.tertiary, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: l10n.odometerDiff('${diff < 0 ? '-' : '+'}$number'),
                  style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
                ),
                const TextSpan(text: ' '),
                TextSpan(
                  text: date == null
                      ? l10n.odometerSinceLastUpdate
                      : l10n.odometerSinceLastUpdateOn(formatJalaliDate(date.toLocal(), l10n)),
                ),
              ],
            ),
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ),
        TextButton(
          onPressed: onReset,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            foregroundColor: muted,
            textStyle: theme.textTheme.labelSmall?.copyWith(decoration: TextDecoration.underline),
          ),
          child: Text(l10n.odometerReset),
        ),
      ],
    );
  }
}
