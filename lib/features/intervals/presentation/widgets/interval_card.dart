import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../services/presentation/widgets/service_icon_tile.dart';
import '../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../../domain/entities/interval_rules.dart';
import '../../domain/entities/service_interval.dart';

/// One interval of the settings page (Stitch `dee2fcfb53034b6a96a868bb828e8d0f`): icon tile,
/// title, the factory default line, a reset-to-default button, then the km and months inputs.
class IntervalCard extends StatelessWidget {
  const IntervalCard({
    super.key,
    required this.interval,
    required this.index,
    required this.kmController,
    required this.monthsController,
    required this.onChanged,
    required this.onReset,
    this.kmError,
    this.monthsError,
  });

  final ServiceInterval interval;

  /// Position in the list; picks the decorative tint of the icon tile.
  final int index;
  final TextEditingController kmController;
  final TextEditingController monthsController;
  final VoidCallback onChanged;
  final VoidCallback onReset;
  final String? kmError;
  final String? monthsError;

  static DigitsInputFormatter kmFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: 6, grouped: true);

  static DigitsInputFormatter monthsFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: 3);

  /// The icon tile tints in screen order (amber, sky, neutral, rose, …).
  static ToneColors toneAt(int index, AppTones tones) {
    final cycle = [tones.amber, tones.info, tones.neutral, tones.overdue];
    return cycle[index % cycle.length];
  }

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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceIconTile(
                icon: interval.icon,
                tone: toneAt(index, tones),
                size: 40,
                iconSize: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interval.title,
                      style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      l10n.intervalsDefault(interval.defaultKm, interval.defaultMonths),
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: l10n.intervalsResetRow,
                onPressed: onReset,
                color: scheme.secondary,
                icon: const Icon(Icons.cached, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _NumberField(
                  controller: kmController,
                  formatter: kmFormatter(l10n.localeName),
                  unit: l10n.vehicleMileageUnit,
                  error: kmError,
                  onChanged: onChanged,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _NumberField(
                  controller: monthsController,
                  formatter: monthsFormatter(l10n.localeName),
                  unit: l10n.intervalsMonthsUnit,
                  error: monthsError,
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A number input on a `surface-container-low` box with its unit at the end.
class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.formatter,
    required this.unit,
    required this.error,
    required this.onChanged,
  });

  final TextEditingController controller;
  final DigitsInputFormatter formatter;
  final String unit;
  final String? error;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: controller,
          onChanged: (_) => onChanged(),
          keyboardType: TextInputType.number,
          inputFormatters: [formatter],
          style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: scheme.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: border(Colors.transparent),
            enabledBorder: error == null ? border(Colors.transparent) : border(scheme.error),
            focusedBorder: error == null ? border(scheme.primary, 2) : border(scheme.error, 2),
            suffixIconConstraints: const BoxConstraints(),
            suffixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: Text(
                unit,
                style: theme.textTheme.labelMedium?.copyWith(color: scheme.secondary),
              ),
            ),
          ),
        ),
        if (error case final error?) ...[const SizedBox(height: 4), AuthErrorText(error)],
      ],
    );
  }
}

/// The km limits as an inline error, or `null` when [km] is in range.
String? kmErrorOf(int? km, AppLocalizations l10n) => km != null && IntervalRules.isValidKm(km)
    ? null
    : l10n.intervalsKmError(IntervalRules.minKm, IntervalRules.maxKm);

/// The months limits as an inline error, or `null` when [months] is in range.
String? monthsErrorOf(int? months, AppLocalizations l10n) =>
    months != null && IntervalRules.isValidMonths(months)
    ? null
    : l10n.intervalsMonthsError(IntervalRules.minMonths, IntervalRules.maxMonths);
