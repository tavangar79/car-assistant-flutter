import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'tone_colors.dart';

/// Stitch tokens that have no [ColorScheme] slot. Read with `AppTones.of(context)`.
@immutable
class AppTones extends ThemeExtension<AppTones> {
  const AppTones({
    required this.muted,
    required this.label,
    required this.success,
    required this.amber,
    required this.neutral,
    required this.emerald,
  });

  /// Secondary text: descriptions, hints (Stitch `textMuted`, slate-500).
  final Color muted;

  /// Field labels and strong secondary text (Stitch slate-700).
  final Color label;

  /// Positive status, e.g. a complete phone number (Stitch emerald-600).
  final Color success;

  final ToneColors amber;
  final ToneColors neutral;
  final ToneColors emerald;

  static const light = AppTones(
    muted: AppColors.slate500,
    label: AppColors.slate700,
    success: AppColors.emerald600,
    amber: ToneColors(
      background: AppColors.amber50,
      border: AppColors.amber200,
      foreground: AppColors.amber600,
      chipBackground: AppColors.amber100,
      chipForeground: AppColors.amber800,
    ),
    neutral: ToneColors(
      background: AppColors.container,
      border: AppColors.containerHigh,
      foreground: AppColors.navy,
      chipBackground: AppColors.containerHigh,
      chipForeground: AppColors.slate,
    ),
    emerald: ToneColors(
      background: AppColors.emerald50,
      border: AppColors.emerald200,
      foreground: AppColors.emerald600,
      chipBackground: AppColors.emerald100,
      chipForeground: AppColors.emerald800,
    ),
  );

  static const dark = AppTones(
    muted: AppColors.outline,
    label: AppColors.slate300,
    success: AppColors.emerald400,
    amber: ToneColors(
      background: AppColors.amber950,
      border: AppColors.amber800,
      foreground: AppColors.amber,
      chipBackground: AppColors.amber900,
      chipForeground: AppColors.amber200,
    ),
    neutral: ToneColors(
      background: AppColors.slate,
      border: AppColors.slate700,
      foreground: AppColors.canvas,
      chipBackground: AppColors.slate700,
      chipForeground: AppColors.slate300,
    ),
    emerald: ToneColors(
      background: AppColors.emerald950,
      border: AppColors.emerald800,
      foreground: AppColors.emerald400,
      chipBackground: AppColors.emerald900,
      chipForeground: AppColors.emerald200,
    ),
  );

  static AppTones of(BuildContext context) => Theme.of(context).extension<AppTones>()!;

  @override
  AppTones copyWith({
    Color? muted,
    Color? label,
    Color? success,
    ToneColors? amber,
    ToneColors? neutral,
    ToneColors? emerald,
  }) => AppTones(
    muted: muted ?? this.muted,
    label: label ?? this.label,
    success: success ?? this.success,
    amber: amber ?? this.amber,
    neutral: neutral ?? this.neutral,
    emerald: emerald ?? this.emerald,
  );

  @override
  AppTones lerp(AppTones? other, double t) {
    if (other == null) return this;
    return AppTones(
      muted: Color.lerp(muted, other.muted, t)!,
      label: Color.lerp(label, other.label, t)!,
      success: Color.lerp(success, other.success, t)!,
      amber: ToneColors.lerp(amber, other.amber, t),
      neutral: ToneColors.lerp(neutral, other.neutral, t),
      emerald: ToneColors.lerp(emerald, other.emerald, t),
    );
  }
}
