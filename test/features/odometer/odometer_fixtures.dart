import 'package:car_assistant/features/odometer/domain/entities/odometer_reading.dart';

/// Shared odometer test data, for vehicle `v1` (`tara` in the vehicle fixtures).
Map<String, dynamic> readingJson({int mileageKm = 34850}) => {
  'id': 'r1',
  'vehicleId': 'v1',
  'mileageKm': mileageKm,
  'recordedAt': '2026-10-20T15:15:00.000Z',
  'createdAt': '2026-10-20T15:16:00.000Z',
};

final reading = OdometerReading(
  id: 'r1',
  vehicleId: 'v1',
  mileageKm: 34850,
  recordedAt: DateTime.utc(2026, 10, 20, 15, 15),
  createdAt: DateTime.utc(2026, 10, 20, 15, 16),
);
