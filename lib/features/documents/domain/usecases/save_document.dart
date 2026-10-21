import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../expenses/domain/entities/attachment_file.dart';
import '../../../expenses/domain/entities/expense_failures.dart';
import '../entities/document_draft.dart';
import '../entities/document_failures.dart';
import '../entities/document_input.dart';
import '../entities/document_rules.dart';
import '../entities/save_document_result.dart';
import '../entities/vehicle_document.dart';
import '../repositories/document_repository.dart';

/// Creates a document (or updates [documentId]) for a vehicle, then uploads its new files one by
/// one.
///
/// The draft and the files are checked before anything is sent: each file must be a PDF, JPEG or
/// PNG of at most 10 MB, and [existingFileCount] plus the new ones at most four. When the document
/// is saved but an upload fails, the result is still a success, with `fileFailure` set.
class SaveDocument {
  const SaveDocument(this._repository);

  final DocumentRepository _repository;

  Future<Either<Failure, SaveDocumentResult>> call(
    String vehicleId,
    DocumentDraft draft, {
    String? documentId,
    List<AttachmentFile> files = const [],
    int existingFileCount = 0,
  }) async {
    if (existingFileCount + files.length > DocumentRules.maxFiles) {
      return const Left(DocumentFileLimitFailure());
    }
    for (final file in files) {
      if (file.bytes.isEmpty || !file.isAllowedType) return const Left(InvalidAttachmentFailure());
      if (file.bytes.length > AttachmentFile.maxBytes) {
        return const Left(AttachmentTooLargeFailure());
      }
    }
    final DocumentInput input;
    switch (DocumentRules.validate(draft)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final checked):
        input = checked;
    }

    VehicleDocument document;
    switch (await (documentId == null
        ? _repository.createDocument(vehicleId, input)
        : _repository.updateDocument(vehicleId, documentId, input))) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final saved):
        document = saved;
    }

    // The document is saved either way; a failed upload only loses that file and the next ones.
    for (final file in files) {
      switch (await _repository.uploadFile(vehicleId, document.id, file)) {
        case Left(value: final failure):
          return Right(SaveDocumentResult(document, fileFailure: failure));
        case Right(value: final updated):
          document = updated;
      }
    }
    return Right(SaveDocumentResult(document));
  }
}
