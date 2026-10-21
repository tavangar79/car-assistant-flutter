import 'package:fpdart/fpdart.dart';

import 'document_draft.dart';
import 'document_failures.dart';
import 'document_field.dart';
import 'document_input.dart';

/// The backend's document rules, checked before sending so the user gets instant feedback.
abstract final class DocumentRules {
  static const titleMaxLength = 100;
  static const issuerMaxLength = 100;
  static const numberMaxLength = 50;
  static const notesMaxLength = 500;

  /// Files per document.
  static const maxFiles = 4;

  /// Checks [draft]; on success returns the document to send. A missing type is rejected
  /// (`type`), so is an expiry that is missing or not after the issue date (`expiresAt`).
  static Either<InvalidDocumentFailure, DocumentInput> validate(DocumentDraft draft) {
    final type = draft.type;
    final title = draft.title.trim();
    final issuer = draft.issuer.trim();
    final number = draft.number.trim();
    final notes = draft.notes.trim();
    final issuedAt = draft.issuedAt;
    final expiresAt = draft.hasExpiry ? draft.expiresAt : null;
    final badExpiry =
        draft.hasExpiry &&
        (expiresAt == null || (issuedAt != null && !expiresAt.isAfter(issuedAt)));
    final invalid = {
      if (type == null) DocumentField.type,
      if (title.length > titleMaxLength) DocumentField.title,
      if (issuer.length > issuerMaxLength) DocumentField.issuer,
      if (number.length > numberMaxLength) DocumentField.number,
      if (badExpiry) DocumentField.expiresAt,
      if (notes.length > notesMaxLength) DocumentField.notes,
    };
    if (invalid.isNotEmpty) return Left(InvalidDocumentFailure(invalid));
    String? orNull(String value) => value.isEmpty ? null : value;
    return Right(
      DocumentInput(
        type: type!,
        title: orNull(title),
        issuer: orNull(issuer),
        number: orNull(number),
        issuedAt: issuedAt,
        expiresAt: expiresAt,
        expiryReminder: draft.expiryReminder,
        notes: orNull(notes),
      ),
    );
  }
}
