import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Real-world colours of the vehicle form (Stitch "افزودن و ویرایش خودرو"): the blue band of an
/// Iranian plate and the six body-colour swatches. Read with `VehiclePalette.of(context)`.
@immutable
class VehiclePalette extends ThemeExtension<VehiclePalette> {
  const VehiclePalette({
    required this.plateBand,
    required this.onPlateBand,
    required this.white,
    required this.black,
    required this.silver,
    required this.blue,
    required this.red,
    required this.beige,
  });

  final Color plateBand;
  final Color onPlateBand;
  final Color white;
  final Color black;
  final Color silver;
  final Color blue;
  final Color red;
  final Color beige;

  static const light = VehiclePalette(
    plateBand: AppColors.plateBlue,
    onPlateBand: AppColors.white,
    white: AppColors.paintWhite,
    black: AppColors.paintBlack,
    silver: AppColors.paintSilver,
    blue: AppColors.paintBlue,
    red: AppColors.paintRed,
    beige: AppColors.paintBeige,
  );

  static VehiclePalette of(BuildContext context) =>
      Theme.of(context).extension<VehiclePalette>() ?? light;

  @override
  VehiclePalette copyWith({
    Color? plateBand,
    Color? onPlateBand,
    Color? white,
    Color? black,
    Color? silver,
    Color? blue,
    Color? red,
    Color? beige,
  }) => VehiclePalette(
    plateBand: plateBand ?? this.plateBand,
    onPlateBand: onPlateBand ?? this.onPlateBand,
    white: white ?? this.white,
    black: black ?? this.black,
    silver: silver ?? this.silver,
    blue: blue ?? this.blue,
    red: red ?? this.red,
    beige: beige ?? this.beige,
  );

  @override
  VehiclePalette lerp(VehiclePalette? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return VehiclePalette(
      plateBand: mix(plateBand, other.plateBand),
      onPlateBand: mix(onPlateBand, other.onPlateBand),
      white: mix(white, other.white),
      black: mix(black, other.black),
      silver: mix(silver, other.silver),
      blue: mix(blue, other.blue),
      red: mix(red, other.red),
      beige: mix(beige, other.beige),
    );
  }
}
