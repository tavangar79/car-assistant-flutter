import 'package:dio/dio.dart';

import '../models/vehicle_dto.dart';

/// HTTP calls for vehicles. Throws [DioException] on a non-2xx response.
class VehicleRemoteDataSource {
  const VehicleRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<VehicleDto>> fetchVehicles() async {
    final response = await _dio.get<List<dynamic>>('/api/vehicles');
    return response.data!.map((json) => VehicleDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}
