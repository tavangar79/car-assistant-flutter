import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// A file chosen as the expense's document: a PDF, JPEG or PNG.
class AttachmentFile extends Equatable {
  const AttachmentFile({required this.bytes, required this.fileName, this.mimeType});

  /// Largest upload the backend accepts (10 MB).
  static const maxMegabytes = 10;
  static const maxBytes = maxMegabytes * 1024 * 1024;

  static const pdfType = 'application/pdf';
  static const allowedTypes = {pdfType, 'image/jpeg', 'image/png'};

  /// File extensions offered by the picker.
  static const allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];

  final Uint8List bytes;
  final String fileName;

  /// e.g. `application/pdf`; `null` when the platform did not say (derived from [fileName] then).
  final String? mimeType;

  /// The media type sent to the server: [mimeType], else by the file extension.
  String get contentType => mimeType ?? typeOf(fileName);

  bool get isPdf => contentType == pdfType;

  bool get isAllowedType => allowedTypes.contains(contentType);

  /// The media type for a file name: PDF, PNG, else JPEG.
  static String typeOf(String fileName) {
    final name = fileName.toLowerCase();
    if (name.endsWith('.pdf')) return pdfType;
    if (name.endsWith('.png')) return 'image/png';
    return 'image/jpeg';
  }

  @override
  List<Object?> get props => [bytes, fileName, mimeType];
}
