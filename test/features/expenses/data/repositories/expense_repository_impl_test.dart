import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/expenses/data/datasources/expense_remote_data_source.dart';
import 'package:car_assistant/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_failures.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_field.dart';
import 'package:car_assistant/features/expenses/domain/entities/new_expense.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../expense_fixtures.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio dio;
  late ExpenseRepositoryImpl repository;

  setUpAll(() => registerFallbackValue(RequestOptions()));

  setUp(() {
    dio = MockDio();
    repository = ExpenseRepositoryImpl(ExpenseRemoteDataSource(dio));
  });

  Response<T> ok<T>(T data, [int status = 200]) =>
      Response(requestOptions: RequestOptions(), statusCode: status, data: data);

  Future<Response<T>> httpError<T>(int status, Map<String, dynamic> body) => Future.error(
    DioException.badResponse(
      statusCode: status,
      requestOptions: RequestOptions(),
      response: Response(requestOptions: RequestOptions(), statusCode: status, data: body),
    ),
  );

  final newExpense = NewExpense(
    category: ExpenseCategory.thirdPartyInsurance,
    amount: 5850000,
    paidAt: DateTime.utc(2024, 11, 17),
  );

  test('getExpenses maps the list', () async {
    when(() => dio.get<Map<String, dynamic>>('/api/vehicles/v1/expenses')).thenAnswer(
      (_) async => ok({
        'expenses': [expenseJson(withAttachment: true)],
      }),
    );

    final result = await repository.getExpenses('v1');

    expect(result.toNullable(), [expense(withAttachment: true)]);
  });

  test('getExpenses turns a connection error into NetworkFailure', () async {
    when(() => dio.get<Map<String, dynamic>>(any())).thenAnswer(
      (_) =>
          Future.error(DioException.connectionError(requestOptions: RequestOptions(), reason: 'x')),
    );

    expect(
      await repository.getExpenses('v1'),
      const Left<Failure, List<Expense>>(NetworkFailure()),
    );
  });

  test('createExpense posts the body and maps the created expense', () async {
    when(
      () => dio.post<Map<String, dynamic>>('/api/vehicles/v1/expenses', data: any(named: 'data')),
    ).thenAnswer((_) async => ok({'expense': expenseJson()}, 201));

    expect(await repository.createExpense('v1', newExpense), Right<Failure, Expense>(expense()));
    final body =
        verify(
              () => dio.post<Map<String, dynamic>>(
                '/api/vehicles/v1/expenses',
                data: captureAny(named: 'data'),
              ),
            ).captured.single
            as Map<String, dynamic>;
    expect(body['category'], 'third_party_insurance');
    expect(body['paidAt'], '2024-11-17T00:00:00.000Z');
    expect(body['expiresAt'], isNull);
  });

  test('createExpense maps a 400 to InvalidExpenseFailure with the named fields', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenAnswer(
      (_) => httpError(400, {
        'error': {
          'message': 'Validation failed',
          'details': {
            'expiresAt': ['must be after paidAt'],
          },
        },
      }),
    );

    expect(
      await repository.createExpense('v1', newExpense),
      const Left<Failure, Expense>(
        InvalidExpenseFailure({ExpenseField.expiresAt}, 'Validation failed'),
      ),
    );
  });

  test('createExpense maps a 422 to ExpenseRejectedFailure', () async {
    when(() => dio.post<Map<String, dynamic>>(any(), data: any(named: 'data'))).thenAnswer(
      (_) => httpError(422, {
        'error': {'message': 'nope'},
      }),
    );

    expect(
      await repository.createExpense('v1', newExpense),
      const Left<Failure, Expense>(ExpenseRejectedFailure('nope')),
    );
  });

  test('uploadAttachment puts the multipart form and maps the expense', () async {
    when(
      () => dio.put<Map<String, dynamic>>(
        '/api/vehicles/v1/expenses/e1/attachment',
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer((_) async => ok({'expense': expenseJson(withAttachment: true)}));

    expect(
      await repository.uploadAttachment('v1', 'e1', pdfFile),
      Right<Failure, Expense>(expense(withAttachment: true)),
    );
    final form =
        verify(
              () => dio.put<Map<String, dynamic>>(
                '/api/vehicles/v1/expenses/e1/attachment',
                data: captureAny(named: 'data'),
                options: any(named: 'options'),
              ),
            ).captured.single
            as FormData;
    expect(form.files.single.key, 'attachment');
    expect(form.files.single.value.contentType.toString(), 'application/pdf');
  });

  test('uploadAttachment maps 400 and 413 to the attachment failures', () async {
    when(
      () => dio.put<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) => httpError(400, {
        'error': {'message': 'Unsupported type'},
      }),
    );
    expect(
      await repository.uploadAttachment('v1', 'e1', pdfFile),
      const Left<Failure, Expense>(InvalidAttachmentFailure('Unsupported type')),
    );

    when(
      () => dio.put<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) => httpError(413, {
        'error': {'message': 'Too large'},
      }),
    );
    expect(
      await repository.uploadAttachment('v1', 'e1', pdfFile),
      const Left<Failure, Expense>(AttachmentTooLargeFailure('Too large')),
    );
  });
}
