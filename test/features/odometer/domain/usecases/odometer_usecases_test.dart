import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_failures.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_update.dart';
import 'package:car_assistant/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:car_assistant/features/odometer/domain/usecases/get_odometer_readings.dart';
import 'package:car_assistant/features/odometer/domain/usecases/record_odometer_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../odometer_fixtures.dart';

class MockOdometerRepository extends Mock implements OdometerRepository {}

void main() {
  late MockOdometerRepository repository;
  late RecordOdometerReading record;

  setUp(() {
    repository = MockOdometerRepository();
    record = RecordOdometerReading(repository);
  });

  final update = OdometerUpdate(reading: reading, vehicle: tara);

  group('RecordOdometerReading', () {
    test('sends a reading at or above the current mileage', () async {
      final at = DateTime.utc(2026, 10, 20);
      when(() => repository.recordReading('v1', mileageKm: 34850, recordedAt: at))
          .thenAnswer((_) async => Right(update));

      expect(
        await record(tara, mileageKm: 34850, recordedAt: at),
        Right<Failure, OdometerUpdate>(update),
      );
    });

    test('accepts the current mileage itself', () async {
      when(() => repository.recordReading('v1', mileageKm: 34500))
          .thenAnswer((_) async => Right(update));

      expect((await record(tara, mileageKm: 34500)).isRight(), isTrue);
    });

    test('rejects a value below the current mileage without calling the server', () async {
      expect(
        await record(tara, mileageKm: 34499),
        const Left<Failure, OdometerUpdate>(MileageBelowCurrentFailure(34500)),
      );
      verifyZeroInteractions(repository);
    });

    test('rejects a value above 2,000,000 km without calling the server', () async {
      expect(
        await record(tara, mileageKm: 2000001),
        const Left<Failure, OdometerUpdate>(MileageTooHighFailure(2000000)),
      );
      verifyZeroInteractions(repository);
    });

    test('passes a server failure through', () async {
      when(() => repository.recordReading('v1', mileageKm: 35000))
          .thenAnswer((_) async => const Left(MileageBelowCurrentFailure(36000)));

      expect(
        await record(tara, mileageKm: 35000),
        const Left<Failure, OdometerUpdate>(MileageBelowCurrentFailure(36000)),
      );
    });
  });

  test('GetOdometerReadings returns the readings in the server order', () async {
    when(() => repository.getReadings('v1')).thenAnswer((_) async => Right([reading]));

    expect((await GetOdometerReadings(repository)('v1')).getOrElse((f) => throw f), [reading]);
  });
}
