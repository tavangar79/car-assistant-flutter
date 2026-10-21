import 'package:equatable/equatable.dart';

/// One odometer reading of a vehicle: [mileageKm] as read at [recordedAt].
class OdometerReading extends Equatable {
  const OdometerReading({
    required this.id,
    required this.vehicleId,
    required this.mileageKm,
    required this.recordedAt,
    required this.createdAt,
  });

  final String id;
  final String vehicleId;
  final int mileageKm;

  /// When the odometer showed [mileageKm] (UTC).
  final DateTime recordedAt;

  /// When the reading was saved (UTC).
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, vehicleId, mileageKm, recordedAt, createdAt];
}
