import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/attachment_file.dart';
import '../../domain/entities/create_expense_result.dart';
import '../../domain/entities/expense_draft.dart';
import 'expense_providers.dart';

/// Saves the expense of the form. The state carries loading and the last error (an
/// `InvalidExpenseFailure`, `ExpenseRejectedFailure`, attachment failure or any other `Failure`).
class NewExpenseController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  /// Records [draft] for vehicle [vehicleId] with its optional [attachment]. Returns the result
  /// once the expense is saved (its `attachmentFailure` says whether the document was not), or
  /// `null` when nothing was saved. On success the vehicle's expenses are refreshed.
  Future<CreateExpenseResult?> submit(
    String vehicleId,
    ExpenseDraft draft, {
    AttachmentFile? attachment,
  }) async {
    state = const AsyncLoading();
    final result = await ref
        .read(createExpenseProvider)
        .call(vehicleId, draft, attachment: attachment);
    if (!ref.mounted) return null;
    switch (result) {
      case Right(value: final saved):
        ref.invalidate(expensesProvider(vehicleId));
        state = const AsyncData(null);
        return saved;
      case Left(value: final failure):
        state = AsyncError(failure, StackTrace.current);
        return null;
    }
  }

  /// Forgets the last error, e.g. once the user edits a field.
  void clearError() {
    if (state.hasError) state = const AsyncData(null);
  }
}
