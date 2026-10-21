import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/document_repository.dart';

/// The bytes of a stored document file (by its `url`).
class GetDocumentFile {
  const GetDocumentFile(this._repository);

  final DocumentRepository _repository;

  Future<Either<Failure, Uint8List>> call(String url) => _repository.fetchFile(url);
}
