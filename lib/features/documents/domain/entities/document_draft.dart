import 'package:equatable/equatable.dart';

import 'document_type.dart';
import 'vehicle_document.dart';

/// What the document form holds before it is checked. `DocumentRules.validate` turns it into a
/// `DocumentInput`.
class DocumentDraft extends Equatable {
  const DocumentDraft({
    this.type,
    this.title = '',
    this.issuer = '',
    this.number = '',
    this.issuedAt,
    this.hasExpiry = false,
    this.expiresAt,
    this.expiryReminder = true,
    this.notes = '',
  });

  /// The form filled in from a saved [document].
  factory DocumentDraft.fromDocument(VehicleDocument document) => DocumentDraft(
    type: document.type,
    title: document.title ?? '',
    issuer: document.issuer ?? '',
    number: document.number ?? '',
    issuedAt: document.issuedAt,
    hasExpiry: document.expiresAt != null,
    expiresAt: document.expiresAt,
    expiryReminder: document.expiryReminder,
    notes: document.notes ?? '',
  );

  final DocumentType? type;
  final String title;
  final String issuer;
  final String number;
  final DateTime? issuedAt;

  /// The expiry toggle; off means permanent. Only an on toggle sends [expiresAt].
  final bool hasExpiry;
  final DateTime? expiresAt;
  final bool expiryReminder;
  final String notes;

  DocumentDraft copyWith({
    DocumentType? Function()? type,
    String? title,
    String? issuer,
    String? number,
    DateTime? Function()? issuedAt,
    bool? hasExpiry,
    DateTime? Function()? expiresAt,
    bool? expiryReminder,
    String? notes,
  }) => DocumentDraft(
    type: type == null ? this.type : type(),
    title: title ?? this.title,
    issuer: issuer ?? this.issuer,
    number: number ?? this.number,
    issuedAt: issuedAt == null ? this.issuedAt : issuedAt(),
    hasExpiry: hasExpiry ?? this.hasExpiry,
    expiresAt: expiresAt == null ? this.expiresAt : expiresAt(),
    expiryReminder: expiryReminder ?? this.expiryReminder,
    notes: notes ?? this.notes,
  );

  @override
  List<Object?> get props => [
    type,
    title,
    issuer,
    number,
    issuedAt,
    hasExpiry,
    expiresAt,
    expiryReminder,
    notes,
  ];
}
