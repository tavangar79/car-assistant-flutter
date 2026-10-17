import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/vehicle_providers.dart';

/// 48px rounded vehicle photo, loaded with the bearer token like the profile photo.
/// Shows a car icon while loading, on error, or when there is no [photoUrl].
class VehiclePhotoThumb extends ConsumerWidget {
  const VehiclePhotoThumb({super.key, required this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final url = photoUrl;
    final bytes = url == null ? null : ref.watch(vehiclePhotoBytesProvider(url)).value;
    return Container(
      width: 48,
      height: 48,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: bytes == null
          ? Icon(Icons.directions_car, size: 28, color: scheme.onSurfaceVariant)
          : Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              semanticLabel: AppLocalizations.of(context).vehiclePhotoLabel,
            ),
    );
  }
}
