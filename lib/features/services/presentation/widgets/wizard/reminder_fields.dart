import 'package:flutter/material.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import '../service_formats.dart';

/// "یادآور موعد بعدی": the km after this visit and the months after its date, each with the
/// resulting due value under it. [baseKm] and [baseDate] are the visit's odometer and date.
class ReminderFields extends StatelessWidget {
  const ReminderFields({
    super.key,
    required this.kmController,
    required this.monthsController,
    required this.nextDueKm,
    required this.nextDueMonths,
    required this.baseKm,
    required this.baseDate,
    required this.onKmChanged,
    required this.onMonthsChanged,
  });

  final TextEditingController kmController;
  final TextEditingController monthsController;
  final int? nextDueKm;
  final int? nextDueMonths;
  final int baseKm;
  final DateTime baseDate;
  final ValueChanged<String> onKmChanged;
  final ValueChanged<String> onMonthsChanged;

  static DigitsInputFormatter kmFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: 6, grouped: true);

  static DigitsInputFormatter monthsFormatter(String locale) =>
      DigitsInputFormatter(locale: locale, maxDigits: 3);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final (month, year) = nextDueMonths == null
        ? ('', '')
        : dueMonthYear(baseDate, nextDueMonths!, l10n);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_outlined, size: 20, color: scheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.serviceReminderTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
              Text(
                l10n.serviceReminderHint,
                style: theme.textTheme.labelSmall?.copyWith(color: muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Slot(
                  label: l10n.serviceReminderKmLabel,
                  unit: l10n.vehicleMileageUnit,
                  controller: kmController,
                  formatter: kmFormatter(l10n.localeName),
                  onChanged: onKmChanged,
                  due: nextDueKm == null ? null : l10n.serviceReminderDueKm(baseKm + nextDueKm!),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _Slot(
                  label: l10n.serviceReminderMonthsLabel,
                  unit: l10n.serviceReminderMonthsUnit,
                  controller: monthsController,
                  formatter: monthsFormatter(l10n.localeName),
                  onChanged: onMonthsChanged,
                  due: nextDueMonths == null ? null : l10n.serviceReminderDueDate(month, year),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One white box: label, the number input with its unit, then the due chip when a value is set.
class _Slot extends StatelessWidget {
  const _Slot({
    required this.label,
    required this.unit,
    required this.controller,
    required this.formatter,
    required this.onChanged,
    required this.due,
  });

  final String label;
  final String unit;
  final TextEditingController controller;
  final DigitsInputFormatter formatter;
  final ValueChanged<String> onChanged;
  final String? due;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant)),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  keyboardType: TextInputType.number,
                  inputFormatters: [formatter],
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: formatter.format('0'),
                    hintStyle: TextStyle(color: scheme.outline),
                    isDense: true,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              Text(
                unit,
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          if (due case final due?)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                due,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}
