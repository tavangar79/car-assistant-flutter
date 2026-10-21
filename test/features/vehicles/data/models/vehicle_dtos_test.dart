import 'package:car_assistant/features/vehicles/data/models/create_vehicle_request_dto.dart';
import 'package:car_assistant/features/vehicles/data/models/vehicle_catalog_dto.dart';
import 'package:car_assistant/features/vehicles/data/models/vehicle_dto.dart';
import 'package:car_assistant/features/vehicles/domain/entities/new_vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_color.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../vehicle_fixtures.dart';

void main() {
  group('VehicleDto', () {
    test('parses the full contract shape', () {
      final dto = VehicleDto.fromJson(vehicleJson());

      expect(dto.toEntity(), tara);
      expect(dto.createdAt, DateTime.utc(2026, 10, 17, 10));
      expect(dto.updatedAt, DateTime.utc(2026, 10, 17, 10));
      expect(dto.toEntity().createdAt, DateTime.utc(2026, 10, 17, 10));
      expect(
        VehicleDto.fromJson(vehicleJson(photoUrl: '/api/vehicles/v1/photo?v=1')).photoUrl,
        '/api/vehicles/v1/photo?v=1',
      );
    });

    test('accepts null vin, trim, color and photoUrl', () {
      final json = vehicleJson(color: null)
        ..['vin'] = null
        ..['trim'] = null;

      final vehicle = VehicleDto.fromJson(json).toEntity();

      expect(vehicle.vin, isNull);
      expect(vehicle.trim, isNull);
      expect(vehicle.color, isNull);
      expect(vehicle.photoUrl, isNull);
    });

    test('maps every colour name, and an unknown one to null', () {
      for (final color in VehicleColor.values) {
        expect(VehicleDto.fromJson(vehicleJson(color: color.name)).toEntity().color, color);
      }
      expect(VehicleDto.fromJson(vehicleJson(color: 'purple')).toEntity().color, isNull);
    });
  });

  test('VehicleCatalogDto parses makes, models and trims', () {
    expect(VehicleCatalogDto.fromJson(catalogJson).toEntity(), catalog);
  });

  group('CreateVehicleRequestDto', () {
    test('writes the POST body of the contract', () {
      const vehicle = NewVehicle(
        nickname: 'تارا',
        plate: plate,
        vin: validVin,
        makeId: 'iran-khodro',
        modelId: 'tara',
        trimId: 'tara-v4-at',
        yearJalali: 1402,
        mileageKm: 34500,
        color: VehicleColor.white,
        isDefault: true,
      );

      expect(const CreateVehicleRequestDto(vehicle).toJson(), {
        'nickname': 'تارا',
        'plate': {'twoDigits': '72', 'letter': 'ب', 'threeDigits': '345', 'provinceCode': '68'},
        'vin': validVin,
        'makeId': 'iran-khodro',
        'modelId': 'tara',
        'trimId': 'tara-v4-at',
        'yearJalali': 1402,
        'mileageKm': 34500,
        'color': 'white',
        'isDefault': true,
      });
    });

    test('sends null for the empty optional fields', () {
      const vehicle = NewVehicle(
        nickname: 'تارا',
        plate: plate,
        makeId: 'iran-khodro',
        modelId: 'tara',
        yearJalali: 1402,
        mileageKm: 0,
      );

      final json = const CreateVehicleRequestDto(vehicle).toJson();

      expect(json['vin'], isNull);
      expect(json['trimId'], isNull);
      expect(json['color'], isNull);
      expect(json['isDefault'], isFalse);
    });
  });
}
