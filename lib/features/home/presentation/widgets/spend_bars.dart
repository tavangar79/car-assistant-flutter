import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/chart_palette.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/domain/entities/month_cost.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import 'format_toman.dart';

/// One stacked bar per month, oldest first (on the right in RTL). Each bar stacks the vehicles in
/// garage order from the top, scaled to the most expensive month. Tapping a bar selects it.
class SpendBars extends StatelessWidget {
  const SpendBars({
    super.key,
    required this.months,
    required this.vehicles,
    required this.selected,
    required this.onSelect,
  });

  /// The chart area height (Stitch `h-44`).
  static const double height = 176;

  final List<MonthCost> months;

  /// Garage order; a vehicle's index is its series color.
  final List<Vehicle> vehicles;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final maxTotal = months.map((month) => month.totalCost).fold(0, math.max);
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final (index, month) in months.indexed)
              Expanded(
                child: Semantics(
                  button: true,
                  selected: index == selected,
                  label:
                      '${l10n.homeSpendMonthTotal(l10n.jalaliMonth('${month.jalaliMonth}'), localizeDigits('${month.jalaliYear}', l10n.localeName))} '
                      '${formatToman(month.totalCost, l10n)}',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: () => onSelect(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: _Bar(month: month, vehicles: vehicles, maxTotal: maxTotal),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A 20px column of vehicle segments with 2px gaps; the top one has rounded corners.
class _Bar extends StatelessWidget {
  const _Bar({required this.month, required this.vehicles, required this.maxTotal});

  final MonthCost month;
  final List<Vehicle> vehicles;
  final int maxTotal;

  /// Leaves a little room above the tallest bar.
  static const double _maxBarHeight = SpendBars.height - 8;
  static const double _gap = 2;

  @override
  Widget build(BuildContext context) {
    final palette = ChartPalette.of(context);
    final segments = [
      for (final cost in month.byVehicle)
        if (cost.totalCost > 0)
          if (vehicles.indexWhere((vehicle) => vehicle.id == cost.vehicleId) case final index
              when index >= 0)
            (index: index, cost: cost.totalCost),
    ];
    if (segments.isEmpty || maxTotal == 0) return const SizedBox(width: 20);
    final gaps = _gap * (segments.length - 1);
    final scale = (_maxBarHeight - gaps) / maxTotal;
    return SizedBox(
      width: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (position, segment) in segments.indexed) ...[
            if (position > 0) const SizedBox(height: _gap),
            Container(
              height: math.max(segment.cost * scale, 1),
              decoration: BoxDecoration(
                color: palette.colorAt(segment.index),
                borderRadius: position == 0
                    ? const BorderRadius.vertical(top: Radius.circular(4))
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
