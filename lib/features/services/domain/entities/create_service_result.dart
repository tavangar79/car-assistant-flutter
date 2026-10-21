import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import 'service_visit.dart';

/// The saved [visit]. [invoiceFailure] is set when the visit was saved but its invoice was not.
class CreateServiceResult extends Equatable {
  const CreateServiceResult(this.visit, {this.invoiceFailure});

  final ServiceVisit visit;
  final Failure? invoiceFailure;

  @override
  List<Object?> get props => [visit, invoiceFailure];
}
