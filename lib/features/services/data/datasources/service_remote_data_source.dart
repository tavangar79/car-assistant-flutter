import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../domain/entities/invoice_file.dart';
import '../models/create_service_request_dto.dart';
import '../models/service_catalog_dto.dart';
import '../models/service_suggestions_dto.dart';
import '../models/service_visit_dto.dart';
import '../models/update_service_request_dto.dart';

/// HTTP calls for service visits. Throws [DioException] on a non-2xx response.
class ServiceRemoteDataSource {
  const ServiceRemoteDataSource(this._dio);

  final Dio _dio;

  static String _visits(String vehicleId) => '/api/vehicles/$vehicleId/services';

  static String _visit(String vehicleId, String serviceId) => '${_visits(vehicleId)}/$serviceId';

  Future<ServiceCatalogDto> fetchCatalog() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/service-items');
    return ServiceCatalogDto.fromJson(response.data!);
  }

  Future<ServiceSuggestionsDto> fetchSuggestions() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/service-suggestions');
    return ServiceSuggestionsDto.fromJson(response.data!);
  }

  Future<List<ServiceVisitDto>> fetchVisits(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>(_visits(vehicleId));
    return (response.data!['services'] as List<dynamic>)
        .map((json) => ServiceVisitDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ServiceVisitDto> fetchVisit(String vehicleId, String serviceId) async {
    final response = await _dio.get<Map<String, dynamic>>(_visit(vehicleId, serviceId));
    return _service(response);
  }

  Future<ServiceVisitDto> createVisit(String vehicleId, CreateServiceRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _visits(vehicleId),
      data: request.toJson(),
    );
    return _service(response);
  }

  Future<ServiceVisitDto> updateVisit(
    String vehicleId,
    String serviceId,
    UpdateServiceRequestDto request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _visit(vehicleId, serviceId),
      data: request.toJson(),
    );
    return _service(response);
  }

  Future<void> deleteVisit(String vehicleId, String serviceId) =>
      _dio.delete<void>(_visit(vehicleId, serviceId));

  /// `multipart/form-data` with the single file field `invoice`.
  Future<ServiceVisitDto> uploadInvoice(
    String vehicleId,
    String serviceId,
    InvoiceFile invoice,
  ) async {
    final form = FormData.fromMap({
      'invoice': MultipartFile.fromBytes(
        invoice.bytes,
        filename: invoice.fileName,
        contentType: DioMediaType.parse(invoice.mimeType ?? imageMimeType(invoice.fileName)),
      ),
    });
    final response = await _dio.put<Map<String, dynamic>>(
      '${_visit(vehicleId, serviceId)}/invoice',
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return _service(response);
  }

  Future<ServiceVisitDto> deleteInvoice(String vehicleId, String serviceId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${_visit(vehicleId, serviceId)}/invoice',
    );
    return _service(response);
  }

  /// [invoiceUrl] is the relative path from `ServiceVisit.invoiceUrl`; Dio resolves it against
  /// the base URL.
  Future<Uint8List> fetchInvoice(String invoiceUrl) async {
    final response = await _dio.get<List<int>>(
      invoiceUrl,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// Every write answers `{ "service": Service }`.
  static ServiceVisitDto _service(Response<Map<String, dynamic>> response) =>
      ServiceVisitDto.fromJson(response.data!['service'] as Map<String, dynamic>);

  /// The image type for a file name: PNG, WebP, else JPEG.
  static String imageMimeType(String fileName) {
    final name = fileName.toLowerCase();
    if (name.endsWith('.png')) return 'image/png';
    if (name.endsWith('.webp')) return 'image/webp';
    return 'image/jpeg';
  }
}
