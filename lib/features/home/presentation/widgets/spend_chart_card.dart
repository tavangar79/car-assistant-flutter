import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/chart_palette.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/domain/entities/month_cost.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/details_card.dart';
import 'spend_bars.dart';
import 'spend_month_breakdown.dart';

/// "هزینه ۶ ماه اخیر": the month range, the selected month's total and per-vehicle breakdown
/// (the latest month first; tap a bar to pick another), the stacked bars per vehicle over the month
/// axis and a legend with each vehicle's series color. Without any cost the chart area holds the
/// empty message instead.
class SpendChartCard extends StatefulWidget {
  const SpendChartCard({super.key, required this.months, required this.vehicles});

  /// The chart's months, oldest first, with costs from the dashboard.
  final List<MonthCost> months;

  /// Garage order; a vehicle's index is its series color.
  final List<Vehicle> vehicles;

  @override
  State<SpendChartCard> createState() => _SpendChartCardState();
}

class _SpendChartCardState extends State<SpendChartCard> {
  late int _selected = widget.months.length - 1;

  @override
  void didUpdateWidget(SpendChartCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selected >= widget.months.length) _selected = widget.months.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final months = widget.months;
    final hasCosts = months.any((month) => month.totalCost > 0);
    return DetailsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(months: months),
          const SizedBox(height: 16),
          if (hasCosts) ...[
            SpendMonthBreakdown(month: months[_selected], vehicles: widget.vehicles),
            const SizedBox(height: 16),
            SpendBars(
              months: months,
              vehicles: widget.vehicles,
              selected: _selected,
              onSelect: (index) => setState(() => _selected = index),
            ),
          ] else
            const _EmptyChart(),
          Divider(height: 1, thickness: 1, color: scheme.surfaceContainerHigh),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                for (final (index, month) in months.indexed)
                  Expanded(
                    child: Text(
                      l10n.jalaliMonth('${month.jalaliMonth}'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                      style: index == (hasCosts ? _selected : months.length - 1)
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
          _Legend(vehicles: widget.vehicles),
        ],
      ),
    );
  }
}

/// Title, month range and the chart icon.
class _Header extends StatelessWidget {
  const _Header({required this.months});

  final List<MonthCost> months;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.homeSpendTitle(months.length),
                style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
              ),
              if (months.isNotEmpty)
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
    );
  }

  /// "خرداد — آبان ۱۴۰۳", or with both years when the range crosses a Jalali year.
  String _range(AppLocalizations l10n) {
    final first = months.first;
    final last = months.last;
    String year(MonthCost m) => localizeDigits('${m.jalaliYear}', l10n.localeName);
    String name(MonthCost m) => l10n.jalaliMonth('${m.jalaliMonth}');
    return first.jalaliYear == last.jalaliYear
        ? l10n.homeSpendRange(name(first), name(last), year(last))
        : l10n.homeSpendRangeAcrossYears(name(first), year(first), name(last), year(last));
  }
}

class _EmptyChart extends StatelessWidget {
  const _EmptyChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: SpendBars.height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insert_chart_outlined, size: 40, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).homeSpendEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppTones.of(context).muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ChartPalette.of(context);
    return Wrap(
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
                decoration: BoxDecoration(color: palette.colorAt(index), shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Text(
                vehicle.nickname,
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
      ],
    );
  }
}
