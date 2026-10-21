import 'package:image_picker/image_picker.dart';

import '../../domain/entities/invoice_file.dart';

enum InvoiceSource { gallery, camera }

/// Picks an invoice photo, downscaled to at most 1600px and re-compressed so it stays well under
/// the 5 MB upload limit (same approach as the vehicle photo). Override `invoicePickerProvider`
/// in tests.
class InvoicePicker {
  const InvoicePicker();

  static const maxSide = 1600.0;
  static const quality = 85;

  /// `null` when the user cancels. May throw when the camera or gallery is unavailable.
  Future<InvoiceFile?> pick(InvoiceSource source) async {
    final file = await ImagePicker().pickImage(
      source: source == InvoiceSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSide,
      maxHeight: maxSide,
      imageQuality: quality,
    );
    if (file == null) return null;
    return InvoiceFile(
      bytes: await file.readAsBytes(),
      fileName: file.name,
      mimeType: file.mimeType,
    );
  }
}
