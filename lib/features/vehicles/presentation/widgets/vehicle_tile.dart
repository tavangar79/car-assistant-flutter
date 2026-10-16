import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/vehicle.dart';

class VehicleTile extends StatelessWidget {
  const VehicleTile({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Plain digits without grouping, so 2021 is not shown as 2,021.
    final year = NumberFormat('0', l10n.localeName).format(vehicle.year);
    return ListTile(
      minTileHeight: 72,
      leading: const Icon(Icons.directions_car, size: 32),
      title: Text(l10n.vehicleTitle(vehicle.make, vehicle.model, year)),
      subtitle: Text(l10n.vehicleMileage(vehicle.mileageKm)),
    );
  }
}
