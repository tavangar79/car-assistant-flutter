import 'package:file_picker/file_picker.dart';

import '../../domain/entities/attachment_file.dart';

/// Picks the expense document (PDF, JPG or PNG) with the platform file picker. The size and
/// type limits are checked by the use case. Override `attachmentPickerProvider` in tests.
class AttachmentPicker {
  const AttachmentPicker();

  /// `null` when the user cancels. May throw when the picker is unavailable.
  Future<AttachmentFile?> pick() async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: AttachmentFile.allowedExtensions,
    );
    if (file == null) return null;
    return AttachmentFile(
      bytes: await file.readAsBytes(),
      fileName: file.name,
      mimeType: file.xFile.mimeType,
    );
  }
}
