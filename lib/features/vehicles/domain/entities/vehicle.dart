import 'package:equatable/equatable.dart';

import 'named_ref.dart';
import 'plate.dart';
import 'vehicle_color.dart';

/// A vehicle in the user's garage.
class Vehicle extends Equatable {
  const Vehicle({
    required this.id,
    required this.nickname,
    required this.plate,
    required this.make,
    required this.model,
    required this.yearJalali,
    required this.mileageKm,
    this.vin,
    this.trim,
    this.color,
    this.isDefault = false,
    this.photoUrl,
    this.createdAt,
    this.ownedSince,
  });

  final String id;
  final String nickname;
  final Plate plate;
  final String? vin;
  final NamedRef make;
  final NamedRef model;
  final NamedRef? trim;
  final int yearJalali;
  final int mileageKm;
  final VehicleColor? color;
  final bool isDefault;

  /// Relative path of the photo (loading it needs the bearer token), or `null` when there is none.
  final String? photoUrl;

  /// When the vehicle was added (the start of its history), or `null` when unknown. Informational
  /// only, so it is left out of equality.
  final DateTime? createdAt;

  /// When the current owner got the vehicle by an ownership transfer, or `null` when they added
  /// it. Records created before it are locked. Informational only, so it is left out of equality.
  final DateTime? ownedSince;

  @override
  List<Object?> get props => [
    id,
    nickname,
    plate,
    vin,
    make,
    model,
    trim,
    yearJalali,
    mileageKm,
    color,
    isDefault,
    photoUrl,
  ];
}
