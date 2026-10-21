import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/history/data/datasources/history_remote_data_source.dart';
import 'package:car_assistant/features/history/data/models/history_query_dto.dart';
import 'package:car_assistant/features/history/data/models/history_response_dto.dart';
import 'package:car_assistant/features/history/data/repositories/history_repository_impl.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../history_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  group('HistoryResponseDto', () {
    test('maps the contract sample: entries of each type, cursor and summary', () {
      expect(HistoryResponseDto.fromJson(historyJson()).toEntity(), historyResult());
    });

    test('maps a later page: no cursor, no summary', () {
      final result = HistoryResponseDto.fromJson(historyJson(nextCursor: null, withSummary: false))
          .toEntity();

      expect(result.nextCursor, isNull);
      expect(result.summary, isNull);
    });

    test('reads an integer fuel volume as a double', () {
      final json = historyJson()..['summary'] = {...summaryJson, 'fuelVolume': 240};

      expect(HistoryResponseDto.fromJson(json).toEntity().summary!.fuelVolume, 240.0);
    });
  });

  group('HistoryQueryDto', () {
    test('a default query sends only the type and the limit', () {
      expect(const HistoryQueryDto(HistoryQuery()).toQueryParameters(), {
        'type': 'all',
        'limit': '30',
      });
    });

    test('a full query sends every parameter, dates in UTC', () {
      final query = HistoryQuery(
        vehicleIds: const ['v1', 'v2'],
        type: HistoryType.service,
        categories: const ['fluids', 'legal'],
        attachmentsOnly: true,
        from: DateTime.utc(2025, 3, 20, 20, 30),
        to: DateTime.utc(2026, 10, 21, 12),
        cursor: 'c1',
        limit: 1,
      );

      expect(HistoryQueryDto(query).toQueryParameters(), {
        'vehicleIds': 'v1,v2',
        'type': 'service',
        'categories': 'fluids,legal',
        'hasAttachment': 'true',
        'from': '2025-03-20T20:30:00.000Z',
        'to': '2026-10-21T12:00:00.000Z',
        'cursor': 'c1',
        'limit': '1',
      });
    });
  });

  group('HistoryRepositoryImpl', () {
    late MockDio dio;
    late HistoryRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = HistoryRepositoryImpl(HistoryRemoteDataSource(dio));
    });

    test('getHistory sends the query and maps the page', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/api/history',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async =>
            Response(requestOptions: RequestOptions(), statusCode: 200, data: historyJson()),
      );

      final result = await repository.getHistory(
        const HistoryQuery(type: HistoryType.fuel, cursor: 'c0'),
      );

      expect(result, Right<Failure, HistoryResult>(historyResult()));
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/api/history',
          queryParameters: {'type': 'fuel', 'cursor': 'c0', 'limit': '30'},
        ),
      ).called(1);
    });

    test('a 400 becomes a Failure with the backend message', () async {
      when(
        () => dio.get<Map<String, dynamic>>(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) => Future.error(
          DioException.badResponse(
            statusCode: 400,
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 400,
              data: {
                'error': {
                  'message': 'Invalid query',
                  'details': {
                    'cursor': ['Malformed cursor'],
                  },
                },
              },
            ),
          ),
        ),
      );

      final result = await repository.getHistory(const HistoryQuery());

      expect(result.getLeft().toNullable()?.message, contains('Invalid query'));
    });

    test('a connection error becomes a NetworkFailure', () async {
      when(
        () => dio.get<Map<String, dynamic>>(any(), queryParameters: any(named: 'queryParameters')),
      ).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );

      expect(
        await repository.getHistory(const HistoryQuery()),
        const Left<Failure, HistoryResult>(NetworkFailure()),
      );
    });
  });
}
