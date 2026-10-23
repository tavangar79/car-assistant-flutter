import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import '../../domain/entities/report_period.dart';

/// "بازه زمانی گزارش": the quick range pills (scrolling sideways) and the "از تاریخ / تا تاریخ"
/// fields, which open the Jalali picker. A `null` [from] (every record) shows a dash.
class ReportPeriodCard extends StatelessWidget {
  const ReportPeriodCard({
    super.key,
    required this.period,
    required this.from,
    required this.to,
    required this.currentYear,
    required this.onPeriod,
    required this.onPickFrom,
    required this.onPickTo,
  });

  final ReportPeriod period;
  final DateTime? from;
  final DateTime? to;

  /// The current Jalali year, for the "سال جاری (۱۴۰۳)" pill.
  final int currentYear;
  final ValueChanged<ReportPeriod> onPeriod;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final pills = [
      (ReportPeriod.lastThreeMonths, l10n.reportPeriodThreeMonths),
      (ReportPeriod.lastSixMonths, l10n.reportPeriodSixMonths),
      (
        ReportPeriod.currentYear,
        l10n.reportPeriodCurrentYear(localizeDigits('$currentYear', l10n.localeName)),
      ),
      (ReportPeriod.allTime, l10n.reportPeriodAll),
    ];
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_month, size: 20, color: scheme.secondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  l10n.reportPeriodTitle,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                l10n.reportJalaliCalendar,
                style: theme.textTheme.labelSmall?.copyWith(color: muted),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final (value, label) in pills) ...[
                  _Pill(label: label, selected: period == value, onTap: () => onPeriod(value)),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _DateField(label: l10n.reportFrom, date: from, onTap: onPickFrom),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DateField(label: l10n.reportTo, date: to, onTap: onPickTo),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A quick range pill, navy when [selected]; a 48px touch target around a 32px pill.
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 48,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? scheme.primary : scheme.surfaceContainer,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected ? scheme.onPrimary : scheme.secondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A labelled Jalali date box, e.g. "۰۱ فروردین ۱۴۰۳", that opens the picker.
class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.date, required this.onTap});

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: AppTones.of(context).muted)),
        const SizedBox(height: 4),
        Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 48),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      date == null ? l10n.reportDateUnset : reportDateText(date!, l10n),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(Icons.event, size: 18, color: scheme.secondary),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// A date as Stitch writes it in the range fields: `۰۱ فروردین ۱۴۰۳`.
String reportDateText(DateTime date, AppLocalizations l10n) {
  final jalali = Jalali.fromDateTime(date.toLocal());
  final day = localizeDigits(jalali.day.toString().padLeft(2, '0'), l10n.localeName);
  final year = localizeDigits('${jalali.year}', l10n.localeName);
  return '$day ${l10n.jalaliMonth('${jalali.month}')} $year';
}
