import 'package:flutter/material.dart';

/// Light color tokens from the Stitch design system "مدیریت خودرو Vehicle Ledger" (designMd).
/// See DESIGN.md. Widgets read colors from `Theme.of(context).colorScheme` or `AppTones`, never from here.
abstract final class AppColors {
  // Brand
  static const navy = Color(0xFF0F172A); // Primary Slate Navy
  static const slate = Color(0xFF1E293B); // Secondary Slate
  static const amber = Color(0xFFF59E0B); // Accent Amber

  // Canvas, cards and borders
  static const canvas = Color(0xFFF8FAFC); // surface, surface-container-low
  static const white = Color(0xFFFFFFFF); // cards, surface-container-lowest
  static const container = Color(0xFFF1F5F9); // surface-container
  // surface-container-high, outline-variant, borders
  static const containerHigh = Color(0xFFE2E8F0);
  static const containerHighest = Color(0xFFCBD5E1); // surface-container-highest, strong borders
  static const onSurface = Color(0xFF191C1E);
  static const onSurfaceVariant = Color(0xFF45464D);
  static const inverseSurface = Color(0xFF2D3133);
  static const inverseOnSurface = Color(0xFFEFF1F3);
  static const outline = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B); // muted text, input labels
  static const slate700 = Color(0xFF334155); // field labels

  // Status matrix
  static const statusOk = Color(0xFF10B981);
  static const statusOkContainer = Color(0xFFECFDF5);
  static const statusDueSoon = amber;
  static const statusDueSoonContainer = Color(0xFFFFFBEB);
  static const statusOverdue = Color(0xFFEF4444);
  static const statusOverdueContainer = Color(0xFFFEF2F2);
  static const statusInfo = Color(0xFF0EA5E9);
  static const statusInfoContainer = Color(0xFFF0F9FF);

  // Tints of the auth screens (Stitch "ورود و ثبت‌نام" / "تأیید کد")
  static const amber100 = Color(0xFFFEF3C7);
  static const amber200 = Color(0xFFFDE68A);
  static const amber600 = Color(0xFFD97706);
  static const amber800 = Color(0xFF92400E);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald600 = Color(0xFF059669);
  static const emerald800 = Color(0xFF065F46);

  // Iranian plate band and body-colour swatches (Stitch "افزودن و ویرایش خودرو")
  static const plateBlue = Color(0xFF1E3A8A);
  static const paintWhite = white;
  static const paintBlack = slate;
  static const paintSilver = outline;
  static const paintBlue = plateBlue;
  static const paintRed = Color(0xFFDC2626);
  static const paintBeige = amber600;

  // Chart series: car identity in charts, fixed order (DESIGN.md), overflow is slate500
  static const chartBlue = Color(0xFF2563EB);
  static const chartCyan = Color(0xFF0891B2);
  static const chartViolet = Color(0xFF7C3AED);
  static const chartPink = Color(0xFFBE185D);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);
}
