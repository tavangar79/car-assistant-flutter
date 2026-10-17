import 'dart:typed_data';

import 'package:car_assistant/features/vehicles/domain/entities/catalog_make.dart';
import 'package:car_assistant/features/vehicles/domain/entities/catalog_model.dart';
import 'package:car_assistant/features/vehicles/domain/entities/named_ref.dart';
import 'package:car_assistant/features/vehicles/domain/entities/plate.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_color.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle_draft.dart';

/// Shared vehicle test data. The VIN is a valid one (no I, O or Q).
const validVin = 'NAAM21CA9KK123456';

const plate = Plate(twoDigits: '72', letter: 'ب', threeDigits: '345', provinceCode: '68');

Map<String, dynamic> vehicleJson({String? photoUrl, String? color = 'white'}) => {
  'id': 'v1',
  'nickname': 'تارا اتوماتیک نقره‌ای',
  'plate': {'twoDigits': '72', 'letter': 'ب', 'threeDigits': '345', 'provinceCode': '68'},
  'vin': validVin,
  'make': {'id': 'iran-khodro', 'name': 'ایران خودرو'},
  'model': {'id': 'tara', 'name': 'تارا'},
  'trim': {'id': 'tara-v4-at', 'name': 'V4 اتوماتیک - فول آپشن'},
  'yearJalali': 1402,
  'mileageKm': 34500,
  'color': color,
  'isDefault': true,
  'photoUrl': photoUrl,
  'createdAt': '2026-10-17T10:00:00.000Z',
  'updatedAt': '2026-10-17T10:00:00.000Z',
};

const tara = Vehicle(
  id: 'v1',
  nickname: 'تارا اتوماتیک نقره‌ای',
  plate: plate,
  vin: validVin,
  make: NamedRef(id: 'iran-khodro', name: 'ایران خودرو'),
  model: NamedRef(id: 'tara', name: 'تارا'),
  trim: NamedRef(id: 'tara-v4-at', name: 'V4 اتوماتیک - فول آپشن'),
  yearJalali: 1402,
  mileageKm: 34500,
  color: VehicleColor.white,
  isDefault: true,
);

/// [tara] with another id, nickname or photo.
Vehicle taraWith({String id = 'v1', String? nickname, String? photoUrl}) => Vehicle(
  id: id,
  nickname: nickname ?? tara.nickname,
  plate: tara.plate,
  vin: tara.vin,
  make: tara.make,
  model: tara.model,
  trim: tara.trim,
  yearJalali: tara.yearJalali,
  mileageKm: tara.mileageKm,
  color: tara.color,
  isDefault: tara.isDefault,
  photoUrl: photoUrl,
);

final catalogJson = {
  'makes': [
    {
      'id': 'iran-khodro',
      'name': 'ایران خودرو',
      'models': [
        {
          'id': 'tara',
          'name': 'تارا',
          'trims': [
            {'id': 'tara-v4-at', 'name': 'V4 اتوماتیک - فول آپشن'},
          ],
        },
        {'id': 'dena-plus', 'name': 'دنا پلاس', 'trims': <Object>[]},
      ],
    },
    {
      'id': 'saipa',
      'name': 'سایپا',
      'models': [
        {'id': 'shahin', 'name': 'شاهین', 'trims': <Object>[]},
      ],
    },
  ],
};

const catalog = [
  CatalogMake(
    id: 'iran-khodro',
    name: 'ایران خودرو',
    models: [
      CatalogModel(
        id: 'tara',
        name: 'تارا',
        trims: [NamedRef(id: 'tara-v4-at', name: 'V4 اتوماتیک - فول آپشن')],
      ),
      CatalogModel(id: 'dena-plus', name: 'دنا پلاس'),
    ],
  ),
  CatalogMake(
    id: 'saipa',
    name: 'سایپا',
    models: [CatalogModel(id: 'shahin', name: 'شاهین')],
  ),
];

/// A draft that passes every rule (current Jalali year 1405).
const validDraft = VehicleDraft(
  nickname: '  تارا اتوماتیک نقره‌ای ',
  plate: plate,
  vin: 'naam21ca9kk123456',
  makeId: 'iran-khodro',
  modelId: 'tara',
  trimId: 'tara-v4-at',
  yearJalali: 1402,
  mileageKm: 34500,
  color: VehicleColor.white,
  isDefault: true,
);

/// A valid 1x1 transparent PNG.
final transparentPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, //
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);
