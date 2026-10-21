import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/attachment_file.dart';
import '../entities/expense.dart';
import '../entities/new_expense.dart';

/// Contract owned by the domain layer; implemented in the data layer.
abstract interface class ExpenseRepository {
  /// The expenses of vehicle [vehicleId], newest `paidAt` first (at most 50).
  Future<Either<Failure, List<Expense>>> getExpenses(String vehicleId);

  /// `InvalidExpenseFailure` on 400, `ExpenseRejectedFailure` on 422.
  Future<Either<Failure, Expense>> createExpense(String vehicleId, NewExpense expense);

  /// Attaches (or replaces) the document; returns the expense with it.
  /// `InvalidAttachmentFailure` on 400, `AttachmentTooLargeFailure` on 413.
  Future<Either<Failure, Expense>> uploadAttachment(
    String vehicleId,
    String expenseId,
    AttachmentFile file,
  );
}
