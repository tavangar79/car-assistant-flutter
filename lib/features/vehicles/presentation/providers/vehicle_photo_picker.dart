import 'package:image_picker/image_picker.dart';

import '../../domain/entities/vehicle_photo.dart';

enum PhotoSource { gallery, camera }

/// Picks a vehicle photo, downscaled to at most 1600px and re-compressed so it stays well under
/// the 5 MB upload limit (same approach as the profile photo's `AvatarPicker`).
/// Override `vehiclePhotoPickerProvider` in tests.
class VehiclePhotoPicker {
  const VehiclePhotoPicker();

  static const maxSide = 1600.0;
  static const quality = 85;

  /// `null` when the user cancels. May throw when the camera or gallery is unavailable.
  Future<VehiclePhoto?> pick(PhotoSource source) async {
    final file = await ImagePicker().pickImage(
      source: source == PhotoSource.camera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: maxSide,
      maxHeight: maxSide,
      imageQuality: quality,
    );
    if (file == null) return null;
    return VehiclePhoto(
      bytes: await file.readAsBytes(),
      fileName: file.name,
      mimeType: file.mimeType,
    );
  }
}
