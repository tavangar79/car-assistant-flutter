import 'package:flutter/material.dart';

/// Color tokens from the Stitch project "مدیریت خودرو Vehicle Ledger".
/// See DESIGN.md. Widgets read colors from `Theme.of(context).colorScheme`, never from here.
abstract final class AppColors {
  // Brand
  static const navy = Color(0xFF0F172A); // Primary Slate Navy
  static const slate = Color(0xFF1E293B); // Secondary Slate
  static const amber = Color(0xFFF59E0B); // Accent Amber

  // Light neutrals
  static const canvas = Color(0xFFF8FAFC);
  static const white = Color(0xFFFFFFFF);
  static const container = Color(0xFFF1F5F9);
  static const containerHigh = Color(0xFFE2E8F0);
  static const containerHighest = Color(0xFFCBD5E1);
  static const onSurfaceLight = Color(0xFF191C1E);
  static const onSurfaceVariantLight = Color(0xFF45464D);
  static const outline = Color(0xFF94A3B8);
  static const outlineVariant = Color(0xFFE2E8F0);

  // Dark neutrals (slate scale used by the Stitch splash screen)
  static const slate700 = Color(0xFF334155);
  static const slate300 = Color(0xFFCBD5E1);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
  static const errorDark = Color(0xFFEF4444);
}
