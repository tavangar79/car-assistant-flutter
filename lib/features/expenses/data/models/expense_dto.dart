import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_attachment.dart';
import '../../domain/entities/expense_category.dart';
import '../../domain/entities/expense_payment_method.dart';

/// JSON shape of an expense (the `Expense` object of every response).
class ExpenseDto {
  const ExpenseDto({
    required this.id,
    required this.vehicleId,
    required this.category,
    required this.amount,
    required this.title,
    required this.referenceNumber,
    required this.paidAt,
    required this.expiresAt,
    required this.expiryReminder,
    required this.paymentMethod,
    required this.issuer,
    required this.attachment,
    required this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseDto.fromJson(Map<String, dynamic> json) => ExpenseDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    category: json['category'] as String,
    amount: json['amount'] as int,
    title: json['title'] as String?,
    referenceNumber: json['referenceNumber'] as String?,
    paidAt: DateTime.parse(json['paidAt'] as String),
    expiresAt: switch (json['expiresAt']) {
      final String date => DateTime.parse(date),
      _ => null,
    },
    expiryReminder: json['expiryReminder'] as bool,
    paymentMethod: json['paymentMethod'] as String?,
    issuer: json['issuer'] as String?,
    attachment: switch (json['attachment']) {
      final Map<String, dynamic> attachment => ExpenseAttachmentDto.fromJson(attachment),
      _ => null,
    },
    attachmentUrl: json['attachmentUrl'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  final String id;
  final String vehicleId;
  final String category;
  final int amount;
  final String? title;
  final String? referenceNumber;
  final DateTime paidAt;
  final DateTime? expiresAt;
  final bool expiryReminder;
  final String? paymentMethod;
  final String? issuer;
  final ExpenseAttachmentDto? attachment;
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense toEntity() => Expense(
    id: id,
    vehicleId: vehicleId,
    category: ExpenseCategory.fromWire(category),
    amount: amount,
    title: title,
    referenceNumber: referenceNumber,
    paidAt: paidAt,
    expiresAt: expiresAt,
    expiryReminder: expiryReminder,
    paymentMethod: switch (paymentMethod) {
      final method? => ExpensePaymentMethod.fromWire(method),
      null => null,
    },
    issuer: issuer,
    attachment: attachment?.toEntity(),
    attachmentUrl: attachmentUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// `{ fileName, contentType, sizeBytes, updatedAt }`.
class ExpenseAttachmentDto {
  const ExpenseAttachmentDto({
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.updatedAt,
  });

  factory ExpenseAttachmentDto.fromJson(Map<String, dynamic> json) => ExpenseAttachmentDto(
    fileName: json['fileName'] as String,
    contentType: json['contentType'] as String,
    sizeBytes: json['sizeBytes'] as int,
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  final String fileName;
  final String contentType;
  final int sizeBytes;
  final DateTime updatedAt;

  ExpenseAttachment toEntity() => ExpenseAttachment(
    fileName: fileName,
    contentType: contentType,
    sizeBytes: sizeBytes,
    updatedAt: updatedAt,
  );
}
