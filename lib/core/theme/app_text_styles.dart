import 'package:flutter/material.dart';

/// Type scale from the Stitch design system, mapped onto Material's [TextTheme].
/// Colors come from the [ColorScheme]; the font family is set once in `AppTheme`.
abstract final class AppTextStyles {
  static const fontFamily = 'Vazirmatn';

  static const textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, height: 44 / 32),
    displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 36 / 26),
    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 32 / 22),
    headlineMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 28 / 18),
    headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16),
    titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 28 / 18),
    titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16),
    titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 26 / 16),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 22 / 14),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 18 / 12),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, height: 14 / 10),
  );
}
