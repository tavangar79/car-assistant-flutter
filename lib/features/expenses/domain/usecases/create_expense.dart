import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/attachment_file.dart';
import '../entities/create_expense_result.dart';
import '../entities/expense.dart';
import '../entities/expense_draft.dart';
import '../entities/expense_failures.dart';
import '../entities/expense_rules.dart';
import '../entities/new_expense.dart';
import '../repositories/expense_repository.dart';

/// Records an expense for a vehicle, then uploads its optional document.
///
/// The draft and the file are checked before anything is sent. When the expense is saved but the
/// upload fails, the result is still a success, with `attachmentFailure` set.
class CreateExpense {
  const CreateExpense(this._repository, {required this.now});

  final ExpenseRepository _repository;

  /// The current time; a paid date after it is rejected.
  final DateTime Function() now;

  Future<Either<Failure, CreateExpenseResult>> call(
    String vehicleId,
    ExpenseDraft draft, {
    AttachmentFile? attachment,
  }) async {
    if (attachment != null && (attachment.bytes.isEmpty || !attachment.isAllowedType)) {
      return const Left(InvalidAttachmentFailure());
    }
    if (attachment != null && attachment.bytes.length > AttachmentFile.maxBytes) {
      return const Left(AttachmentTooLargeFailure());
    }
    final NewExpense expense;
    switch (ExpenseRules.validate(draft, now: now())) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final checked):
        expense = checked;
    }

    final Expense saved;
    switch (await _repository.createExpense(vehicleId, expense)) {
      case Left(value: final failure):
        return Left(failure);
      case Right(value: final created):
        saved = created;
    }
    if (attachment == null) return Right(CreateExpenseResult(saved));

    // The expense is saved either way; a failed upload only loses the document.
    final uploaded = await _repository.uploadAttachment(vehicleId, saved.id, attachment);
    return Right(
      uploaded.match(
        (failure) => CreateExpenseResult(saved, attachmentFailure: failure),
        CreateExpenseResult.new,
      ),
    );
  }
}
