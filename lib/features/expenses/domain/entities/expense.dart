import 'package:equatable/equatable.dart';

import 'expense_attachment.dart';
import 'expense_category.dart';
import 'expense_payment_method.dart';

/// One manual expense of a vehicle: insurance, fine, toll, inspection or other.
class Expense extends Equatable {
  const Expense({
    required this.id,
    required this.vehicleId,
    required this.category,
    required this.amount,
    required this.paidAt,
    required this.expiryReminder,
    required this.createdAt,
    required this.updatedAt,
    this.locked = false,
    this.title,
    this.referenceNumber,
    this.expiresAt,
    this.paymentMethod,
    this.issuer,
    this.attachment,
    this.attachmentUrl,
  });

  final String id;
  final String vehicleId;
  final ExpenseCategory category;

  /// Toman.
  final int amount;
  final String? title;
  final String? referenceNumber;
  final DateTime paidAt;
  final DateTime? expiresAt;

  /// Whether reminders fire before [expiresAt].
  final bool expiryReminder;
  final ExpensePaymentMethod? paymentMethod;
  final String? issuer;

  /// The attached document, or `null` when there is none.
  final ExpenseAttachment? attachment;

  /// Relative path of the document (loading it needs the bearer token), or `null`.
  final String? attachmentUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Created before the current owner got the vehicle (ownership transfer): read-only.
  final bool locked;

  bool get hasAttachment => attachment != null;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    category,
    amount,
    title,
    referenceNumber,
    paidAt,
    expiresAt,
    expiryReminder,
    paymentMethod,
    issuer,
    attachment,
    attachmentUrl,
    createdAt,
    updatedAt,
    locked,
  ];
}
