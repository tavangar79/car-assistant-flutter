import 'package:flutter/material.dart';

import '../../domain/entities/vehicle.dart';

class VehicleTile extends StatelessWidget {
  const VehicleTile({super.key, required this.vehicle});

  final Vehicle vehicle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 72,
      leading: const Icon(Icons.directions_car, size: 32),
      title: Text(vehicle.displayName),
      subtitle: Text('${vehicle.mileageKm} km'),
    );
  }
}
