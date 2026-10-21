import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../providers/vehicle_providers.dart';

/// Rounded vehicle photo ([size] px, 48 by default), loaded with the bearer token like the profile
/// photo. Shows a car icon while loading, on error, or when there is no [photoUrl].
class VehiclePhotoThumb extends ConsumerWidget {
  const VehiclePhotoThumb({super.key, required this.photoUrl, this.size = 48, this.radius = 8});

  final String? photoUrl;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final url = photoUrl;
    final bytes = url == null ? null : ref.watch(vehiclePhotoBytesProvider(url)).value;
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: bytes == null
          ? Icon(Icons.directions_car, size: size * 28 / 48, color: scheme.onSurfaceVariant)
          : Image.memory(
              bytes,
              fit: BoxFit.cover,
              gaplessPlayback: true,
              semanticLabel: AppLocalizations.of(context).vehiclePhotoLabel,
            ),
    );
  }
}
