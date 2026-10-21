import 'package:flutter/material.dart';

import '../../../../core/theme/chart_palette.dart';
import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../dashboard/domain/entities/month_cost.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import 'format_toman.dart';

/// The box above the bars: "آبان ۱۴۰۳ (مجموع)" with the month total, then one row per vehicle
/// (series dot, nickname, cost).
class SpendMonthBreakdown extends StatelessWidget {
  const SpendMonthBreakdown({super.key, required this.month, required this.vehicles});

  final MonthCost month;

  /// Garage order; a vehicle's index is its series color.
  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = ChartPalette.of(context);
    final bold = theme.textTheme.labelMedium?.copyWith(
      fontWeight: FontWeight.w700,
      color: scheme.onSurface,
    );
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeSpendMonthTotal(
                    l10n.jalaliMonth('${month.jalaliMonth}'),
                    localizeDigits('${month.jalaliYear}', l10n.localeName),
                  ),
                  style: bold,
                ),
              ),
              Text(formatToman(month.totalCost, l10n), style: bold),
            ],
          ),
          const SizedBox(height: 4),
          Divider(height: 1, thickness: 1, color: scheme.surfaceContainerHighest),
          const SizedBox(height: 6),
          for (final cost in month.byVehicle)
            if (_indexOf(cost.vehicleId) case final index?)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: palette.colorAt(index),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        vehicles[index].nickname,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                    Text(
                      formatToman(cost.totalCost, l10n),
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  /// The garage slot of [vehicleId], or `null` for a vehicle not in the loaded garage.
  int? _indexOf(String vehicleId) {
    final index = vehicles.indexWhere((vehicle) => vehicle.id == vehicleId);
    return index < 0 ? null : index;
  }
}
