import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_tones.dart';
import 'vehicle_palette.dart';

/// The app's single theme: the light Stitch design system. The app always runs in light mode.
abstract final class AppTheme {
  /// Corner radius of inputs and interactive buttons (Stitch: 12px).
  static const radius = BorderRadius.all(Radius.circular(12));

  /// Corner radius of cards (Stitch: 16px, `rounded-lg`).
  static const cardRadius = BorderRadius.all(Radius.circular(16));

  static final light = _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.navy,
      onPrimary: AppColors.white,
      secondary: AppColors.slate,
      onSecondary: AppColors.white,
      tertiary: AppColors.amber,
      onTertiary: AppColors.navy,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.canvas,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      surfaceDim: AppColors.containerHigh,
      surfaceBright: AppColors.white,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.canvas,
      surfaceContainer: AppColors.container,
      surfaceContainerHigh: AppColors.containerHigh,
      surfaceContainerHighest: AppColors.containerHighest,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      outline: AppColors.outline,
      outlineVariant: AppColors.containerHigh,
      // Stitch shadows are tinted with the navy: rgba(15, 23, 42, …).
      shadow: AppColors.navy,
    ),
    AppTones.light,
  );

  static ThemeData _build(ColorScheme scheme, AppTones tones) {
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );
    const shape = RoundedRectangleBorder(borderRadius: radius);
    return ThemeData(
      colorScheme: scheme,
      extensions: [tones, VehiclePalette.light],
      fontFamily: AppTextStyles.fontFamily,
      textTheme: AppTextStyles.textTheme,
      scaffoldBackgroundColor: scheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(minimumSize: const Size(64, 56), shape: shape),
      ),
      // Material 3 defaults text and outlined buttons to a pill and icon buttons to a circle; the design uses 12px.
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(shape: shape)),
      // Secondary / outline button: white surface, #CBD5E1 outline, secondary slate text.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: shape,
          backgroundColor: scheme.surfaceContainerLowest,
          foregroundColor: scheme.secondary,
          side: BorderSide(color: scheme.surfaceContainerHighest),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(style: IconButton.styleFrom(shape: shape)),
      // Inputs: 12px radius, hairline border, 2px focus ring.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        border: border(scheme.outlineVariant),
        enabledBorder: border(scheme.outlineVariant),
        focusedBorder: border(scheme.primary, 2),
        errorBorder: border(scheme.error),
        focusedErrorBorder: border(scheme.error, 2),
      ),
    );
  }
}
