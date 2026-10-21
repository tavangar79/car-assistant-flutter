import '../../../../core/error/failure.dart';
import 'service_field.dart';

/// The visit was rejected, by the client rules or by the server (HTTP 400). [fields] names the
/// invalid fields; it is empty when the server did not say which.
class InvalidServiceFailure extends Failure {
  const InvalidServiceFailure(this.fields, [super.message = 'Invalid service visit']);

  final Set<ServiceField> fields;

  @override
  List<Object?> get props => [message, fields];
}

/// The server refused a visit it understood (HTTP 422). A future date is a 400 on `serviceDate`.
/// [message] is the server's explanation.
class ServiceRejectedFailure extends Failure {
  const ServiceRejectedFailure(super.message);
}

/// The invoice is empty or not a JPEG, PNG or WebP image (client check or HTTP 400).
class InvalidInvoiceFailure extends Failure {
  const InvalidInvoiceFailure([super.message = 'Invalid invoice image']);
}

/// The invoice is larger than `InvoiceFile.maxBytes` (client check or HTTP 413).
class InvoiceTooLargeFailure extends Failure {
  const InvoiceTooLargeFailure([super.message = 'Invoice image too large']);
}
