import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../entities/document_input.dart';
import '../entities/vehicle_document.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class DocumentRepository {
  /// The documents of vehicle [vehicleId]: expiring soonest first, permanent ones last.
  Future<Either<Failure, List<VehicleDocument>>> getDocuments(String vehicleId);

  /// `InvalidDocumentFailure` on 400.
  Future<Either<Failure, VehicleDocument>> createDocument(String vehicleId, DocumentInput input);

  /// Replaces every field of the document. `InvalidDocumentFailure` on 400.
  Future<Either<Failure, VehicleDocument>> updateDocument(
    String vehicleId,
    String documentId,
    DocumentInput input,
  );

  /// Deletes the document, its files and its notifications.
  Future<Either<Failure, Unit>> deleteDocument(String vehicleId, String documentId);

  /// Adds a file; returns the document with it. `InvalidAttachmentFailure` on 400,
  /// `AttachmentTooLargeFailure` on 413, `DocumentFileLimitFailure` on 422.
  Future<Either<Failure, VehicleDocument>> uploadFile(
    String vehicleId,
    String documentId,
    AttachmentFile file,
  );

  /// Removes a file; returns the document without it.
  Future<Either<Failure, VehicleDocument>> deleteFile(
    String vehicleId,
    String documentId,
    String fileId,
  );

  /// The decrypted bytes of a `DocumentFile.url`.
  Future<Either<Failure, Uint8List>> fetchFile(String url);
}
