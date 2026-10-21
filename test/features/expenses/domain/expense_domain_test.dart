import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/expenses/domain/entities/attachment_file.dart';
import 'package:car_assistant/features/expenses/domain/entities/create_expense_result.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_draft.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_field.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_payment_method.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_rules.dart';
import 'package:car_assistant/features/expenses/domain/entities/new_expense.dart';
import 'package:car_assistant/features/expenses/domain/repositories/expense_repository.dart';
import 'package:car_assistant/features/expenses/domain/usecases/create_expense.dart';
import 'package:car_assistant/features/expenses/domain/usecases/get_expenses.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../expense_fixtures.dart';

class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45);
  final today = DateTime(2026, 10, 21);

  setUpAll(() {
    registerFallbackValue(NewExpense(category: ExpenseCategory.other, amount: 1, paidAt: today));
    registerFallbackValue(pdfFile);
  });

  group('ExpenseDraft', () {
    test('pays today at midnight by default and suggests +1 year for insurance', () {
      const draft = ExpenseDraft(category: ExpenseCategory.thirdPartyInsurance);
      expect(draft.paidAt(now), today);
      expect(draft.suggestedExpiry(now), DateTime(2027, 10, 21));
    });

    test('suggests no expiry for fines, tolls and other', () {
      for (final category in [ExpenseCategory.fine, ExpenseCategory.toll, ExpenseCategory.other]) {
        expect(ExpenseDraft(category: category).suggestedExpiry(now), isNull);
      }
      expect(const ExpenseDraft().suggestedExpiry(now), isNull);
    });
  });

  group('ExpenseRules', () {
    test('roundAmount rounds to the nearest 50,000', () {
      expect(ExpenseRules.roundAmount(5830000), 5850000);
      expect(ExpenseRules.roundAmount(5820000), 5800000);
      expect(ExpenseRules.roundAmount(0), 0);
    });

    test('validate returns the expense to send with trimmed optionals', () {
      final draft = ExpenseDraft(
        category: ExpenseCategory.thirdPartyInsurance,
        amount: 5850000,
        title: '  تمدید بیمه  ',
        referenceNumber: '',
        paidDay: DateTime(2026, 10, 20),
        hasExpiry: true,
        expiresAt: DateTime(2027, 10, 20),
        expiryReminder: false,
        paymentMethod: ExpensePaymentMethod.pos,
        issuer: ' نمایندگی ',
      );

      expect(
        ExpenseRules.validate(draft, now: now),
        Right<InvalidExpenseFailure, NewExpense>(
          NewExpense(
            category: ExpenseCategory.thirdPartyInsurance,
            amount: 5850000,
            title: 'تمدید بیمه',
            paidAt: DateTime(2026, 10, 20),
            expiresAt: DateTime(2027, 10, 20),
            expiryReminder: false,
            paymentMethod: ExpensePaymentMethod.pos,
            issuer: 'نمایندگی',
          ),
        ),
      );
    });

    test('validate drops the expiry when the toggle is off', () {
      final draft = ExpenseDraft(
        category: ExpenseCategory.fine,
        amount: 1,
        expiresAt: DateTime(2027),
      );
      expect(ExpenseRules.validate(draft, now: now).toNullable()!.expiresAt, isNull);
    });

    test('validate names every invalid field', () {
      final draft = ExpenseDraft(
        title: 'x' * 101,
        referenceNumber: 'y' * 61,
        paidDay: today.add(const Duration(days: 1)),
        hasExpiry: true,
        issuer: 'z' * 101,
      );

      expect(
        ExpenseRules.validate(draft, now: now),
        const Left<InvalidExpenseFailure, NewExpense>(
          InvalidExpenseFailure({
            ExpenseField.category,
            ExpenseField.amount,
            ExpenseField.title,
            ExpenseField.referenceNumber,
            ExpenseField.paidAt,
            ExpenseField.expiresAt,
            ExpenseField.issuer,
          }),
        ),
      );
    });

    test('validate rejects an expiry on or before the paid date and a zero amount', () {
      final draft = ExpenseDraft(
        category: ExpenseCategory.inspection,
        amount: 0,
        hasExpiry: true,
        expiresAt: today,
      );
      expect(ExpenseRules.validate(draft, now: now).getLeft().toNullable()!.fields, {
        ExpenseField.amount,
        ExpenseField.expiresAt,
      });
    });
  });

  group('AttachmentFile', () {
    test('derives the media type from the name when the platform gave none', () {
      expect(AttachmentFile(bytes: Uint8List(1), fileName: 'a.PDF').contentType, 'application/pdf');
      expect(AttachmentFile(bytes: Uint8List(1), fileName: 'a.png').contentType, 'image/png');
      expect(AttachmentFile(bytes: Uint8List(1), fileName: 'a.jpg').contentType, 'image/jpeg');
      expect(pdfFile.isPdf, isTrue);
      expect(
        AttachmentFile(bytes: Uint8List(1), fileName: 'a.gif', mimeType: 'image/gif').isAllowedType,
        isFalse,
      );
    });
  });

  group('use cases', () {
    late MockExpenseRepository repository;
    late CreateExpense createExpense;
    final draft = ExpenseDraft(
      category: ExpenseCategory.thirdPartyInsurance,
      amount: 5850000,
      hasExpiry: true,
      expiresAt: DateTime(2027, 10, 21),
    );

    setUp(() {
      repository = MockExpenseRepository();
      createExpense = CreateExpense(repository, now: () => now);
    });

    test('GetExpenses delegates to the repository', () async {
      when(() => repository.getExpenses('v1')).thenAnswer((_) async => Right([expense()]));

      final result = await GetExpenses(repository)('v1');

      expect(result.toNullable(), [expense()]);
    });

    test('checks the draft and sends the expense; no attachment means no upload', () async {
      when(() => repository.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));

      final result = await createExpense('v1', draft);

      expect(result, Right<Failure, CreateExpenseResult>(CreateExpenseResult(expense())));
      final sent =
          verify(() => repository.createExpense('v1', captureAny())).captured.single as NewExpense;
      expect(sent.paidAt, today);
      expect(sent.expiresAt, DateTime(2027, 10, 21));
      expect(sent.expiryReminder, isTrue);
      verifyNever(() => repository.uploadAttachment(any(), any(), any()));
    });

    test('uploads the attachment after the expense is saved', () async {
      when(() => repository.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));
      when(() => repository.uploadAttachment('v1', 'e1', pdfFile))
          .thenAnswer((_) async => Right(expense(withAttachment: true)));

      final result = await createExpense('v1', draft, attachment: pdfFile);

      expect(
        result,
        Right<Failure, CreateExpenseResult>(CreateExpenseResult(expense(withAttachment: true))),
      );
    });

    test('a failed upload still succeeds, with attachmentFailure set', () async {
      when(() => repository.createExpense('v1', any())).thenAnswer((_) async => Right(expense()));
      when(() => repository.uploadAttachment('v1', 'e1', pdfFile))
          .thenAnswer((_) async => const Left(AttachmentTooLargeFailure()));

      final result = await createExpense('v1', draft, attachment: pdfFile);

      expect(
        result,
        Right<Failure, CreateExpenseResult>(
          CreateExpenseResult(expense(), attachmentFailure: const AttachmentTooLargeFailure()),
        ),
      );
    });

    test('rejects a wrong file type or an oversized file before sending anything', () async {
      final gif = AttachmentFile(bytes: Uint8List(1), fileName: 'a.gif', mimeType: 'image/gif');
      final huge = AttachmentFile(bytes: Uint8List(AttachmentFile.maxBytes + 1), fileName: 'a.pdf');

      expect(
        await createExpense('v1', draft, attachment: gif),
        const Left<Failure, CreateExpenseResult>(InvalidAttachmentFailure()),
      );
      expect(
        await createExpense('v1', draft, attachment: huge),
        const Left<Failure, CreateExpenseResult>(AttachmentTooLargeFailure()),
      );
      verifyNever(() => repository.createExpense(any(), any()));
    });

    test('rejects an invalid draft without calling the repository', () async {
      final result = await createExpense('v1', const ExpenseDraft());

      expect(result.getLeft().toNullable()!, isA<InvalidExpenseFailure>());
      verifyNever(() => repository.createExpense(any(), any()));
    });

    test('passes a repository failure through', () async {
      when(() => repository.createExpense('v1', any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));

      expect(
        await createExpense('v1', draft),
        const Left<Failure, CreateExpenseResult>(NetworkFailure()),
      );
    });
  });
}
