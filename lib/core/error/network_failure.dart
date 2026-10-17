import 'failure.dart';

/// The server could not be reached (no connection, DNS, timeout).
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Could not reach the server']);
}
