import 'package:equatable/equatable.dart';

/// One stored file of a document (its facts, not its bytes).
class DocumentFile extends Equatable {
  const DocumentFile({
    required this.id,
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.createdAt,
    required this.url,
  });

  static const pdfType = 'application/pdf';
  static const pngType = 'image/png';

  final String id;
  final String fileName;

  /// `application/pdf`, `image/jpeg` or `image/png`.
  final String contentType;
  final int sizeBytes;
  final DateTime createdAt;

  /// Relative path of the bytes (loading it needs the bearer token).
  final String url;

  bool get isPdf => contentType == pdfType;

  @override
  List<Object?> get props => [id, fileName, contentType, sizeBytes, createdAt, url];
}
