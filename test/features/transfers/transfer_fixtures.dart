import 'package:car_assistant/features/transfers/domain/entities/vehicle_transfer.dart';
import 'package:car_assistant/features/vehicles/domain/entities/plate.dart';

/// Shared transfer test data: the contract sample, a pending transfer of `v1`.

Map<String, dynamic> transferJson({String id = 't1', String? fromName = 'علی رضایی'}) => {
  'id': id,
  'vehicleId': 'v1',
  'toPhone': '09121234567',
  'status': 'pending',
  'createdAt': '2024-11-15T08:00:00.000Z',
  'respondedAt': null,
  'vehicle': {
    'nickname': 'تارا اتوماتیک',
    'makeId': 'iran-khodro',
    'modelId': 'tara',
    'trimId': null,
    'yearJalali': 1402,
    'plate': {'twoDigits': '72', 'letter': 'ی', 'threeDigits': '345', 'provinceCode': '68'},
    'mileageKm': 42300,
  },
  'fromName': fromName,
};

VehicleTransfer transfer({String id = 't1', String? fromName = 'علی رضایی'}) => VehicleTransfer(
  id: id,
  vehicleId: 'v1',
  toPhone: '09121234567',
  status: TransferStatus.pending,
  createdAt: DateTime.utc(2024, 11, 15, 8),
  vehicle: const TransferVehicle(
    nickname: 'تارا اتوماتیک',
    makeId: 'iran-khodro',
    modelId: 'tara',
    yearJalali: 1402,
    plate: Plate(twoDigits: '72', letter: 'ی', threeDigits: '345', provinceCode: '68'),
    mileageKm: 42300,
  ),
  fromName: fromName,
);
