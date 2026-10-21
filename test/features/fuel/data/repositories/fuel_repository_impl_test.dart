import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/fuel/data/datasources/fuel_remote_data_source.dart';
import 'package:car_assistant/features/fuel/data/repositories/fuel_repository_impl.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_failures.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_field.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';
import 'package:car_assistant/features/fuel/domain/entities/new_fuel_log.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../fuel_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late FuelRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(RequestOptions()));

  setUp(() {
    dio = MockDio();
    repository = FuelRepositoryImpl(FuelRemoteDataSource(dio));
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

  final newLog = NewFuelLog(
    fueledAt: DateTime.utc(2025, 11, 15, 13, 12),
    odometerKm: 34850,
    fuelType: FuelType.superGrade,
    volume: 48.5,
    totalCost: 145500,
    isFullFill: true,
  );

  test('getLogs maps the list', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/fuel')).thenAnswer(
      (_) async => ok({
        'fuelLogs': [fuelLogJson()],
      }),
    );

    final result = await repository.getLogs('v1');

    expect(result.toNullable(), [contractFuelLog()]);
  });

  test('getLogs turns a connection error into NetworkFailure', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) =>
          Future.error(DioException.connectionError(requestOptions: RequestOptions(), reason: 'x')),
    );

    expect(await repository.getLogs('v1'), const Left<Failure, List<FuelLog>>(NetworkFailure()));
  });

  test('createLog posts the body and maps the created log', () async {
    when(() => dio.post<Map<String, dynamic>>('/api/vehicles/v1/fuel', data: any(named: 'data')))
        .thenAnswer((_) async => ok({'fuelLog': fuelLogJson()}, 201));

    expect(await repository.createLog('v1', newLog), Right<Failure, FuelLog>(contractFuelLog()));
    final body =
        verify(
              () => dio.post<Map<String, dynamic>>(
                '/api/vehicles/v1/fuel',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body['fuelType'], 'super');
    expect(body['fueledAt'], '2025-11-15T13:12:00.000Z');
  });

  test('createLog maps a 400 to InvalidFuelLogFailure with the named fields', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenAnswer(
      (_) => httpError(400, {
        'error': {
          'message': 'Validation failed',
          'details': {
            'volume': ['too many decimals'],
            'fueledAt': ['in the future'],
          },
        },
      }),
    );

    expect(
      await repository.createLog('v1', newLog),
      const Left<Failure, FuelLog>(
        InvalidFuelLogFailure({FuelField.volume, FuelField.fueledAt}, 'Validation failed'),
      ),
    );
  });

  test('createLog maps a 422 to FuelLogRejectedFailure', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenAnswer(
      (_) => httpError(422, {
        'error': {'message': 'nope'},
      }),
    );

    expect(
      await repository.createLog('v1', newLog),
      const Left<Failure, FuelLog>(FuelLogRejectedFailure('nope')),
    );
  });

  test('createLog maps another status to a generic Failure', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenAnswer(
      (_) => httpError(404, {
        'error': {'message': 'Vehicle not found'},
      }),
    );

    expect(
      await repository.createLog('v1', newLog),
      const Left<Failure, FuelLog>(Failure('HTTP 404: Vehicle not found')),
    );
  });
}
