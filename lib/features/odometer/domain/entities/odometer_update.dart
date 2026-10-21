import 'package:equatable/equatable.dart';

import '../../../vehicles/domain/entities/vehicle.dart';
import 'odometer_reading.dart';

/// A saved reading and the vehicle with its new `mileageKm`.
class OdometerUpdate extends Equatable {
  const OdometerUpdate({required this.reading, required this.vehicle});

  final OdometerReading reading;
  final Vehicle vehicle;

  @override
  List<Object?> get props => [reading, vehicle];
}
