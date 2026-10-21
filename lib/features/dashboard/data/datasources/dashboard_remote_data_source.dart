import 'package:dio/dio.dart';

import '../models/dashboard_dto.dart';

/// HTTP call for the garage dashboard. Throws [DioException] on a non-2xx response.
class DashboardRemoteDataSource {
  const DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  Future<DashboardDto> fetchDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/dashboard');
    return DashboardDto.fromEnvelope(response.data!);
  }
}
