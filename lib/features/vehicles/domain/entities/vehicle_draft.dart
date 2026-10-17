import 'package:equatable/equatable.dart';

import 'plate.dart';
import 'vehicle_color.dart';

/// What the vehicle form holds before it is checked: free text, and choices that may still be
/// missing. Digits are Latin. `VehicleRules.validate` turns it into a `NewVehicle`.
class VehicleDraft extends Equatable {
  const VehicleDraft({
    required this.nickname,
    required this.plate,
    this.vin = '',
    this.makeId,
    this.modelId,
    this.trimId,
    this.yearJalali,
    this.mileageKm,
    this.color,
    this.isDefault = false,
  });

  final String nickname;
  final Plate plate;
  final String vin;
  final String? makeId;
  final String? modelId;
  final String? trimId;
  final int? yearJalali;
  final int? mileageKm;
  final VehicleColor? color;
  final bool isDefault;

  @override
  List<Object?> get props => [
    nickname,
    plate,
    vin,
    makeId,
    modelId,
    trimId,
    yearJalali,
    mileageKm,
    color,
    isDefault,
  ];
}
