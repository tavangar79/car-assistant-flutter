import 'package:car_assistant/features/vehicles/domain/entities/plate.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_draft.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_failures.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_field.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_rules.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../vehicle_fixtures.dart';

void main() {
  Set<VehicleField> invalidFields(VehicleDraft draft) => VehicleRules.validate(
    draft,
    currentJalaliYear: 1405,
  ).match((failure) => failure.fields, (_) => const {});

  VehicleDraft draftWith({
    String nickname = 'تارا',
    Plate plate = plate,
    String vin = '',
    int? year = 1402,
    int? mileage = 0,
  }) => VehicleDraft(
    nickname: nickname,
    plate: plate,
    vin: vin,
    makeId: 'iran-khodro',
    modelId: 'tara',
    yearJalali: year,
    mileageKm: mileage,
  );

  test('a complete draft is valid', () {
    expect(invalidFields(validDraft), isEmpty);
  });

  test('nickname: required and at most 40 characters after trimming', () {
    expect(invalidFields(draftWith(nickname: '   ')), {VehicleField.nickname});
    expect(invalidFields(draftWith(nickname: 'a' * 41)), {VehicleField.nickname});
    expect(invalidFields(draftWith(nickname: ' ${'a' * 40} ')), isEmpty);
  });

  test('plate: 2 digits, a known letter, 3 digits and a 2-digit province code', () {
    Plate p({String two = '72', String letter = 'ب', String three = '345', String code = '68'}) =>
        Plate(twoDigits: two, letter: letter, threeDigits: three, provinceCode: code);

    expect(VehicleRules.isValidPlate(p()), isTrue);
    expect(VehicleRules.isValidPlate(p(letter: '♿')), isTrue);
    expect(VehicleRules.isValidPlate(p(two: '7')), isFalse);
    expect(VehicleRules.isValidPlate(p(letter: '')), isFalse);
    expect(VehicleRules.isValidPlate(p(letter: 'x')), isFalse);
    expect(VehicleRules.isValidPlate(p(three: '34')), isFalse);
    expect(VehicleRules.isValidPlate(p(code: '۶۸')), isFalse); // digits must be Latin
    expect(invalidFields(draftWith(plate: p(code: ''))), {VehicleField.plate});
  });

  test('VIN: optional, otherwise 17 characters without I, O or Q', () {
    expect(VehicleRules.isValidVin(''), isTrue);
    expect(VehicleRules.isValidVin(validVin), isTrue);
    expect(VehicleRules.isValidVin(validVin.toLowerCase()), isTrue);
    expect(VehicleRules.isValidVin('IRIK9021484839211'), isFalse);
    expect(VehicleRules.isValidVin('NAAM21CA9KK12345'), isFalse);
  });

  test('year: 1300 up to next Jalali year', () {
    expect(invalidFields(draftWith(year: null)), {VehicleField.year});
    expect(invalidFields(draftWith(year: 1299)), {VehicleField.year});
    expect(invalidFields(draftWith(year: 1300)), isEmpty);
    expect(invalidFields(draftWith(year: 1406)), isEmpty);
    expect(invalidFields(draftWith(year: 1407)), {VehicleField.year});
  });

  test('mileage: 0 up to 2,000,000 km', () {
    expect(invalidFields(draftWith(mileage: null)), {VehicleField.mileage});
    expect(invalidFields(draftWith(mileage: 2000000)), isEmpty);
    expect(invalidFields(draftWith(mileage: 2000001)), {VehicleField.mileage});
  });

  test('builds the vehicle to send', () {
    final vehicle = VehicleRules.validate(
      draftWith(nickname: ' تارا ', vin: ' naam21ca9kk123456 '),
      currentJalaliYear: 1405,
    ).getOrElse((f) => throw f);

    expect(vehicle.nickname, 'تارا');
    expect(vehicle.vin, validVin);
    expect(vehicle.trimId, isNull);
  });

  test('an empty VIN is sent as null', () {
    final vehicle = VehicleRules.validate(
      draftWith(),
      currentJalaliYear: 1405,
    ).getOrElse((f) => throw f);

    expect(vehicle.vin, isNull);
  });

  test('InvalidVehicleFailure compares by fields', () {
    expect(
      const InvalidVehicleFailure({VehicleField.plate}),
      const InvalidVehicleFailure({VehicleField.plate}),
    );
  });
}
