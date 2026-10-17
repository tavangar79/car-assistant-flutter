import '../../domain/entities/new_vehicle.dart';
import 'plate_dto.dart';

/// JSON body of `POST /api/vehicles`.
class CreateVehicleRequestDto {
  const CreateVehicleRequestDto(this._vehicle);

  final NewVehicle _vehicle;

  Map<String, dynamic> toJson() => {
    'nickname': _vehicle.nickname,
    'plate': PlateDto.fromEntity(_vehicle.plate).toJson(),
    'vin': _vehicle.vin,
    'makeId': _vehicle.makeId,
    'modelId': _vehicle.modelId,
    'trimId': _vehicle.trimId,
    'yearJalali': _vehicle.yearJalali,
    'mileageKm': _vehicle.mileageKm,
    'color': _vehicle.color?.name,
    'isDefault': _vehicle.isDefault,
  };
}
