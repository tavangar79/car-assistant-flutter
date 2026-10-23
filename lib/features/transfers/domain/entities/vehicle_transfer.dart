import 'package:equatable/equatable.dart';

import '../../../vehicles/domain/entities/plate.dart';

/// The state of an ownership transfer request.
enum TransferStatus {
  pending,
  accepted,
  rejected,
  cancelled;

  static TransferStatus fromWire(String wire) => values.byName(wire);
}

/// The vehicle as it was when the transfer was read (the buyer cannot load the vehicle itself
/// before accepting).
class TransferVehicle extends Equatable {
  const TransferVehicle({
    required this.nickname,
    required this.makeId,
    required this.modelId,
    required this.yearJalali,
    required this.plate,
    required this.mileageKm,
    this.trimId,
  });

  final String nickname;
  final String makeId;
  final String modelId;
  final String? trimId;
  final int yearJalali;
  final Plate plate;
  final int mileageKm;

  @override
  List<Object?> get props => [nickname, makeId, modelId, trimId, yearJalali, plate, mileageKm];
}

/// A request to move a vehicle to the owner of [toPhone]. It moves only when the buyer accepts.
class VehicleTransfer extends Equatable {
  const VehicleTransfer({
    required this.id,
    required this.vehicleId,
    required this.toPhone,
    required this.status,
    required this.createdAt,
    required this.vehicle,
    this.respondedAt,
    this.fromName,
  });

  final String id;
  final String vehicleId;

  /// `09xxxxxxxxx`.
  final String toPhone;
  final TransferStatus status;
  final DateTime createdAt;
  final DateTime? respondedAt;
  final TransferVehicle vehicle;

  /// The seller's name, or `null` when they have not set one.
  final String? fromName;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    toPhone,
    status,
    createdAt,
    respondedAt,
    vehicle,
    fromName,
  ];
}

/// The caller's pending transfers, newest first: [incoming] to their phone, [outgoing] from them.
class TransferList extends Equatable {
  const TransferList({this.incoming = const [], this.outgoing = const []});

  final List<VehicleTransfer> incoming;
  final List<VehicleTransfer> outgoing;

  /// The pending outgoing transfer of [vehicleId], if any.
  VehicleTransfer? outgoingFor(String vehicleId) =>
      outgoing.where((transfer) => transfer.vehicleId == vehicleId).firstOrNull;

  @override
  List<Object?> get props => [incoming, outgoing];
}
