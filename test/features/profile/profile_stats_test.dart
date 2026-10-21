import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:car_assistant/features/profile/data/models/profile_stats_dto.dart';
import 'package:car_assistant/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:car_assistant/features/profile/domain/entities/profile_stats.dart';
import 'package:car_assistant/features/profile/domain/repositories/profile_repository.dart';
import 'package:car_assistant/features/profile/domain/usecases/get_profile_stats.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  /// The `GET /api/profile/stats` sample of API-PHASE4.md T4.6.
  final statsJson = <String, dynamic>{
    'stats': {'vehicleCount': 2, 'serviceCount': 18},
  };
  const stats = ProfileStats(vehicleCount: 2, serviceCount: 18);

  test('ProfileStatsDto parses the contract sample', () {
    expect(ProfileStatsDto.fromEnvelope(statsJson).toEntity(), stats);
  });

  test('GetProfileStats returns the repository result', () async {
    final repository = MockProfileRepository();
    when(() => repository.getStats()).thenAnswer((_) async => const Right(stats));

    expect(await GetProfileStats(repository).call(), const Right<Failure, ProfileStats>(stats));
  });

  group('ProfileRepositoryImpl', () {
    late MockDio dio;
    late ProfileRepositoryImpl repository;

    setUp(() {
      dio = MockDio();
      repository = ProfileRepositoryImpl(ProfileRemoteDataSource(dio));
    });

    test('GET /api/profile/stats maps the envelope', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/profile/stats')).thenAnswer(
        (_) async => Response(requestOptions: RequestOptions(), statusCode: 200, data: statsJson),
      );

      expect(await repository.getStats(), const Right<Failure, ProfileStats>(stats));
    });

    test('a 401 becomes a Failure and a connection error a NetworkFailure', () async {
      when(() => dio.get<Map<String, dynamic>>('/api/profile/stats')).thenAnswer(
        (_) => Future.error(
          DioException.badResponse(
            statusCode: 401,
            requestOptions: RequestOptions(),
            response: Response(
              requestOptions: RequestOptions(),
              statusCode: 401,
              data: {
                'error': {'message': 'Unauthorized'},
              },
            ),
          ),
        ),
      );
      expect(
        await repository.getStats(),
        const Left<Failure, ProfileStats>(Failure('HTTP 401: Unauthorized')),
      );

      when(() => dio.get<Map<String, dynamic>>('/api/profile/stats')).thenAnswer(
        (_) => Future.error(
          DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
        ),
      );
      expect((await repository.getStats()).getLeft().toNullable(), isA<NetworkFailure>());
    });
  });
}
