import '../../domain/entities/document_file.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/vehicle_document.dart';

/// JSON shape of a document (the `Document` object of every response).
class DocumentDto {
  const DocumentDto({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.issuer,
    required this.number,
    required this.issuedAt,
    required this.expiresAt,
    required this.expiryReminder,
    required this.notes,
    required this.files,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentDto.fromJson(Map<String, dynamic> json) => DocumentDto(
    id: json['id'] as String,
    vehicleId: json['vehicleId'] as String,
    type: json['type'] as String,
    title: json['title'] as String?,
    issuer: json['issuer'] as String?,
    number: json['number'] as String?,
    issuedAt: _date(json['issuedAt']),
    expiresAt: _date(json['expiresAt']),
    expiryReminder: json['expiryReminder'] as bool,
    notes: json['notes'] as String?,
    files: (json['files'] as List<dynamic>)
        .map((file) => DocumentFileDto.fromJson(file as Map<String, dynamic>))
        .toList(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );

  static DateTime? _date(Object? value) => switch (value) {
    final String date => DateTime.parse(date),
    _ => null,
  };

  final String id;
  final String vehicleId;
  final String type;
  final String? title;
  final String? issuer;
  final String? number;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final bool expiryReminder;
  final String? notes;
  final List<DocumentFileDto> files;
  final DateTime createdAt;
  final DateTime updatedAt;

  VehicleDocument toEntity() => VehicleDocument(
    id: id,
    vehicleId: vehicleId,
    type: DocumentType.fromWire(type),
    title: title,
    issuer: issuer,
    number: number,
    issuedAt: issuedAt,
    expiresAt: expiresAt,
    expiryReminder: expiryReminder,
    notes: notes,
    files: files.map((file) => file.toEntity()).toList(),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}

/// `{ id, fileName, contentType, sizeBytes, createdAt, url }`.
class DocumentFileDto {
  const DocumentFileDto({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.createdAt,
    required this.url,
  });

  factory DocumentFileDto.fromJson(Map<String, dynamic> json) => DocumentFileDto(
    id: json['id'] as String,
    fileName: json['fileName'] as String,
    contentType: json['contentType'] as String,
    sizeBytes: (json['sizeBytes'] as num).toInt(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    url: json['url'] as String,
  );

  final String id;
  final String fileName;
  final String contentType;
  final int sizeBytes;
  final DateTime createdAt;
  final String url;

  DocumentFile toEntity() => DocumentFile(
    id: id,
    fileName: fileName,
    contentType: contentType,
    sizeBytes: sizeBytes,
    createdAt: createdAt,
    url: url,
  );
}
