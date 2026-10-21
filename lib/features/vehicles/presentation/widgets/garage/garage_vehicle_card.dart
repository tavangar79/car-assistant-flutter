import 'package:flutter/material.dart';

import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle.dart';
import '../vehicle_details/plate_badge.dart';
import '../vehicle_options_menu.dart';
import 'default_vehicle_chip.dart';
import 'garage_card.dart';
import 'service_status_banner.dart';
import 'vehicle_card_actions.dart';
import 'vehicle_odometer_row.dart';

/// One vehicle in the garage (Stitch "گاراژ من" `7e67f2261e4548858c5f8fc227a781d9`): default badge
/// or "set as default", the options menu, nickname and plate, the odometer, the service status and
/// three shortcuts. Tapping the card opens the vehicle ([onOpen]).
class GarageVehicleCard extends StatelessWidget {
  const GarageVehicleCard({
    super.key,
    required this.vehicle,
    required this.onOpen,
    required this.onEdit,
    required this.onSetDefault,
    required this.onUpdateOdometer,
  });

  final Vehicle vehicle;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onUpdateOdometer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final summary = [
      l10n.vehicleDetailsModelYear(localizeDigits('${vehicle.yearJalali}', l10n.localeName)),
      vehicle.make.name,
      vehicle.model.name,
      ?vehicle.trim?.name,
    ].join(' • ');
    const gap = SizedBox(height: 14);
    return GarageCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              DefaultVehicleChip(isDefault: vehicle.isDefault, onSetDefault: onSetDefault),
              const Spacer(),
              VehicleOptionsMenu(onEdit: onEdit),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.nickname,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headlineMedium?.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary,
                      style: theme.textTheme.bodySmall?.copyWith(color: scheme.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              PlateBadge(plate: vehicle.plate, dense: true),
            ],
          ),
          gap,
          VehicleOdometerRow(vehicle: vehicle),
          gap,
          const ServiceStatusBanner(),
          gap,
          VehicleCardActions(onUpdateOdometer: onUpdateOdometer),
        ],
      ),
    );
  }
}
