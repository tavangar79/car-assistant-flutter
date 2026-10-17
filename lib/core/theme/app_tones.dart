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
    required this.accentOnPrimary,
    required this.ok,
    required this.dueSoon,
    required this.overdue,
    required this.info,
    required this.amber,
    required this.neutral,
    required this.emerald,
  });

  /// Secondary text: descriptions, hints (Stitch `textMuted`, slate-500).
  final Color muted;

  /// Field labels and strong secondary text (Stitch slate-700).
  final Color label;

  /// Positive inline status, e.g. a complete phone number (Stitch emerald-600).
  final Color success;

  /// Accent glyph on a primary-filled control, e.g. the dock's add button (amber on navy).
  final Color accentOnPrimary;

  /// Status matrix: سالم, نزدیک به موعد, رسیدگی فوری, اطلاعاتی. Foreground in `foreground`,
  /// container in `background`.
  final ToneColors ok;
  final ToneColors dueSoon;
  final ToneColors overdue;
  final ToneColors info;

  final ToneColors amber;
  final ToneColors neutral;
  final ToneColors emerald;

  static const light = AppTones(
    muted: AppColors.slate500,
    label: AppColors.slate700,
    success: AppColors.emerald600,
    accentOnPrimary: AppColors.amber,
    ok: ToneColors.status(AppColors.statusOk, AppColors.statusOkContainer),
    dueSoon: ToneColors.status(AppColors.statusDueSoon, AppColors.statusDueSoonContainer),
    overdue: ToneColors.status(AppColors.statusOverdue, AppColors.statusOverdueContainer),
    info: ToneColors.status(AppColors.statusInfo, AppColors.statusInfoContainer),
    amber: ToneColors(
      background: AppColors.statusDueSoonContainer,
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
      background: AppColors.statusOkContainer,
      border: AppColors.emerald200,
      foreground: AppColors.emerald600,
      chipBackground: AppColors.emerald100,
      chipForeground: AppColors.emerald800,
    ),
  );

  static AppTones of(BuildContext context) => Theme.of(context).extension<AppTones>()!;

  @override
  AppTones copyWith({
    Color? muted,
    Color? label,
    Color? success,
    Color? accentOnPrimary,
    ToneColors? ok,
    ToneColors? dueSoon,
    ToneColors? overdue,
    ToneColors? info,
    ToneColors? amber,
    ToneColors? neutral,
    ToneColors? emerald,
  }) => AppTones(
    muted: muted ?? this.muted,
    label: label ?? this.label,
    success: success ?? this.success,
    accentOnPrimary: accentOnPrimary ?? this.accentOnPrimary,
    ok: ok ?? this.ok,
    dueSoon: dueSoon ?? this.dueSoon,
    overdue: overdue ?? this.overdue,
    info: info ?? this.info,
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
      accentOnPrimary: Color.lerp(accentOnPrimary, other.accentOnPrimary, t)!,
      ok: ToneColors.lerp(ok, other.ok, t),
      dueSoon: ToneColors.lerp(dueSoon, other.dueSoon, t),
      overdue: ToneColors.lerp(overdue, other.overdue, t),
      info: ToneColors.lerp(info, other.info, t),
      amber: ToneColors.lerp(amber, other.amber, t),
      neutral: ToneColors.lerp(neutral, other.neutral, t),
      emerald: ToneColors.lerp(emerald, other.emerald, t),
    );
  }
}
