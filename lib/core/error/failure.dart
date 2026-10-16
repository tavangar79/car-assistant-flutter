import 'package:equatable/equatable.dart';

/// A known error. Data layers convert low-level exceptions into a [Failure]
/// so the UI never sees HTTP or JSON details. [message] is a developer-facing
/// (English) description for logs; the UI shows localized text instead.
class Failure extends Equatable implements Exception {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'Failure($message)';
}
