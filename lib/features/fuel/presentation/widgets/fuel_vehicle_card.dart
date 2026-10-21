import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/fuel_log.dart';
import '../../../services/presentation/widgets/wizard/wizard_card.dart';

/// The active vehicle at the top of the fuel page: a 40px car tile, the nickname and the
/// "آخرین سوخت‌گیری" line built from the newest [lastLog] (or that there is none yet).
class FuelVehicleCard extends StatelessWidget {
  const FuelVehicleCard({super.key, required this.vehicle, required this.lastLog});

  final Vehicle vehicle;
  final FuelLog? lastLog;

  /// The last fill-up line as shown under the nickname.
  static String lastFillLabel(FuelLog? log, AppLocalizations l10n) {
    if (log == null) return l10n.fuelNoLastFill;
    final date = formatJalaliDate(log.fueledAt.toLocal(), l10n);
    return log.isFullFill
        ? l10n.fuelLastFillFull(date, log.odometerKm)
        : l10n.fuelLastFillPartial(date, log.odometerKm);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return WizardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.directions_car, size: 22, color: scheme.onSurface),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  vehicle.nickname,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.history, size: 15, color: scheme.tertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  lastFillLabel(lastLog, l10n),
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
