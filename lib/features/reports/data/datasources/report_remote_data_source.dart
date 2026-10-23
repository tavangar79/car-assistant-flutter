import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../models/report_query_dto.dart';
import '../models/report_response_dto.dart';

/// HTTP calls for the report export. Throws [DioException] on a non-2xx response.
class ReportRemoteDataSource {
  const ReportRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ReportResponseDto> fetchReport(ReportQueryDto query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/reports',
      queryParameters: query.toQueryParameters(),
    );
    return ReportResponseDto.fromJson(response.data!);
  }

  /// [url] is a relative `invoiceUrl` / `attachmentUrl`; Dio resolves it against the base URL.
  Future<Uint8List> fetchFile(String url) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }
}
