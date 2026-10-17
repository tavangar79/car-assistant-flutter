import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/vehicle_photo.dart';
import '../../providers/vehicle_photo_picker.dart';
import '../../providers/vehicle_providers.dart';
import 'form_field_header.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import 'form_section_card.dart';

/// Optional vehicle photo: an upload tile that opens gallery / camera options, then shows the
/// chosen [photo]. The photo is only kept locally; the page uploads it on save.
class VehiclePhotoField extends ConsumerStatefulWidget {
  const VehiclePhotoField({super.key, required this.photo, required this.onChanged, this.error});

  final VehiclePhoto? photo;
  final ValueChanged<VehiclePhoto?> onChanged;
  final String? error;

  @override
  ConsumerState<VehiclePhotoField> createState() => _VehiclePhotoFieldState();
}

class _VehiclePhotoFieldState extends ConsumerState<VehiclePhotoField> {
  bool _pickFailed = false;

  Future<void> _openOptions() async {
    final l10n = AppLocalizations.of(context);
    final choice = await showModalBottomSheet<_PhotoAction>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OptionTile(
              Icons.photo_library_outlined,
              l10n.vehiclePhotoGalleryChip,
              _PhotoAction.gallery,
            ),
            _OptionTile(Icons.photo_camera_outlined, l10n.vehiclePhotoCamera, _PhotoAction.camera),
            if (widget.photo != null)
              _OptionTile(Icons.delete_outline, l10n.vehiclePhotoRemove, _PhotoAction.remove),
          ],
        ),
      ),
    );
    switch (choice) {
      case null:
        return;
      case _PhotoAction.remove:
        setState(() => _pickFailed = false);
        widget.onChanged(null);
      case _PhotoAction.gallery:
        await _pick(PhotoSource.gallery);
      case _PhotoAction.camera:
        await _pick(PhotoSource.camera);
    }
  }

  Future<void> _pick(PhotoSource source) async {
    setState(() => _pickFailed = false);
    try {
      final photo = await ref.read(vehiclePhotoPickerProvider).pick(source);
      if (photo != null && mounted) widget.onChanged(photo);
    } catch (_) {
      if (mounted) setState(() => _pickFailed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final error = _pickFailed ? l10n.vehiclePhotoPickFailed : widget.error;
    final bytes = widget.photo?.bytes;
    return FormSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FormFieldHeader(label: l10n.vehiclePhotoLabel, optional: true),
          const SizedBox(height: 8),
          Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _openOptions,
              child: bytes == null ? const _EmptyTile() : _Preview(bytes),
            ),
          ),
          if (error != null) ...[const SizedBox(height: 8), AuthErrorText(error)],
        ],
      ),
    );
  }
}

enum _PhotoAction { gallery, camera, remove }

class _OptionTile extends StatelessWidget {
  const _OptionTile(this.icon, this.label, this.action);

  final IconData icon;
  final String label;
  final _PhotoAction action;

  @override
  Widget build(BuildContext context) => ListTile(
    minTileHeight: 64,
    leading: Icon(icon),
    title: Text(label),
    onTap: () => Navigator.of(context).pop(action),
  );
}

/// Camera circle, title, limits and the gallery chip.
class _EmptyTile extends StatelessWidget {
  const _EmptyTile();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = AppTones.of(context).muted;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.photo_camera_outlined, size: 32, color: scheme.primary),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.vehiclePhotoTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.vehiclePhotoLimits(VehiclePhoto.maxMegabytes),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: muted),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_a_photo_outlined, size: 14, color: scheme.onSurface),
                const SizedBox(width: 6),
                Text(
                  l10n.vehiclePhotoGalleryChip,
                  style: theme.textTheme.labelSmall?.copyWith(color: scheme.onSurface),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The chosen photo, 144px high, with a "change photo" hint over it.
class _Preview extends StatelessWidget {
  const _Preview(this.bytes);

  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return SizedBox(
      height: 144,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.memory(
            bytes,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            semanticLabel: l10n.vehiclePhotoLabel,
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.inverseSurface.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit, size: 16, color: scheme.onInverseSurface),
                  const SizedBox(width: 6),
                  Text(
                    l10n.vehiclePhotoChange,
                    style: theme.textTheme.labelMedium?.copyWith(color: scheme.onInverseSurface),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
