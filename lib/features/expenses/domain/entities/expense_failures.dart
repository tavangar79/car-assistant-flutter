import '../../../../core/error/failure.dart';
import 'expense_field.dart';

/// The expense was rejected, by the client rules or by the server (HTTP 400). [fields] names the
/// invalid fields; it is empty when the server did not say which.
class InvalidExpenseFailure extends Failure {
  const InvalidExpenseFailure(this.fields, [super.message = 'Invalid expense']);

  final Set<ExpenseField> fields;

  @override
  List<Object?> get props => [message, fields];
}

/// The server refused an expense it understood (HTTP 422). [message] is the server's explanation.
class ExpenseRejectedFailure extends Failure {
  const ExpenseRejectedFailure(super.message);
}

/// The attachment is empty or not a PDF, JPEG or PNG (client check or HTTP 400).
class InvalidAttachmentFailure extends Failure {
  const InvalidAttachmentFailure([super.message = 'Invalid attachment']);
}

/// The attachment is larger than `AttachmentFile.maxBytes` (client check or HTTP 413).
class AttachmentTooLargeFailure extends Failure {
  const AttachmentTooLargeFailure([super.message = 'Attachment too large']);
}
