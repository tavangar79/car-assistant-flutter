import '../../../../core/error/failure.dart';
import 'document_field.dart';

/// The document was rejected, by the client rules or by the server (HTTP 400). [fields] names the
/// invalid fields; it is empty when the server did not say which.
class InvalidDocumentFailure extends Failure {
  const InvalidDocumentFailure(this.fields, [super.message = 'Invalid document']);

  final Set<DocumentField> fields;

  @override
  List<Object?> get props => [message, fields];
}

/// The document already holds the most files allowed (client check or HTTP 422).
class DocumentFileLimitFailure extends Failure {
  const DocumentFileLimitFailure([super.message = 'Too many files']);
}
