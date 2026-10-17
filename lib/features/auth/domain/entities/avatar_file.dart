import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// An image chosen as the profile photo, already downscaled by the picker.
class AvatarFile extends Equatable {
  const AvatarFile({required this.bytes, required this.fileName, this.mimeType});

  /// Largest upload the backend accepts (2 MB).
  static const maxBytes = 2 * 1024 * 1024;

  final Uint8List bytes;
  final String fileName;

  /// e.g. `image/jpeg`; `null` when the platform did not say (derived from [fileName] then).
  final String? mimeType;

  @override
  List<Object?> get props => [bytes, fileName, mimeType];
}
