import 'package:car_assistant/features/fuel/data/models/create_fuel_log_request_dto.dart';
import 'package:car_assistant/features/fuel/data/models/fuel_log_dto.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_payment_method.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';
import 'package:car_assistant/features/fuel/domain/entities/new_fuel_log.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fuel_fixtures.dart';

void main() {
  test('FuelLogDto parses the contract payload', () {
    expect(FuelLogDto.fromJson(fuelLogJson()).toEntity(), contractFuelLog());
  });

  test('FuelLogDto accepts a null economy, an integer volume and absent optionals', () {
    final json = fuelLogJson(economy: null)
      ..['volume'] = 40
      ..['station'] = null
      ..['paymentMethod'] = null
      ..['notes'] = null;

    final log = FuelLogDto.fromJson(json).toEntity();

    expect(log.economy, isNull);
    expect(log.volume, 40.0);
    expect(log.station, isNull);
    expect(log.paymentMethod, isNull);
    expect(log.notes, isNull);
  });

  test('CreateFuelLogRequestDto sends the contract body with a UTC date and nulls', () {
    final local = DateTime.utc(2025, 11, 15, 13, 12).toLocal();
    final dto = CreateFuelLogRequestDto(
      NewFuelLog(
        fueledAt: local,
        odometerKm: 34850,
        fuelType: FuelType.superGrade,
        volume: 48.5,
        totalCost: 145500,
        isFullFill: true,
        station: 'جایگاه اختصاصی ۲۴ یادگار امام (تهران)',
        paymentMethod: FuelPaymentMethod.personalFuelCard,
      ),
    );

    expect(dto.toJson(), {
      'fueledAt': '2025-11-15T13:12:00.000Z',
      'odometerKm': 34850,
      'fuelType': 'super',
      'volume': 48.5,
      'totalCost': 145500,
      'isFullFill': true,
      'station': 'جایگاه اختصاصی ۲۴ یادگار امام (تهران)',
      'paymentMethod': 'personal_fuel_card',
      'notes': null,
    });
  });

  test('the enums round-trip their wire values', () {
    for (final type in FuelType.values) {
      expect(FuelType.fromWire(type.wire), type);
    }
    for (final method in FuelPaymentMethod.values) {
      expect(FuelPaymentMethod.fromWire(method.wire), method);
    }
    expect(FuelType.superGrade.wire, 'super');
  });
}
