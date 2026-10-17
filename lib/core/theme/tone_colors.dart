import 'package:flutter/material.dart';

/// A tinted color set from Stitch: an icon tile (background, border, icon) plus a matching chip.
@immutable
class ToneColors {
  const ToneColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.chipBackground,
    required this.chipForeground,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final Color chipBackground;
  final Color chipForeground;

  static ToneColors lerp(ToneColors a, ToneColors b, double t) => ToneColors(
    background: Color.lerp(a.background, b.background, t)!,
    border: Color.lerp(a.border, b.border, t)!,
    foreground: Color.lerp(a.foreground, b.foreground, t)!,
    chipBackground: Color.lerp(a.chipBackground, b.chipBackground, t)!,
    chipForeground: Color.lerp(a.chipForeground, b.chipForeground, t)!,
  );

  @override
  bool operator ==(Object other) =>
      other is ToneColors &&
      other.background == background &&
      other.border == border &&
      other.foreground == foreground &&
      other.chipBackground == chipBackground &&
      other.chipForeground == chipForeground;

  @override
  int get hashCode => Object.hash(background, border, foreground, chipBackground, chipForeground);
}
