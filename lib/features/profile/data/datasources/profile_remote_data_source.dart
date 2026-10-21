import 'package:dio/dio.dart';

import '../models/profile_stats_dto.dart';

/// HTTP call for the profile counts. Throws [DioException] on a non-2xx response.
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProfileStatsDto> fetchStats() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/profile/stats');
    return ProfileStatsDto.fromEnvelope(response.data!);
  }
}
