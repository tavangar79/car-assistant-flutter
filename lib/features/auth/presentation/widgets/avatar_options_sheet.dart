import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_failures.dart';

/// What the user picked in the profile photo sheet.
enum AvatarAction { gallery, camera, remove }

/// The profile photo sheet: gallery, camera and, with a photo, remove. `null` when dismissed.
abstract final class AvatarOptionsSheet {
  static Future<AvatarAction?> show(BuildContext context, {required bool hasPhoto}) {
    final l10n = AppLocalizations.of(context);
    return showModalBottomSheet<AvatarAction>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionTile(
              Icons.photo_library_outlined,
              l10n.profileAvatarGallery,
              AvatarAction.gallery,
            ),
            _OptionTile(Icons.photo_camera_outlined, l10n.profileAvatarCamera, AvatarAction.camera),
            if (hasPhoto)
              _OptionTile(Icons.delete_outline, l10n.profileAvatarRemove, AvatarAction.remove),
          ],
        ),
      ),
    );
  }

  /// The localized message for an upload or removal [error].
  static String failureMessage(Object error, AppLocalizations l10n) => switch (error) {
    InvalidAvatarFailure() => l10n.profileAvatarInvalid,
    AvatarTooLargeFailure() => l10n.profileAvatarTooLarge,
    _ => l10n.authGenericError,
  };
}

class _OptionTile extends StatelessWidget {
  const _OptionTile(this.icon, this.label, this.action);

  final IconData icon;
  final String label;
  final AvatarAction action;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 64,
    leading: Icon(icon),
    title: Text(label),
    onTap: () => Navigator.of(context).pop(action),
  );
}
