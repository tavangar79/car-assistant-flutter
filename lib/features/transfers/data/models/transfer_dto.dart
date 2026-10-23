import '../../../vehicles/data/models/plate_dto.dart';
import '../../domain/entities/vehicle_transfer.dart';

/// JSON shape of a transfer: `{ id, vehicleId, toPhone, status, createdAt, respondedAt, vehicle,
/// fromName }`.
class TransferDto {
  const TransferDto({
    required this.id,
    required this.vehicleId,
    required this.toPhone,
    required this.status,
    required this.createdAt,
    required this.respondedAt,
    required this.vehicle,
    required this.fromName,
  });

  factory TransferDto.fromJson(Map<String, dynamic> json) => TransferDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    toPhone: json['toPhone'] as String,
    status: json['status'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
    respondedAt: switch (json['respondedAt']) {
      final String date => DateTime.parse(date),
      _ => null,
    },
    vehicle: TransferVehicleDto.fromJson(json['vehicle'] as Map<String, dynamic>),
    fromName: json['fromName'] as String?,
  );

  final String id;
  final String vehicleId;
  final String toPhone;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final TransferVehicleDto vehicle;
  final String? fromName;

  VehicleTransfer toEntity() => VehicleTransfer(
    id: id,
    vehicleId: vehicleId,
    toPhone: toPhone,
    status: TransferStatus.fromWire(status),
    createdAt: createdAt,
    respondedAt: respondedAt,
    vehicle: vehicle.toEntity(),
    fromName: fromName,
  );
}

/// The vehicle snapshot: `{ nickname, makeId, modelId, trimId, yearJalali, plate, mileageKm }`.
class TransferVehicleDto {
  const TransferVehicleDto({
    required this.nickname,
    required this.makeId,
    required this.modelId,
    required this.trimId,
    required this.yearJalali,
    required this.plate,
    required this.mileageKm,
  });

  factory TransferVehicleDto.fromJson(Map<String, dynamic> json) => TransferVehicleDto(
    nickname: json['nickname'] as String,
    makeId: json['makeId'] as String,
    modelId: json['modelId'] as String,
    trimId: json['trimId'] as String?,
    yearJalali: json['yearJalali'] as int,
    plate: PlateDto.fromJson(json['plate'] as Map<String, dynamic>),
    mileageKm: json['mileageKm'] as int,
  );

  final String nickname;
  final String makeId;
  final String modelId;
  final String? trimId;
  final int yearJalali;
  final PlateDto plate;
  final int mileageKm;

  TransferVehicle toEntity() => TransferVehicle(
    nickname: nickname,
    makeId: makeId,
    modelId: modelId,
    trimId: trimId,
    yearJalali: yearJalali,
    plate: plate.toEntity(),
    mileageKm: mileageKm,
  );
}
