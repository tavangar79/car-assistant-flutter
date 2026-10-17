import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import 'vehicle.dart';

/// The saved [vehicle]. [photoFailure] is set when the vehicle was saved but its photo was not.
class AddVehicleResult extends Equatable {
  const AddVehicleResult(this.vehicle, {this.photoFailure});

  final Vehicle vehicle;
  final Failure? photoFailure;

  @override
  List<Object?> get props => [vehicle, photoFailure];
}
