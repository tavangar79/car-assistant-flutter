import '../../domain/entities/vehicle.dart';

/// JSON shape of a vehicle as returned by the backend API.
class VehicleDto {
  const VehicleDto({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.mileageKm,
  });

  factory VehicleDto.fromJson(Map<String, dynamic> json) => VehicleDto(
    id: json['id'] as String,
    make: json['make'] as String,
    model: json['model'] as String,
    year: json['year'] as int,
    mileageKm: json['mileageKm'] as int,
  );

  final String id;
  final String make;
  final String model;
  final int year;
  final int mileageKm;

  Vehicle toEntity() => Vehicle(id: id, make: make, model: model, year: year, mileageKm: mileageKm);
}
