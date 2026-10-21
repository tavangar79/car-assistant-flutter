import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../../../expenses/domain/entities/attachment_file.dart';

/// Where the upload card takes a new document from.
enum DocumentFileSource { camera, gallery, pdf }

/// Picks a document file for the upload card: a photo (downscaled to at most 2000px and
/// re-compressed, like the invoice photos) or a PDF. Size and type limits are checked by the use
/// case. Override `documentFilePickerProvider` in tests.
class DocumentFilePicker {
  const DocumentFilePicker();

  static const maxSide = 2000.0;
  static const quality = 85;

  /// `null` when the user cancels. May throw when the camera, gallery or picker is unavailable.
  Future<AttachmentFile?> pick(DocumentFileSource source) async {
    if (source == DocumentFileSource.pdf) {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );
      if (file == null) return null;
      return AttachmentFile(
        bytes: await file.readAsBytes(),
        fileName: file.name,
        mimeType: AttachmentFile.pdfType,
      );
    }
    final image = await ImagePicker().pickImage(
      source: source == DocumentFileSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSide,
      maxHeight: maxSide,
      imageQuality: quality,
    );
    if (image == null) return null;
    return AttachmentFile(
      bytes: await image.readAsBytes(),
      fileName: image.name,
      mimeType: image.mimeType,
    );
  }
}
