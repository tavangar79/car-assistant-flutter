import 'package:flutter/material.dart';

import '../../../../core/utils/localize_digits.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/plate.dart';
import '../../domain/entities/vehicle.dart';
import 'vehicle_photo_thumb.dart';

/// A vehicle in the garage list: photo, nickname, then make, model and plate.
class VehicleTile extends StatelessWidget {
  const VehicleTile({super.key, required this.vehicle});

  final Vehicle vehicle;

  /// The plate on one line with the locale's digits: `۷۲ ب ۳۴۵ ایران ۶۸`.
  static String plateText(Plate plate, AppLocalizations l10n) {
    String digits(String value) => localizeDigits(value, l10n.localeName);
    return l10n.vehiclePlateText(
      digits(plate.twoDigits),
      plate.letter,
      digits(plate.threeDigits),
      digits(plate.provinceCode),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      minTileHeight: 72,
      leading: VehiclePhotoThumb(photoUrl: vehicle.photoUrl),
      title: Text(vehicle.nickname),
      subtitle: Text(
        l10n.vehicleTileSubtitle(
          vehicle.make.name,
          vehicle.model.name,
          plateText(vehicle.plate, l10n),
        ),
      ),
    );
  }
}
