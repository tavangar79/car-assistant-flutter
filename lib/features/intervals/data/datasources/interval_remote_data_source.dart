import 'package:dio/dio.dart';

import '../models/due_report_dto.dart';
import '../models/service_interval_dto.dart';
import '../models/set_intervals_request_dto.dart';

/// HTTP calls for service intervals and due items. Throws [DioException] on a non-2xx response.
class IntervalRemoteDataSource {
  const IntervalRemoteDataSource(this._dio);

  final Dio _dio;

  static String _intervals(String vehicleId) => '/api/vehicles/$vehicleId/intervals';

  Future<List<ServiceIntervalDto>> fetchIntervals(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>(_intervals(vehicleId));
    return ServiceIntervalDto.listFromJson(response.data!);
  }

  Future<List<ServiceIntervalDto>> setIntervals(
    String vehicleId,
    SetIntervalsRequestDto request,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      _intervals(vehicleId),
      data: request.toJson(),
    );
    return ServiceIntervalDto.listFromJson(response.data!);
  }

  Future<List<ServiceIntervalDto>> resetIntervals(String vehicleId) async {
    final response = await _dio.delete<Map<String, dynamic>>(_intervals(vehicleId));
    return ServiceIntervalDto.listFromJson(response.data!);
  }

  Future<DueReportDto> fetchDue(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/vehicles/$vehicleId/due');
    return DueReportDto.fromJson(response.data!);
  }
}
