import 'package:car_assistant/features/odometer/data/models/odometer_reading_dto.dart';
import 'package:car_assistant/features/odometer/data/models/record_odometer_request_dto.dart';
import 'package:car_assistant/features/odometer/data/models/record_odometer_response_dto.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_update.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../odometer_fixtures.dart';

void main() {
  test('OdometerReadingDto parses a reading', () {
    expect(OdometerReadingDto.fromJson(readingJson()).toEntity(), reading);
  });

  test('RecordOdometerResponseDto parses the reading and the vehicle', () {
    final dto = RecordOdometerResponseDto.fromJson({
      'reading': readingJson(),
      'vehicle': vehicleJson(),
    });

    expect(dto.toEntity(), OdometerUpdate(reading: reading, vehicle: tara));
  });

  group('RecordOdometerRequestDto', () {
    test('sends only the mileage when there is no date', () {
      expect(const RecordOdometerRequestDto(mileageKm: 34850).toJson(), {'mileageKm': 34850});
    });

    test('sends the date as ISO-8601 UTC', () {
      final local = DateTime.utc(2026, 10, 20, 15, 15).toLocal();

      expect(RecordOdometerRequestDto(mileageKm: 34850, recordedAt: local).toJson(), {
        'mileageKm': 34850,
        'recordedAt': '2026-10-20T15:15:00.000Z',
      });
    });
  });
}
