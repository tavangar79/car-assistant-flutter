import 'package:equatable/equatable.dart';

import 'plate.dart';
import 'vehicle_color.dart';

/// A checked vehicle, ready to be sent: nickname trimmed, VIN uppercased (or `null`).
class NewVehicle extends Equatable {
  const NewVehicle({
    required this.nickname,
    required this.plate,
    required this.makeId,
    required this.modelId,
    required this.yearJalali,
    required this.mileageKm,
    this.vin,
    this.trimId,
    this.color,
    this.isDefault = false,
  });

  final String nickname;
  final Plate plate;
  final String? vin;
  final String makeId;
  final String modelId;
  final String? trimId;
  final int yearJalali;
  final int mileageKm;
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
