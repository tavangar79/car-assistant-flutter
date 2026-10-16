import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.mileageKm,
  });

  final String id;
  final String make;
  final String model;
  final int year;
  final int mileageKm;

  String get displayName => '$year $make $model';

  @override
  List<Object?> get props => [id, make, model, year, mileageKm];
}
