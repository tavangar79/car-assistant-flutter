import 'package:dio/dio.dart';

import '../../../vehicles/data/models/vehicle_dto.dart';
import '../models/transfer_dto.dart';

/// HTTP calls for ownership transfers. Throws [DioException] on a non-2xx response.
class TransferRemoteDataSource {
  const TransferRemoteDataSource(this._dio);

  final Dio _dio;

  Future<TransferDto> createTransfer(String vehicleId, String phone) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/api/vehicles/$vehicleId/transfers',
      data: {'phone': phone},
    );
    return TransferDto.fromJson(response.data!['transfer'] as Map<String, dynamic>);
  }

  /// `{ incoming: [Transfer], outgoing: [Transfer] }`.
  Future<(List<TransferDto>, List<TransferDto>)> fetchTransfers() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/transfers');
    List<TransferDto> list(String key) => (response.data![key] as List<dynamic>)
        .map((json) => TransferDto.fromJson(json as Map<String, dynamic>))
        .toList();
    return (list('incoming'), list('outgoing'));
  }

  Future<void> cancelTransfer(String transferId) => _dio.delete<void>('/api/transfers/$transferId');

  Future<void> rejectTransfer(String transferId) =>
      _dio.post<void>('/api/transfers/$transferId/reject');

  Future<VehicleDto> acceptTransfer(String transferId) async {
    final response = await _dio.post<Map<String, dynamic>>('/api/transfers/$transferId/accept');
    return VehicleDto.fromJson(response.data!['vehicle'] as Map<String, dynamic>);
  }
}
