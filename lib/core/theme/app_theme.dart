import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// The app's single source of theme data. Dark is the default in the car.
abstract final class AppTheme {
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
      onSurface: AppColors.onSurfaceLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight,
      surfaceContainerLowest: AppColors.white,
      surfaceContainerLow: AppColors.canvas,
      surfaceContainer: AppColors.container,
      surfaceContainerHigh: AppColors.containerHigh,
      surfaceContainerHighest: AppColors.containerHighest,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
    ),
  );

  static final dark = _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.amber,
      onPrimary: AppColors.navy,
      secondary: AppColors.slate300,
      onSecondary: AppColors.navy,
      tertiary: AppColors.amber,
      onTertiary: AppColors.navy,
      error: AppColors.errorDark,
      onError: AppColors.white,
      surface: AppColors.navy,
      onSurface: AppColors.canvas,
      onSurfaceVariant: AppColors.outline,
      surfaceContainerLowest: AppColors.navy,
      surfaceContainerLow: AppColors.navy,
      surfaceContainer: AppColors.slate,
      surfaceContainerHigh: AppColors.slate,
      surfaceContainerHighest: AppColors.slate700,
      outline: AppColors.outline,
      outlineVariant: AppColors.slate700,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    OutlineInputBorder border(Color color, [double width = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
    return ThemeData(
      colorScheme: scheme,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: AppTextStyles.textTheme,
      scaffoldBackgroundColor: scheme.surface,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // Inputs from the Stitch auth screens: 12px radius, hairline border, 2px focus ring.
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
