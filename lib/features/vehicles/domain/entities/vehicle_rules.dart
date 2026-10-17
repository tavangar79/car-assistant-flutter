import 'package:fpdart/fpdart.dart';

import 'new_vehicle.dart';
import 'plate.dart';
import 'vehicle_draft.dart';
import 'vehicle_failures.dart';
import 'vehicle_field.dart';

/// The backend's vehicle rules, checked before sending so the user gets instant feedback.
abstract final class VehicleRules {
  static const nicknameMaxLength = 40;
  static const vinLength = 17;
  static const minYear = 1300;
  static const maxMileageKm = 2000000;

  static final _twoDigits = RegExp(r'^\d{2}$');
  static final _threeDigits = RegExp(r'^\d{3}$');
  static final _vin = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');

  /// The newest model year allowed: next Jalali year.
  static int maxYear(int currentJalaliYear) => currentJalaliYear + 1;

  static bool isValidPlate(Plate plate) =>
      _twoDigits.hasMatch(plate.twoDigits) &&
      Plate.letters.contains(plate.letter) &&
      _threeDigits.hasMatch(plate.threeDigits) &&
      _twoDigits.hasMatch(plate.provinceCode);

  /// An empty VIN is fine (it is optional); otherwise 17 characters without I, O or Q.
  static bool isValidVin(String vin) {
    final value = vin.trim().toUpperCase();
    return value.isEmpty || _vin.hasMatch(value);
  }

  /// Checks [draft]; on success returns the [NewVehicle] to send.
  static Either<InvalidVehicleFailure, NewVehicle> validate(
    VehicleDraft draft, {
    required int currentJalaliYear,
  }) {
    final nickname = draft.nickname.trim();
    final vin = draft.vin.trim().toUpperCase();
    final year = draft.yearJalali;
    final mileage = draft.mileageKm;
    final invalid = {
      if (nickname.isEmpty || nickname.length > nicknameMaxLength) VehicleField.nickname,
      if (!isValidPlate(draft.plate)) VehicleField.plate,
      if (!isValidVin(vin)) VehicleField.vin,
      if (draft.makeId == null) VehicleField.make,
      if (draft.modelId == null) VehicleField.model,
      if (year == null || year < minYear || year > maxYear(currentJalaliYear)) VehicleField.year,
      if (mileage == null || mileage < 0 || mileage > maxMileageKm) VehicleField.mileage,
    };
    if (invalid.isNotEmpty) return Left(InvalidVehicleFailure(invalid));
    return Right(
      NewVehicle(
        nickname: nickname,
        plate: draft.plate,
        vin: vin.isEmpty ? null : vin,
        makeId: draft.makeId!,
        modelId: draft.modelId!,
        trimId: draft.trimId,
        yearJalali: year!,
        mileageKm: mileage!,
        color: draft.color,
        isDefault: draft.isDefault,
      ),
    );
  }
}
