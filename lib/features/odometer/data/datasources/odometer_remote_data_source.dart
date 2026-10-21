import 'package:dio/dio.dart';

import '../models/odometer_reading_dto.dart';
import '../models/record_odometer_request_dto.dart';
import '../models/record_odometer_response_dto.dart';

/// HTTP calls for odometer readings. Throws [DioException] on a non-2xx response.
class OdometerRemoteDataSource {
  const OdometerRemoteDataSource(this._dio);

  final Dio _dio;

  Future<RecordOdometerResponseDto> recordReading(
    String vehicleId,
    RecordOdometerRequestDto request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/vehicles/$vehicleId/odometer',
      data: request.toJson(),
    );
    return RecordOdometerResponseDto.fromJson(response.data!);
  }

  Future<List<OdometerReadingDto>> fetchReadings(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>('/api/vehicles/$vehicleId/odometer');
    return (response.data!['readings'] as List<dynamic>)
        .map((json) => OdometerReadingDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
