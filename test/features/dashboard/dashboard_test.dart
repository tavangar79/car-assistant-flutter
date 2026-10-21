import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:car_assistant/features/dashboard/data/models/dashboard_dto.dart';
import 'package:car_assistant/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:car_assistant/features/dashboard/domain/entities/dashboard.dart';
import 'package:car_assistant/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:car_assistant/features/dashboard/domain/usecases/get_dashboard.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'dashboard_fixtures.dart';

class MockDio extends Mock implements Dio {}

class MockDashboardRepository extends Mock implements DashboardRepository {}

void main() {
  group('DashboardDto', () {
    test('parses the contract sample', () {
      expect(DashboardDto.fromEnvelope(dashboardJson).toEntity(), dashboard);
    });

    test('parses the empty garage (all zeros, byVehicle empty)', () {
      final json = {
        'dashboard': {
          'jalaliYear': 1403,
          'yearTotalCost': 0,
          'invoiceCount': 0,
          'attentionCount': 0,
          'vehicles': <dynamic>[],
          'months': [
            for (var month = 3; month <= 8; month++)
              {
                'jalaliYear': 1403,
                'jalaliMonth': month,
                'from': '2024-05-21T20:30:00.000Z',
                'to': '2024-06-21T20:30:00.000Z',
                'totalCost': 0,
                'byVehicle': <dynamic>[],
              },
          ],
        },
      };

      final empty = DashboardDto.fromEnvelope(json).toEntity();

      expect(empty.vehicles, isEmpty);
      expect(empty.months, hasLength(6));
      expect(empty.hasMonthCosts, isFalse);
      expect(empty.firstVehicleNeedingAttention, isNull);
    });
  });

  group('Dashboard', () {
    test('firstVehicleNeedingAttention is the first vehicle in garage order with a count', () {
      expect(homeDashboard(attention: [0, 2, 1]).firstVehicleNeedingAttention, 'v2');
      expect(homeDashboard(attention: [0, 0]).firstVehicleNeedingAttention, isNull);
    });

    test('hasMonthCosts is true once any month has a cost', () {
      expect(homeDashboard().hasMonthCosts, isFalse);
      expect(
        homeDashboard(
          costs: [
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 0],
            [0, 10],
          ],
        ).hasMonthCosts,
        isTrue,
      );
    });
  });

  group('GetDashboard', () {
    test('returns the repository result', () async {
      final repository = MockDashboardRepository();
      when(() => repository.getDashboard()).thenAnswer((_) async => Right(dashboard));

      expect(await GetDashboard(repository).call(), Right<Failure, Dashboard>(dashboard));
    });
  });

  group('DashboardRepositoryImpl', () {
    late MockDio dio;
    late DashboardRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = DashboardRepositoryImpl(DashboardRemoteDataSource(dio));
    });

    test('GET /api/dashboard maps the envelope', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/dashboard')).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(), statusCode: 200, data: dashboardJson),
      );

      expect((await repository.getDashboard()).getOrElse((f) => throw f), dashboard);
    });

    test('a non-2xx response becomes a Failure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/dashboard')).thenAnswer(
        (_) => Future.error(
          DioException.badResponse(
            statusCode: 500,
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 500,
              data: {
                'error': {'message': 'Internal error'},
              },
            ),
          ),
        ),
      );

      expect(
        await repository.getDashboard(),
        const Left<Failure, Dashboard>(Failure('HTTP 500: Internal error')),
      );
    });

    test('a connection error becomes a NetworkFailure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/dashboard')).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect((await repository.getDashboard()).getLeft().toNullable(), isA<NetworkFailure>());
    });
  });
}
