import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/core/theme/app_tones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('both themes use the Vazirmatn font', () {
    expect(AppTheme.light.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
    expect(AppTheme.dark.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
  });

  test('buttons and inputs share the 12px radius in both themes', () {
    const shape = RoundedRectangleBorder(borderRadius: AppTheme.radius);
    for (final theme in [AppTheme.light, AppTheme.dark]) {
      expect(theme.filledButtonTheme.style!.shape!.resolve({}), shape);
      expect(theme.textButtonTheme.style!.shape!.resolve({}), shape);
      expect(theme.outlinedButtonTheme.style!.shape!.resolve({}), shape);
      expect(theme.iconButtonTheme.style!.shape!.resolve({}), shape);
      final input = theme.inputDecorationTheme.border! as OutlineInputBorder;
      expect(input.borderRadius, AppTheme.radius);
    }
  });

  test('both themes carry the extra Stitch colors', () {
    expect(AppTheme.dark.extension<AppTones>(), AppTones.dark);
    expect(AppTheme.light.extension<AppTones>(), AppTones.light);
  });

  test('themes have the expected brightness', () {
    expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
  });
}
