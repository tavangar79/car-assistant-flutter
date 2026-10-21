import 'package:flutter/material.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/widgets/vehicle_details/plate_badge.dart';

/// "Active vehicle context ribbon" of the history page: the one shown vehicle with its model
/// year, mileage and plate; with several vehicles, how many are shown.
class HistoryVehicleRibbon extends StatelessWidget {
  const HistoryVehicleRibbon({super.key, required this.vehicles, required this.allVehicles});

  /// The shown vehicles.
  final List<Vehicle> vehicles;

  /// Whether every vehicle of the garage is shown.
  final bool allVehicles;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final single = vehicles.length == 1 ? vehicles.single : null;
    final title = switch (single) {
      final vehicle? => vehicle.nickname,
      null when allVehicles => l10n.historyGarageTitle,
      null => l10n.historySelectedTitle(vehicles.length),
    };
    final subtitle = switch (single) {
      final vehicle? => l10n.historyVehicleMeta(
        localizeDigits('${vehicle.yearJalali}', l10n.localeName),
        vehicle.mileageKm,
      ),
      null => l10n.historyGarageMeta(vehicles.length),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                ),
              ],
            ),
          ),
          if (single != null) ...[
            const SizedBox(width: 8),
            PlateBadge(plate: single.plate, dense: true),
          ],
        ],
      ),
    );
  }
}
