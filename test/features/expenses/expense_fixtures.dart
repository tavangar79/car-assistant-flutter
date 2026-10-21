import 'dart:typed_data';

import 'package:car_assistant/features/expenses/domain/entities/attachment_file.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_attachment.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_payment_method.dart';

/// Shared expense test data, for vehicle `v1` (`tara` in the vehicle fixtures).

const attachmentJson = {
  'fileName': 'بیمه‌نامه.pdf',
  'contentType': 'application/pdf',
  'sizeBytes': 1258291,
  'updatedAt': '2024-11-17T12:00:00.000Z',
};

final attachment = ExpenseAttachment(
  fileName: 'بیمه‌نامه.pdf',
  contentType: 'application/pdf',
  sizeBytes: 1258291,
  updatedAt: DateTime.utc(2024, 11, 17, 12),
);

/// The expense JSON of the contract; [withAttachment] attaches the document.
Map<String, dynamic> expenseJson({bool withAttachment = false}) => {
  'id': 'e1',
  'vehicleId': 'v1',
  'category': 'third_party_insurance',
  'amount': 5850000,
  'title': 'تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران',
  'referenceNumber': '1403/2480/991234',
  'paidAt': '2024-11-17T00:00:00.000Z',
  'expiresAt': '2025-11-17T00:00:00.000Z',
  'expiryReminder': true,
  'paymentMethod': 'online',
  'issuer': 'نمایندگی بیمه ایران (کد ۲۴۸۰)',
  'attachment': withAttachment ? attachmentJson : null,
  'attachmentUrl': withAttachment
      ? '/api/vehicles/v1/expenses/e1/attachment?v=1731844800000'
      : null,
  'createdAt': '2024-11-17T12:00:00.000Z',
  'updatedAt': '2024-11-17T12:00:00.000Z',
};

Expense expense({bool withAttachment = false}) => Expense(
  id: 'e1',
  vehicleId: 'v1',
  category: ExpenseCategory.thirdPartyInsurance,
  amount: 5850000,
  title: 'تمدید بیمه‌نامه شخص ثالث ۱۲ ماهه ایران',
  referenceNumber: '1403/2480/991234',
  paidAt: DateTime.utc(2024, 11, 17),
  expiresAt: DateTime.utc(2025, 11, 17),
  expiryReminder: true,
  paymentMethod: ExpensePaymentMethod.online,
  issuer: 'نمایندگی بیمه ایران (کد ۲۴۸۰)',
  attachment: withAttachment ? attachment : null,
  attachmentUrl: withAttachment ? '/api/vehicles/v1/expenses/e1/attachment?v=1731844800000' : null,
  createdAt: DateTime.utc(2024, 11, 17, 12),
  updatedAt: DateTime.utc(2024, 11, 17, 12),
);

/// A small PDF-named file for the attachment tests.
final pdfFile = AttachmentFile(
  bytes: Uint8List.fromList(List.filled(1200, 1)),
  fileName: 'بیمه‌نامه.pdf',
  mimeType: 'application/pdf',
);
