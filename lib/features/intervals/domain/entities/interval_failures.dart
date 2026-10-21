import '../../../../core/error/failure.dart';

/// The settings were rejected, by the client limits or by the server (HTTP 400). [ids] names the
/// invalid intervals; it is empty when the server did not say which.
class InvalidIntervalsFailure extends Failure {
  const InvalidIntervalsFailure(this.ids, [super.message = 'Invalid intervals']);

  final Set<String> ids;

  @override
  List<Object?> get props => [message, ids];
}
