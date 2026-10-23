import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/expenses/data/models/expense_dto.dart';
import 'package:car_assistant/features/fuel/data/models/fuel_log_dto.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/reports/data/datasources/report_remote_data_source.dart';
import 'package:car_assistant/features/reports/data/models/report_query_dto.dart';
import 'package:car_assistant/features/reports/data/models/report_response_dto.dart';
import 'package:car_assistant/features/reports/data/repositories/report_repository_impl.dart';
import 'package:car_assistant/features/reports/domain/entities/report.dart';
import 'package:car_assistant/features/reports/domain/entities/report_failures.dart';
import 'package:car_assistant/features/reports/domain/entities/report_query.dart';
import 'package:car_assistant/features/services/data/models/service_visit_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../expenses/expense_fixtures.dart';
import '../../fuel/fuel_fixtures.dart';
import '../../history/history_fixtures.dart';
import '../../services/service_fixtures.dart';

class MockDio extends Mock implements Dio {}

/// The contract sample of `GET /api/reports`: the history entries oldest first, and the summary.
Map<String, dynamic> reportJson() => {
  'entries': [expenseEntryJson(), fuelEntryJson(), serviceEntryJson()],
  'summary': {'totalCost': 18450000, 'serviceCount': 8, 'fuelVolume': 240.5, 'entryCount': 24},
};

DioException _status(int status, [String message = 'error']) => DioException.badResponse(
  statusCode: status,
  requestOptions: RequestOptions(),
  response: Response(
    requestOptions: RequestOptions(),
    statusCode: status,
    data: {
      'error': {'message': message},
    },
  ),
);

void main() {
  group('ReportResponseDto', () {
    test('maps the contract sample: history entries in order, and the summary', () {
      final report = ReportResponseDto.fromJson(reportJson()).toEntity();

      expect(report.entries, [expenseEntry(), fuelEntry(), serviceEntry()]);
      expect(report.summary.entryCount, 24);
      expect(report.summary.totalCost, 18450000);
      expect(report.summary.fuelVolume, 240.5);
    });

    test('reads `locked` inside the entries', () {
      final json = reportJson();
      final entries = json['entries'] as List<Map<String, dynamic>>;
      (entries[0]['expense'] as Map<String, dynamic>)['locked'] = true;
      (entries[1]['fuelLog'] as Map<String, dynamic>)['locked'] = true;
      (entries[2]['service'] as Map<String, dynamic>)['locked'] = true;

      final report = ReportResponseDto.fromJson(json).toEntity();

      expect(report.entries[0].expense!.locked, isTrue);
      expect(report.entries[1].fuelLog!.locked, isTrue);
      expect(report.entries[2].service!.locked, isTrue);
    });
  });

  group('locked on the record DTOs', () {
    test('defaults to false when absent', () {
      expect(ServiceVisitDto.fromJson(visitJson()).toEntity().locked, isFalse);
      expect(FuelLogDto.fromJson(fuelLogJson()).toEntity().locked, isFalse);
      expect(ExpenseDto.fromJson(expenseJson()).toEntity().locked, isFalse);
    });

    test('reads true and false', () {
      expect(ServiceVisitDto.fromJson({...visitJson(), 'locked': true}).toEntity().locked, isTrue);
      expect(FuelLogDto.fromJson({...fuelLogJson(), 'locked': true}).toEntity().locked, isTrue);
      expect(ExpenseDto.fromJson({...expenseJson(), 'locked': false}).toEntity().locked, isFalse);
    });

    test('is part of equality', () {
      expect(ServiceVisitDto.fromJson({...visitJson(), 'locked': true}).toEntity(), isNot(visit()));
    });
  });

  group('ReportQueryDto', () {
    test('a default query sends the three types only', () {
      expect(const ReportQueryDto(ReportQuery()).toQueryParameters(), {
        'types': 'service,fuel,expense',
      });
    });

    test('a full query sends the vehicles, the types and the dates in UTC', () {
      final query = ReportQuery(
        vehicleIds: const ['v1', 'v2'],
        types: const [HistoryType.fuel],
        from: DateTime.utc(2024, 3, 19, 20, 30),
        to: DateTime.utc(2024, 11, 15, 12),
      );

      expect(ReportQueryDto(query).toQueryParameters(), {
        'vehicleIds': 'v1,v2',
        'types': 'fuel',
        'from': '2024-03-19T20:30:00.000Z',
        'to': '2024-11-15T12:00:00.000Z',
      });
    });
  });

  group('ReportRepositoryImpl', () {
    late MockDio dio;
    late ReportRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = ReportRepositoryImpl(ReportRemoteDataSource(dio));
    });

    void stubReport(Future<Response<Map<String, dynamic>>> Function() answer) => when(
      () => dio.get<Map<String, dynamic>>(any(), queryParameters: any(named: 'queryParameters')),
    ).thenAnswer((_) => answer());

    test('getReport sends the query and maps the report', () async {
      stubReport(
        () async => Response(requestOptions: RequestOptions(), statusCode: 200, data: reportJson()),
      );

      final result = await repository.getReport(const ReportQuery(vehicleIds: ['v1']));

      expect(result.getRight().toNullable()?.entries, hasLength(3));
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/api/reports',
          queryParameters: {'vehicleIds': 'v1', 'types': 'service,fuel,expense'},
        ),
      ).called(1);
    });

    test('a 422 becomes a ReportTooLargeFailure', () async {
      stubReport(() => Future.error(_status(422, 'بازه گزارش بیش از حد بزرگ است')));

      expect(
        await repository.getReport(const ReportQuery()),
        const Left<Failure, Report>(ReportTooLargeFailure()),
      );
    });

    test('a 404 becomes a generic Failure', () async {
      stubReport(() => Future.error(_status(404, 'Not found')));

      final result = await repository.getReport(const ReportQuery());

      expect(result.getLeft().toNullable(), isNot(isA<ReportTooLargeFailure>()));
      expect(result.getLeft().toNullable()?.message, contains('Not found'));
    });

    test('a connection error becomes a NetworkFailure', () async {
      stubReport(
        () => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(
        await repository.getReport(const ReportQuery()),
        const Left<Failure, Report>(NetworkFailure()),
      );
    });

    test('getFile downloads the bytes of a relative URL', () async {
      when(() => dio.get<List<int>>(any(), options: any(named: 'options'))).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(), statusCode: 200, data: [1, 2, 3]),
      );

      final result = await repository.getFile('/api/vehicles/v1/services/s1/invoice?v=1');

      expect(result.getRight().toNullable(), Uint8List.fromList([1, 2, 3]));
      verify(
        () => dio.get<List<int>>(
          '/api/vehicles/v1/services/s1/invoice?v=1',
          options: any(named: 'options'),
        ),
      ).called(1);
    });
  });
}
