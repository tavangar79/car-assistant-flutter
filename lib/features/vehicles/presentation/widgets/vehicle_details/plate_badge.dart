import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/theme/vehicle_palette.dart';
import '../../../../../core/utils/localize_digits.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/plate.dart';
import '../plate_text.dart';

/// A read-only Iranian plate, 44px high (Stitch "جزئیات خودرو"): the blue band, the two digits,
/// letter and three digits, then "ایران" over the province code. Laid out right to left like
/// `PlateInput`. Read by screen readers as one line.
///
/// [dense] is the 32px plate of the garage cards (Stitch "گاراژ من").
class PlateBadge extends StatelessWidget {
  const PlateBadge({super.key, required this.plate, this.dense = false});

  final Plate plate;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final palette = VehiclePalette.of(context);
    String digits(String value) => localizeDigits(value, l10n.localeName);
    final bandStyle = TextStyle(
      fontSize: 7,
      height: 1,
      fontWeight: FontWeight.w700,
      color: palette.onPlateBand,
    );
    final digitsStyle = dense
        ? theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800, color: scheme.onSurface)
        : theme.textTheme.headlineLarge?.copyWith(color: scheme.onSurface);
    return Semantics(
      label: plateText(plate, l10n),
      excludeSemantics: true,
      child: Container(
        height: dense ? 32 : 44,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: scheme.outlineVariant),
          boxShadow: [BoxShadow(color: scheme.shadow.withValues(alpha: 0.05), blurRadius: 3)],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: dense ? 18 : 28,
                color: palette.plateBand,
                padding: EdgeInsets.symmetric(vertical: dense ? 2 : 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(child: Text(l10n.vehiclePlateBandTop, style: bandStyle)),
                    SvgPicture.asset(
                      'assets/images/flag_ir.svg',
                      width: dense ? 12 : 14,
                      height: dense ? 6 : 8,
                    ),
                    FittedBox(child: Text(l10n.vehiclePlateBandBottom, style: bandStyle)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dense ? 8 : 12),
                child: Row(
                  children: [
                    Text(digits(plate.twoDigits), style: digitsStyle),
                    SizedBox(width: dense ? 6 : 8),
                    Text(
                      plate.letter,
                      style: (dense ? theme.textTheme.labelMedium : theme.textTheme.headlineMedium)
                          ?.copyWith(fontWeight: FontWeight.w700, color: scheme.onSurface),
                    ),
                    SizedBox(width: dense ? 6 : 8),
                    Text(digits(plate.threeDigits), style: digitsStyle),
                  ],
                ),
              ),
              Container(
                constraints: BoxConstraints(minWidth: dense ? 28 : 42),
                padding: EdgeInsets.symmetric(horizontal: dense ? 6 : 8),
                color: scheme.surfaceContainerLow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.vehiclePlateIran,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: dense ? 6 : 9,
                        height: 1,
                        color: AppTones.of(context).muted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      digits(plate.provinceCode),
                      style: (dense ? theme.textTheme.labelMedium : theme.textTheme.headlineSmall)
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: scheme.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
