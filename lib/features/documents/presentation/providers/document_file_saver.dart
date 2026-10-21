import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../domain/entities/document_file.dart';

/// Hands a PDF to the platform: a download on the web, a save dialog elsewhere (the app has no
/// PDF viewer). Override `documentFileSaverProvider` in tests.
class DocumentFileSaver {
  const DocumentFileSaver();

  /// May throw when saving is unavailable.
  Future<void> save(Uint8List bytes, DocumentFile file) async {
    await FilePicker.saveFile(fileName: file.fileName, bytes: bytes, mimeType: file.contentType);
  }
}
