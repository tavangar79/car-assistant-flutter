import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import 'expense.dart';

/// The saved [expense]. [attachmentFailure] is set when the expense was saved but its document
/// was not.
class CreateExpenseResult extends Equatable {
  const CreateExpenseResult(this.expense, {this.attachmentFailure});

  final Expense expense;
  final Failure? attachmentFailure;

  @override
  List<Object?> get props => [expense, attachmentFailure];
}
