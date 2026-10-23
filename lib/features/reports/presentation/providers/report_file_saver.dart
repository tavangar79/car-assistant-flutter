import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

/// Hands an exported report to the platform like the documents feature does: a download on the
/// web, a save dialog elsewhere. Override `reportFileSaverProvider` in tests.
class ReportFileSaver {
  const ReportFileSaver();

  /// May throw when saving is unavailable.
  Future<void> save(Uint8List bytes, {required String fileName, required String mimeType}) async {
    await FilePicker.saveFile(fileName: fileName, bytes: bytes, mimeType: mimeType);
  }
}
