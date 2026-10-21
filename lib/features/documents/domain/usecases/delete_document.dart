import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/document_repository.dart';

/// Deletes a document with its files.
class DeleteDocument {
  const DeleteDocument(this._repository);

  final DocumentRepository _repository;

  Future<Either<Failure, Unit>> call(String vehicleId, String documentId) =>
      _repository.deleteDocument(vehicleId, documentId);
}
