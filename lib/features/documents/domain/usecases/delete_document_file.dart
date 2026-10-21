import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/vehicle_document.dart';
import '../repositories/document_repository.dart';

/// Removes one file of a document; returns the document without it.
class DeleteDocumentFile {
  const DeleteDocumentFile(this._repository);

  final DocumentRepository _repository;

  Future<Either<Failure, VehicleDocument>> call(
    String vehicleId,
    String documentId,
    String fileId,
  ) => _repository.deleteFile(vehicleId, documentId, fileId);
}
