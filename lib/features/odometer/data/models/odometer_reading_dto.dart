import '../../domain/entities/odometer_reading.dart';

/// JSON shape of an odometer reading: `{ id, vehicleId, mileageKm, recordedAt, createdAt }`.
class OdometerReadingDto {
  const OdometerReadingDto({
    required this.id,
    required this.vehicleId,
    required this.mileageKm,
    required this.recordedAt,
    required this.createdAt,
  });

  factory OdometerReadingDto.fromJson(Map<String, dynamic> json) => OdometerReadingDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    mileageKm: json['mileageKm'] as int,
    recordedAt: DateTime.parse(json['recordedAt'] as String),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  final String id;
  final String vehicleId;
  final int mileageKm;
  final DateTime recordedAt;
  final DateTime createdAt;

  OdometerReading toEntity() => OdometerReading(
    id: id,
    vehicleId: vehicleId,
    mileageKm: mileageKm,
    recordedAt: recordedAt,
    createdAt: createdAt,
  );
}
