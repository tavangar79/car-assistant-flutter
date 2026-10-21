import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/chart_palette.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';

/// "هزینه ۶ ماه اخیر": the month range, the chart area over the month axis (newest month bold, at
/// the end) and a legend with each vehicle's series color. No costs exist yet, so the chart area
/// holds the empty message instead of stacked bars and the month breakdown.
class SpendChartCard extends StatelessWidget {
  const SpendChartCard({super.key, required this.months, required this.vehicles});

  /// The chart's months, oldest first (see `recentJalaliMonths`).
  final List<Jalali> months;
  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    final palette = ChartPalette.of(context);
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeSpendTitle(months.length),
                      style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                    ),
                    Text(
                      _range(l10n),
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: scheme.surfaceContainer, shape: BoxShape.circle),
                child: Icon(Icons.bar_chart, size: 18, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // TODO(phase-3): stacked monthly bars per vehicle and the selected month's breakdown.
          SizedBox(
            height: 176,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_chart_outlined, size: 40, color: scheme.outline),
                  const SizedBox(height: 8),
                  Text(
                    l10n.homeSpendEmpty,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: muted),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: scheme.surfaceContainerHigh),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final (index, month) in months.indexed)
                  SizedBox(
                    width: 40,
                    child: Text(
                      l10n.jalaliMonth('${month.month}'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                      style: index == months.length - 1
                          ? theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: scheme.onSurface,
                            )
                          : theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: scheme.surfaceContainer),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              for (final (index, vehicle) in vehicles.indexed)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: palette.colorAt(index),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vehicle.nickname,
                      style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// "خرداد — آبان ۱۴۰۳", or with both years when the range crosses a Jalali year.
  String _range(AppLocalizations l10n) {
    final first = months.first;
    final last = months.last;
    String year(Jalali m) => localizeDigits('${m.year}', l10n.localeName);
    String name(Jalali m) => l10n.jalaliMonth('${m.month}');
    return first.year == last.year
        ? l10n.homeSpendRange(name(first), name(last), year(last))
        : l10n.homeSpendRangeAcrossYears(name(first), year(first), name(last), year(last));
  }
}
