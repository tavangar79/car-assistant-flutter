import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/api_call.dart';
import '../../../../core/network/api_error_dto.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../../../expenses/domain/entities/expense_failures.dart';
import '../../domain/entities/document_failures.dart';
import '../../domain/entities/document_field.dart';
import '../../domain/entities/document_input.dart';
import '../../domain/entities/vehicle_document.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_data_source.dart';
import '../models/document_request_dto.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  const DocumentRepositoryImpl(this._remote);

  final DocumentRemoteDataSource _remote;

  @override
  Future<Either<Failure, List<VehicleDocument>>> getDocuments(String vehicleId) => apiCall(
    () async => (await _remote.fetchDocuments(vehicleId)).map((dto) => dto.toEntity()).toList(),
  );

  @override
  Future<Either<Failure, VehicleDocument>> createDocument(String vehicleId, DocumentInput input) =>
      apiCall(
        () async => (await _remote.createDocument(vehicleId, DocumentRequestDto(input))).toEntity(),
        onStatus: _documentFailure,
      );

  @override
  Future<Either<Failure, VehicleDocument>> updateDocument(
    String vehicleId,
    String documentId,
    DocumentInput input,
  ) => apiCall(
    () async =>
        (await _remote.updateDocument(vehicleId, documentId, DocumentRequestDto(input))).toEntity(),
    onStatus: _documentFailure,
  );

  static Failure? _documentFailure(int status, ApiErrorDto? error) => switch (status) {
    400 => InvalidDocumentFailure(
      fieldsOf(error?.details.keys ?? const []),
      error?.message ?? 'Invalid document',
    ),
    _ => null,
  };

  @override
  Future<Either<Failure, Unit>> deleteDocument(String vehicleId, String documentId) =>
      apiCall(() async {
        await _remote.deleteDocument(vehicleId, documentId);
        return unit;
      });

  @override
  Future<Either<Failure, VehicleDocument>> uploadFile(
    String vehicleId,
    String documentId,
    AttachmentFile file,
  ) => apiCall(
    () async => (await _remote.uploadFile(vehicleId, documentId, file)).toEntity(),
    onStatus: (status, error) => switch (status) {
      400 => InvalidAttachmentFailure(error?.message ?? 'Invalid file'),
      413 => AttachmentTooLargeFailure(error?.message ?? 'File too large'),
      422 => DocumentFileLimitFailure(error?.message ?? 'Too many files'),
      _ => null,
    },
  );

  @override
  Future<Either<Failure, VehicleDocument>> deleteFile(
    String vehicleId,
    String documentId,
    String fileId,
  ) => apiCall(() async => (await _remote.deleteFile(vehicleId, documentId, fileId)).toEntity());

  @override
  Future<Either<Failure, Uint8List>> fetchFile(String url) => apiCall(() => _remote.fetchFile(url));

  /// Maps the field names of a 400 `details` body to form fields. Unknown names are ignored.
  static Set<DocumentField> fieldsOf(Iterable<String> paths) => {
    for (final path in paths) ?_fieldOf(path.split('.').first),
  };

  static DocumentField? _fieldOf(String key) => switch (key) {
    'type' => DocumentField.type,
    'title' => DocumentField.title,
    'issuer' => DocumentField.issuer,
    'number' => DocumentField.number,
    'issuedAt' => DocumentField.issuedAt,
    'expiresAt' => DocumentField.expiresAt,
    'notes' => DocumentField.notes,
    _ => null,
  };
}
