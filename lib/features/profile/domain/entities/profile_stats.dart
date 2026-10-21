import 'package:equatable/equatable.dart';

/// The profile stat tiles: vehicles in the garage, and service visits and wallet documents across
/// all of them.
class ProfileStats extends Equatable {
  const ProfileStats({
    required this.vehicleCount,
    required this.serviceCount,
    required this.documentCount,
  });

  final int vehicleCount;
  final int serviceCount;
  final int documentCount;

  @override
  List<Object?> get props => [vehicleCount, serviceCount, documentCount];
}
