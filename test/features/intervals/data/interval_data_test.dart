import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/intervals/data/datasources/interval_remote_data_source.dart';
import 'package:car_assistant/features/intervals/data/models/due_report_dto.dart';
import 'package:car_assistant/features/intervals/data/models/service_interval_dto.dart';
import 'package:car_assistant/features/intervals/data/models/set_intervals_request_dto.dart';
import 'package:car_assistant/features/intervals/data/repositories/interval_repository_impl.dart';
import 'package:car_assistant/features/intervals/domain/entities/due_report.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_failures.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_setting.dart';
import 'package:car_assistant/features/intervals/domain/entities/service_interval.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../interval_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('DTOs', () {
    test('ServiceIntervalDto parses the intervals envelope', () {
      expect(
        ServiceIntervalDto.listFromJson(intervalsJson).map((dto) => dto.toEntity()).toList(),
        intervals,
      );
    });

    test('DueReportDto parses the report with every status', () {
      expect(DueReportDto.fromJson(dueJson).toEntity(), dueReport);
    });

    test('SetIntervalsRequestDto writes the contract body', () {
      expect(
        const SetIntervalsRequestDto([IntervalSetting(id: 'engine_oil', km: 7000, months: 6)])
            .toJson(),
        {
          'intervals': [
            {'id': 'engine_oil', 'km': 7000, 'months': 6},
          ],
        },
      );
    });
  });

  group('IntervalRepositoryImpl', () {
    late MockDio dio;
    late IntervalRepositoryImpl repository;
    const path = '/api/vehicles/v1/intervals';

    setUp(() {
      dio = MockDio();
      repository = IntervalRepositoryImpl(IntervalRemoteDataSource(dio));
    });

    Response<T> ok<T>(T data) =>
        Response(requestOptions: RequestOptions(), statusCode: 200, data: data);

    Future<Response<T>> httpError<T>(int status, Map<String, dynamic> body) => Future.error(
      DioException.badResponse(
        statusCode: status,
        requestOptions: RequestOptions(),
        response: Response(requestOptions: RequestOptions(), statusCode: status, data: body),
      ),
    );

    test('getIntervals maps the list', () async {
      when(() => dio.get<Map<String, dynamic>>(path)).thenAnswer((_) async => ok(intervalsJson));

      expect((await repository.getIntervals('v1')).getOrElse((f) => throw f), intervals);
    });

    test('setIntervals puts the body and maps the list; 400 → InvalidIntervalsFailure', () async {
      when(() => dio.put<Map<String, dynamic>>(path, data: any(named: 'data')))
          .thenAnswer((_) async => ok(intervalsJson));
      const settings = [IntervalSetting(id: 'engine_oil', km: 7000, months: 6)];

      expect((await repository.setIntervals('v1', settings)).getOrElse((f) => throw f), intervals);
      verify(
        () => dio.put<Map<String, dynamic>>(
          path,
          data: {
            'intervals': [
              {'id': 'engine_oil', 'km': 7000, 'months': 6},
            ],
          },
        ),
      ).called(1);

      when(() => dio.put<Map<String, dynamic>>(path, data: any(named: 'data'))).thenAnswer(
        (_) => httpError(400, {
          'error': {
            'message': 'Validation failed',
            'details': {
              'intervals': ['Unknown id'],
            },
          },
        }),
      );
      expect(
        await repository.setIntervals('v1', settings),
        const Left<Failure, List<ServiceInterval>>(
          InvalidIntervalsFailure({}, 'Validation failed'),
        ),
      );
    });

    test('resetIntervals deletes and maps the list', () async {
      when(() => dio.delete<Map<String, dynamic>>(path)).thenAnswer((_) async => ok(intervalsJson));

      expect((await repository.resetIntervals('v1')).getOrElse((f) => throw f), intervals);
    });

    test('getDue maps the report and a connection error to NetworkFailure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/due'))
          .thenAnswer((_) async => ok(dueJson));
      expect((await repository.getDue('v1')).getOrElse((f) => throw f), dueReport);

      when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/due')).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );
      expect(await repository.getDue('v1'), const Left<Failure, DueReport>(NetworkFailure()));
    });
  });
}
