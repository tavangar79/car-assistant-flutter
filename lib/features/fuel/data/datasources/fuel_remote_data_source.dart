import 'package:dio/dio.dart';

import '../models/create_fuel_log_request_dto.dart';
import '../models/fuel_log_dto.dart';

/// HTTP calls for fuel logs. Throws [DioException] on a non-2xx response.
class FuelRemoteDataSource {
  const FuelRemoteDataSource(this._dio);

  final Dio _dio;

  static String _logs(String vehicleId) => '/api/vehicles/$vehicleId/fuel';

  Future<List<FuelLogDto>> fetchLogs(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>(_logs(vehicleId));
    return (response.data!['fuelLogs'] as List<dynamic>)
        .map((json) => FuelLogDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Answers `{ "fuelLog": FuelLog }`.
  Future<FuelLogDto> createLog(String vehicleId, CreateFuelLogRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _logs(vehicleId),
      data: request.toJson(),
    );
    return FuelLogDto.fromJson(response.data!['fuelLog'] as Map<String, dynamic>);
  }
}
