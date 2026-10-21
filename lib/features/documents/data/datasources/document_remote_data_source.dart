import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../expenses/domain/entities/attachment_file.dart';
import '../models/document_dto.dart';
import '../models/document_request_dto.dart';

/// HTTP calls for vehicle documents. Throws [DioException] on a non-2xx response.
class DocumentRemoteDataSource {
  const DocumentRemoteDataSource(this._dio);

  final Dio _dio;

  static String _documents(String vehicleId) => '/api/vehicles/$vehicleId/documents';

  static String _document(String vehicleId, String documentId) =>
      '${_documents(vehicleId)}/$documentId';

  Future<List<DocumentDto>> fetchDocuments(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>(_documents(vehicleId));
    return (response.data!['documents'] as List<dynamic>)
        .map((json) => DocumentDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<DocumentDto> createDocument(String vehicleId, DocumentRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _documents(vehicleId),
      data: request.toJson(),
    );
    return _documentOf(response);
  }

  Future<DocumentDto> updateDocument(
    String vehicleId,
    String documentId,
    DocumentRequestDto request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      _document(vehicleId, documentId),
      data: request.toJson(),
    );
    return _documentOf(response);
  }

  Future<void> deleteDocument(String vehicleId, String documentId) async {
    await _dio.delete<void>(_document(vehicleId, documentId));
  }

  /// `multipart/form-data` with the single file field `file`.
  Future<DocumentDto> uploadFile(String vehicleId, String documentId, AttachmentFile file) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        file.bytes,
        filename: file.fileName,
        contentType: DioMediaType.parse(file.contentType),
      ),
    });
    final response = await _dio.post<Map<String, dynamic>>(
      '${_document(vehicleId, documentId)}/files',
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return _documentOf(response);
  }

  Future<DocumentDto> deleteFile(String vehicleId, String documentId, String fileId) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${_document(vehicleId, documentId)}/files/$fileId',
    );
    return _documentOf(response);
  }

  /// [url] is the relative path from `DocumentFile.url`; Dio resolves it against the base URL and
  /// adds the bearer token.
  Future<Uint8List> fetchFile(String url) async {
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(response.data!);
  }

  /// Every write answers `{ "document": Document }`.
  static DocumentDto _documentOf(Response<Map<String, dynamic>> response) =>
      DocumentDto.fromJson(response.data!['document'] as Map<String, dynamic>);
}
