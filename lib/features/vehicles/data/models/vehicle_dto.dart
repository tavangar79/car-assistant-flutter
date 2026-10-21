import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_color.dart';
import 'named_ref_dto.dart';
import 'plate_dto.dart';

/// JSON shape of a vehicle as returned by the backend API.
class VehicleDto {
  const VehicleDto({
    required this.id,
    required this.nickname,
    required this.plate,
    required this.vin,
    required this.make,
    required this.model,
    required this.trim,
    required this.yearJalali,
    required this.mileageKm,
    required this.color,
    required this.isDefault,
    required this.photoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
    id: json['id'] as String,
    nickname: json['nickname'] as String,
    plate: PlateDto.fromJson(json['plate'] as Map<String, dynamic>),
    vin: json['vin'] as String?,
    make: NamedRefDto.fromJson(json['make'] as Map<String, dynamic>),
    model: NamedRefDto.fromJson(json['model'] as Map<String, dynamic>),
    trim: switch (json['trim']) {
      final Map<String, dynamic> trim => NamedRefDto.fromJson(trim),
      _ => null,
    },
    yearJalali: json['yearJalali'] as int,
    mileageKm: json['mileageKm'] as int,
    color: json['color'] as String?,
    isDefault: json['isDefault'] as bool,
    photoUrl: json['photoUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  final String id;
  final String nickname;
  final PlateDto plate;
  final String? vin;
  final NamedRefDto make;
  final NamedRefDto model;
  final NamedRefDto? trim;
  final int yearJalali;
  final int mileageKm;

  /// One of `white | black | silver | blue | red | beige`, or `null`.
  final String? color;
  final bool isDefault;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Vehicle toEntity() => Vehicle(
    id: id,
    nickname: nickname,
    plate: plate.toEntity(),
    vin: vin,
    make: make.toEntity(),
    model: model.toEntity(),
    trim: trim?.toEntity(),
    yearJalali: yearJalali,
    mileageKm: mileageKm,
    // An unknown colour (e.g. one added on the server later) is shown as "no colour".
    color: VehicleColor.values.asNameMap()[color],
    isDefault: isDefault,
    photoUrl: photoUrl,
    createdAt: createdAt,
  );
}
