import 'package:equatable/equatable.dart';

/// The profile stat tiles: vehicles in the garage and service visits across all of them.
class ProfileStats extends Equatable {
  const ProfileStats({required this.vehicleCount, required this.serviceCount});

  final int vehicleCount;
  final int serviceCount;

  @override
  List<Object?> get props => [vehicleCount, serviceCount];
}
