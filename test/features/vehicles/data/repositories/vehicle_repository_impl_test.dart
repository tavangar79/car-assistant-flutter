import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/vehicles/data/datasources/vehicle_remote_data_source.dart';
import 'package:car_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:car_assistant/features/vehicles/domain/entities/vehicle.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late VehicleRepositoryImpl repository;

  setUp(() {
    dio = MockDio();
    repository = VehicleRepositoryImpl(VehicleRemoteDataSource(dio));
  });

  void stubGet(Future<Response<List<dynamic>>> Function() answer) {
    when(() => dio.get<List<dynamic>>('/api/vehicles')).thenAnswer((_) => answer());
  }

  test('maps API JSON to Vehicle entities', () async {
    stubGet(
      () async => Response(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: [
          {'id': 'a1', 'make': 'Kia', 'model': 'Rio', 'year': 2021, 'mileageKm': 500},
        ],
      ),
    );

    final result = await repository.getVehicles();

    expect(result.getOrElse((f) => throw f), [
      const Vehicle(id: 'a1', make: 'Kia', model: 'Rio', year: 2021, mileageKm: 500),
    ]);
  });

  test('returns a Failure with the server message on a non-2xx response', () async {
    stubGet(
      () => Future.error(
        DioException.badResponse(
          statusCode: 500,
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            data: {
              'error': {'message': 'boom'},
            },
          ),
        ),
      ),
    );

    expect(
      await repository.getVehicles(),
      const Left<Failure, List<Vehicle>>(Failure('HTTP 500: boom')),
    );
  });

  test('returns NetworkFailure when the server is unreachable', () async {
    stubGet(
      () => Future.error(
        DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
      ),
    );

    expect(await repository.getVehicles(), const Left<Failure, List<Vehicle>>(NetworkFailure()));
  });
}
