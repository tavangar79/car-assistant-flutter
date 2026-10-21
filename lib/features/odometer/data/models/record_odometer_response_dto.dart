import '../../../vehicles/data/models/vehicle_dto.dart';
import '../../domain/entities/odometer_update.dart';
import 'odometer_reading_dto.dart';

/// `201` body of `POST /api/vehicles/:id/odometer`: `{ reading, vehicle }`.
class RecordOdometerResponseDto {
  const RecordOdometerResponseDto({required this.reading, required this.vehicle});

  factory RecordOdometerResponseDto.fromJson(Map<String, dynamic> json) =>
      RecordOdometerResponseDto(
        reading: OdometerReadingDto.fromJson(json['reading'] as Map<String, dynamic>),
        vehicle: VehicleDto.fromJson(json['vehicle'] as Map<String, dynamic>),
      );

  final OdometerReadingDto reading;
  final VehicleDto vehicle;

  OdometerUpdate toEntity() =>
      OdometerUpdate(reading: reading.toEntity(), vehicle: vehicle.toEntity());
}
