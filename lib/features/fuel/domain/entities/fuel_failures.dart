import '../../../../core/error/failure.dart';
import 'fuel_field.dart';

/// The fill-up was rejected, by the client rules or by the server (HTTP 400). [fields] names the
/// invalid fields; it is empty when the server did not say which.
class InvalidFuelLogFailure extends Failure {
  const InvalidFuelLogFailure(this.fields, [super.message = 'Invalid fuel log']);

  final Set<FuelField> fields;

  @override
  List<Object?> get props => [message, fields];
}

/// The server refused a fill-up it understood (HTTP 422). [message] is the server's explanation.
class FuelLogRejectedFailure extends Failure {
  const FuelLogRejectedFailure(super.message);
}
