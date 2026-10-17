import 'package:image_picker/image_picker.dart';

import '../../domain/entities/avatar_file.dart';

enum AvatarSource { gallery, camera }

/// Picks a profile photo, downscaled to at most 1024px and re-compressed so it stays well under
/// the 2 MB upload limit. Override `avatarPickerProvider` in tests.
class AvatarPicker {
  const AvatarPicker();

  static const maxSide = 1024.0;
  static const quality = 80;

  /// `null` when the user cancels. May throw when the camera or gallery is unavailable.
  Future<AvatarFile?> pick(AvatarSource source) async {
    final file = await ImagePicker().pickImage(
      source: source == AvatarSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSide,
      maxHeight: maxSide,
      imageQuality: quality,
    );
    if (file == null) return null;
    return AvatarFile(
      bytes: await file.readAsBytes(),
      fileName: file.name,
      mimeType: file.mimeType,
    );
  }
}
