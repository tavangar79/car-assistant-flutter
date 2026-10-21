import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/odometer/data/datasources/odometer_remote_data_source.dart';
import 'package:car_assistant/features/odometer/data/repositories/odometer_repository_impl.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_failures.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_reading.dart';
import 'package:car_assistant/features/odometer/domain/entities/odometer_update.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../odometer_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late OdometerRepositoryImpl repository;

  setUp(() {
    dio = MockDio();
    repository = OdometerRepositoryImpl(OdometerRemoteDataSource(dio));
  });

  Response<T> ok<T>(T data, [int status = 200]) =>
      Response(requestOptions: RequestOptions(), statusCode: status, data: data);

  Future<Response<T>> httpError<T>(int status, Map<String, dynamic> body) => Future.error(
    DioException.badResponse(
      statusCode: status,
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: status, data: body),
    ),
  );

  group('recordReading', () {
    const path = '/api/vehicles/v1/odometer';

    void stubPost(Future<Response<Map<String, dynamic>>> Function() answer) {
      when(() => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')))
          .thenAnswer((_) => answer());
    }

    test('posts the mileage and date, and maps the 201 body', () async {
      stubPost(() async => ok({'reading': readingJson(), 'vehicle': vehicleJson()}, 201));

      final result = await repository.recordReading(
        'v1',
        mileageKm: 34850,
        recordedAt: DateTime.utc(2026, 10, 20, 15, 15),
      );

      expect(
        result,
        Right<Failure, OdometerUpdate>(OdometerUpdate(reading: reading, vehicle: tara)),
      );
      verify(
        () => dio.post<Map<String, dynamic>>(
          path,
          data: {'mileageKm': 34850, 'recordedAt': '2026-10-20T15:15:00.000Z'},
        ),
      ).called(1);
    });

    test('maps 422 to MileageBelowCurrentFailure with the current mileage', () async {
      stubPost(
        () => httpError(422, {
          'error': {
            'message': 'Mileage must be >= 36000',
            'details': {'currentMileageKm': 36000},
          },
        }),
      );

      final result = await repository.recordReading('v1', mileageKm: 35000);

      expect(
        result,
        const Left<Failure, OdometerUpdate>(
          MileageBelowCurrentFailure(36000, 'Mileage must be >= 36000'),
        ),
      );
    });

    test('maps 404 to a generic Failure', () async {
      stubPost(
        () => httpError(404, {
          'error': {'message': 'Vehicle not found'},
        }),
      );

      expect(
        await repository.recordReading('v1', mileageKm: 35000),
        const Left<Failure, OdometerUpdate>(Failure('HTTP 404: Vehicle not found')),
      );
    });

    test('maps a connection error to NetworkFailure', () async {
      stubPost(
        () => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(
        await repository.recordReading('v1', mileageKm: 35000),
        const Left<Failure, OdometerUpdate>(NetworkFailure()),
      );
    });
  });

  group('getReadings', () {
    test('maps the readings list', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/odometer')).thenAnswer(
        (_) async => ok({
          'readings': [readingJson()],
        }),
      );

      expect((await repository.getReadings('v1')).getOrElse((f) => throw f), [reading]);
    });

    test('returns a Failure on a non-2xx response', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/odometer')).thenAnswer(
        (_) => httpError(500, {
          'error': {'message': 'boom'},
        }),
      );

      expect(
        await repository.getReadings('v1'),
        const Left<Failure, List<OdometerReading>>(Failure('HTTP 500: boom')),
      );
    });
  });
}
