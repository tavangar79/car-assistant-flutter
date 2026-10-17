import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/auth_failures.dart';
import '../../domain/entities/avatar_file.dart';
import '../providers/auth_providers.dart';
import '../providers/avatar_picker.dart';
import 'auth_error_text.dart';

/// Optional profile photo: a circle with the photo or the [initials], and a camera button that
/// picks a photo and uploads it right away (or removes the current one).
class AvatarSection extends ConsumerStatefulWidget {
  const AvatarSection({super.key, required this.initials});

  /// e.g. `ع.م`; empty shows a person icon.
  final String initials;

  @override
  ConsumerState<AvatarSection> createState() => _AvatarSectionState();
}

class _AvatarSectionState extends ConsumerState<AvatarSection> {
  /// The picked image, shown while it uploads and until the server copy is loaded.
  Uint8List? _preview;
  bool _pickFailed = false;

  Future<void> _openOptions(bool hasPhoto) async {
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<_AvatarAction>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionTile(
              Icons.photo_library_outlined,
              l10n.profileAvatarGallery,
              _AvatarAction.gallery,
            ),
            _OptionTile(
              Icons.photo_camera_outlined,
              l10n.profileAvatarCamera,
              _AvatarAction.camera,
            ),
            if (hasPhoto)
              _OptionTile(Icons.delete_outline, l10n.profileAvatarRemove, _AvatarAction.remove),
          ],
        ),
      ),
    );
    switch (choice) {
      case null:
        return;
      case _AvatarAction.remove:
        _remove();
      case _AvatarAction.gallery:
        _pickAndUpload(AvatarSource.gallery);
      case _AvatarAction.camera:
        _pickAndUpload(AvatarSource.camera);
    }
  }

  Future<void> _pickAndUpload(AvatarSource source) async {
    setState(() => _pickFailed = false);
    final file = await _pick(source);
    if (file == null || !mounted) return;
    setState(() => _preview = file.bytes);
    final ok = await ref.read(avatarControllerProvider.notifier).upload(file);
    if (!ok && mounted) setState(() => _preview = null);
  }

  /// `null` when cancelled or when the camera/gallery could not be opened (then flagged).
  Future<AvatarFile?> _pick(AvatarSource source) async {
    try {
      return await ref.read(avatarPickerProvider).pick(source);
    } catch (_) {
      if (mounted) setState(() => _pickFailed = true);
      return null;
    }
  }

  Future<void> _remove() async {
    setState(() => _pickFailed = false);
    final ok = await ref.read(avatarControllerProvider.notifier).remove();
    if (ok && mounted) setState(() => _preview = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(avatarControllerProvider);
    final avatarUrl = ref.watch(currentUserProvider)?.avatarUrl;
    final serverBytes = avatarUrl == null ? null : ref.watch(avatarBytesProvider(avatarUrl)).value;
    final image = _preview ?? serverBytes;
    final busy = state.isLoading;
    final error = _pickFailed
        ? l10n.profileAvatarPickFailed
        : switch (state.error) {
            null => null,
            InvalidAvatarFailure() => l10n.profileAvatarInvalid,
            AvatarTooLargeFailure() => l10n.profileAvatarTooLarge,
            _ => l10n.authGenericError,
          };
    return Column(
      children: [
        Semantics(
          button: true,
          label: l10n.profileAvatarEdit,
          child: InkWell(
            onTap: busy ? null : () => _openOptions(avatarUrl != null),
            customBorder: const CircleBorder(),
            child: SizedBox.square(
              dimension: 84,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  _AvatarCircle(image: image, initials: widget.initials, busy: busy),
                  const Positioned(left: 0, bottom: 0, child: _CameraBadge()),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.profileAvatarOptional,
          style: theme.textTheme.labelSmall?.copyWith(color: AppTones.of(context).muted),
        ),
        if (error != null) ...[
          const SizedBox(height: 6),
          Center(child: IntrinsicWidth(child: AuthErrorText(error))),
        ],
      ],
    );
  }
}

enum _AvatarAction { gallery, camera, remove }

class _OptionTile extends StatelessWidget {
  const _OptionTile(this.icon, this.label, this.action);

  final IconData icon;
  final String label;
  final _AvatarAction action;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 64,
    leading: Icon(icon),
    title: Text(label),
    onTap: () => Navigator.of(context).pop(action),
  );
}

class _AvatarCircle extends StatelessWidget {
  const _AvatarCircle({required this.image, required this.initials, required this.busy});

  final Uint8List? image;
  final String initials;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final photo = image;
    return Container(
      width: 76,
      height: 76,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.surfaceContainerHigh,
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.06), blurRadius: 12)],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (photo != null)
            Image.memory(photo, fit: BoxFit.cover, gaplessPlayback: true)
          else
            Center(
              child: initials.isEmpty
                  ? Icon(Icons.person_outline, size: 32, color: AppTones.of(context).muted)
                  : Text(
                      initials,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
            ),
          if (busy)
            ColoredBox(
              color: scheme.surface.withValues(alpha: 0.6),
              child: Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    semanticsLabel: AppLocalizations.of(context).profileAvatarUploading,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CameraBadge extends StatelessWidget {
  const _CameraBadge();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: scheme.primary,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: scheme.primary.withValues(alpha: 0.2), blurRadius: 4)],
      ),
      child: Icon(Icons.photo_camera, size: 15, color: scheme.onPrimary),
    );
  }
}
