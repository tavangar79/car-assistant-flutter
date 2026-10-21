import 'package:dio/dio.dart';

import '../models/history_query_dto.dart';
import '../models/history_response_dto.dart';

/// HTTP calls for the history. Throws [DioException] on a non-2xx response.
class HistoryRemoteDataSource {
  const HistoryRemoteDataSource(this._dio);

  final Dio _dio;

  Future<HistoryResponseDto> fetchHistory(HistoryQueryDto query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/history',
      queryParameters: query.toQueryParameters(),
    );
    return HistoryResponseDto.fromJson(response.data!);
  }
}
