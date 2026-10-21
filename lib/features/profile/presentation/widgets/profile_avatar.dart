import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/entities/avatar_file.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../auth/presentation/providers/avatar_picker.dart';
import '../../../auth/presentation/widgets/avatar_options_sheet.dart';

/// The 64px round profile photo with a camera strip at the bottom. Tapping it opens the photo
/// sheet and uploads or removes right away (the existing avatar flow); errors show a snack bar.
class ProfileAvatar extends ConsumerStatefulWidget {
  const ProfileAvatar({super.key, required this.initials});

  /// e.g. `ع.م`; empty shows a person icon.
  final String initials;

  @override
  ConsumerState<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends ConsumerState<ProfileAvatar> {
  Future<void> _openOptions(bool hasPhoto) async {
    final l10n = AppLocalizations.of(context);
    final choice = await AvatarOptionsSheet.show(context, hasPhoto: hasPhoto);
    if (!mounted || choice == null) return;
    final controller = ref.read(avatarControllerProvider.notifier);
    if (choice == AvatarAction.remove) {
      if (!await controller.remove()) _showError();
      return;
    }
    final AvatarFile? file;
    try {
      file = await ref
          .read(avatarPickerProvider)
          .pick(choice == AvatarAction.camera ? AvatarSource.camera : AvatarSource.gallery);
    } catch (_) {
      _showMessage(l10n.profileAvatarPickFailed);
      return;
    }
    if (file == null || !mounted) return;
    if (!await controller.upload(file)) _showError();
  }

  void _showError() {
    final error = ref.read(avatarControllerProvider).error;
    if (error == null || !mounted) return;
    _showMessage(AvatarOptionsSheet.failureMessage(error, AppLocalizations.of(context)));
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final busy = ref.watch(avatarControllerProvider).isLoading;
    final avatarUrl = ref.watch(currentUserProvider)?.avatarUrl;
    final photo = avatarUrl == null ? null : ref.watch(avatarBytesProvider(avatarUrl)).value;
    return Semantics(
      button: true,
      label: l10n.profileAvatarEdit,
      child: InkWell(
        onTap: busy ? null : () => _openOptions(avatarUrl != null),
        customBorder: const CircleBorder(),
        child: Container(
          width: 64,
          height: 64,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.surfaceContainerHigh,
            boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.06), blurRadius: 3)],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (photo != null)
                Image.memory(photo, fit: BoxFit.cover, gaplessPlayback: true)
              else
                Center(
                  child: widget.initials.isEmpty
                      ? Icon(Icons.person_outline, size: 28, color: scheme.onSurfaceVariant)
                      : Text(
                          widget.initials,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ColoredBox(
                  color: scheme.primary.withValues(alpha: 0.4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Icon(Icons.photo_camera, size: 14, color: scheme.onPrimary),
                  ),
                ),
              ),
              if (busy)
                ColoredBox(
                  color: scheme.surface.withValues(alpha: 0.6),
                  child: const Center(
                    child: SizedBox.square(
                      dimension: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
