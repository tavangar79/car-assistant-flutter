import 'package:dio/dio.dart';

import '../../domain/entities/attachment_file.dart';
import '../models/create_expense_request_dto.dart';
import '../models/expense_dto.dart';

/// HTTP calls for expenses. Throws [DioException] on a non-2xx response.
class ExpenseRemoteDataSource {
  const ExpenseRemoteDataSource(this._dio);

  final Dio _dio;

  static String _expenses(String vehicleId) => '/api/vehicles/$vehicleId/expenses';

  Future<List<ExpenseDto>> fetchExpenses(String vehicleId) async {
    final response = await _dio.get<Map<String, dynamic>>(_expenses(vehicleId));
    return (response.data!['expenses'] as List<dynamic>)
        .map((json) => ExpenseDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ExpenseDto> createExpense(String vehicleId, CreateExpenseRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      _expenses(vehicleId),
      data: request.toJson(),
    );
    return _expense(response);
  }

  /// `multipart/form-data` with the single file field `attachment`.
  Future<ExpenseDto> uploadAttachment(
    String vehicleId,
    String expenseId,
    AttachmentFile file,
  ) async {
    final form = FormData.fromMap({
      'attachment': MultipartFile.fromBytes(
        file.bytes,
        filename: file.fileName,
        contentType: DioMediaType.parse(file.contentType),
      ),
    });
    final response = await _dio.put<Map<String, dynamic>>(
      '${_expenses(vehicleId)}/$expenseId/attachment',
      data: form,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    return _expense(response);
  }

  /// Every write answers `{ "expense": Expense }`.
  static ExpenseDto _expense(Response<Map<String, dynamic>> response) =>
      ExpenseDto.fromJson(response.data!['expense'] as Map<String, dynamic>);
}
