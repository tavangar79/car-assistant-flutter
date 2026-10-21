import 'package:equatable/equatable.dart';

import 'document_type.dart';

/// A checked document, ready to send (`POST` or `PATCH /api/vehicles/:id/documents`). Absent
/// optionals are `null`, which also clears them on an update.
class DocumentInput extends Equatable {
  const DocumentInput({
    required this.type,
    this.title,
    this.issuer,
    this.number,
    this.issuedAt,
    this.expiresAt,
    this.expiryReminder = true,
    this.notes,
  });

  final DocumentType type;
  final String? title;
  final String? issuer;
  final String? number;
  final DateTime? issuedAt;

  /// `null` means permanent.
  final DateTime? expiresAt;
  final bool expiryReminder;
  final String? notes;

  @override
  List<Object?> get props => [
    type,
    title,
    issuer,
    number,
    issuedAt,
    expiresAt,
    expiryReminder,
    notes,
  ];
}
