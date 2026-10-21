import 'package:car_assistant/features/fuel/domain/entities/fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_payment_method.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';

/// Shared fuel test data, for vehicle `v1` (`tara` in the vehicle fixtures).

/// The fuel log JSON of the contract.
Map<String, dynamic> fuelLogJson({double? economy = 7.46}) => {
  'id': 'f1',
  'vehicleId': 'v1',
  'fueledAt': '2025-11-15T13:12:00.000Z',
  'odometerKm': 34850,
  'fuelType': 'super',
  'volume': 48.5,
  'totalCost': 145500,
  'isFullFill': true,
  'station': 'جایگاه اختصاصی ۲۴ یادگار امام (تهران)',
  'paymentMethod': 'personal_fuel_card',
  'notes': 'استفاده از اکتان بوستر کاسپین (۱ عدد)',
  'economy': economy,
  'createdAt': '2025-11-15T13:20:00.000Z',
  'updatedAt': '2025-11-15T13:20:00.000Z',
};

FuelLog contractFuelLog({double? economy = 7.46}) => FuelLog(
  id: 'f1',
  vehicleId: 'v1',
  fueledAt: DateTime.utc(2025, 11, 15, 13, 12),
  odometerKm: 34850,
  fuelType: FuelType.superGrade,
  volume: 48.5,
  totalCost: 145500,
  isFullFill: true,
  station: 'جایگاه اختصاصی ۲۴ یادگار امام (تهران)',
  paymentMethod: FuelPaymentMethod.personalFuelCard,
  notes: 'استفاده از اکتان بوستر کاسپین (۱ عدد)',
  economy: economy,
  createdAt: DateTime.utc(2025, 11, 15, 13, 20),
  updatedAt: DateTime.utc(2025, 11, 15, 13, 20),
);

/// A minimal saved fill-up, for the economy and widget tests.
FuelLog fuelLog({
  String id = 'f0',
  required int odometerKm,
  FuelType fuelType = FuelType.regular,
  double volume = 40,
  bool isFullFill = true,
  DateTime? fueledAt,
  double? economy,
}) => FuelLog(
  id: id,
  vehicleId: 'v1',
  fueledAt: fueledAt ?? DateTime.utc(2026, 10, 1, 10),
  odometerKm: odometerKm,
  fuelType: fuelType,
  volume: volume,
  totalCost: 120000,
  isFullFill: isFullFill,
  economy: economy,
  createdAt: DateTime.utc(2026, 10, 1, 10, 5),
  updatedAt: DateTime.utc(2026, 10, 1, 10, 5),
);
