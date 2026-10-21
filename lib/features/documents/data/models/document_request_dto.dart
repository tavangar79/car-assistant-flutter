import '../../domain/entities/document_input.dart';

/// Body of `POST` and `PATCH /api/vehicles/:id/documents`: dates in ISO-8601 UTC, `null` for
/// absent optionals (which clears them on a `PATCH`).
class DocumentRequestDto {
  const DocumentRequestDto(this.input);

  final DocumentInput input;

  Map<String, dynamic> toJson() => {
    'type': input.type.wire,
    'title': input.title,
    'issuer': input.issuer,
    'number': input.number,
    'issuedAt': input.issuedAt?.toUtc().toIso8601String(),
    'expiresAt': input.expiresAt?.toUtc().toIso8601String(),
    'expiryReminder': input.expiryReminder,
    'notes': input.notes,
  };
}
