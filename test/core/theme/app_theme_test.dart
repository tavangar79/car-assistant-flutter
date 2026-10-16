import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('both themes use the Vazirmatn font', () {
    expect(AppTheme.light.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
    expect(AppTheme.dark.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
  });

  test('themes have the expected brightness', () {
    expect(AppTheme.light.colorScheme.brightness, Brightness.light);
    expect(AppTheme.dark.colorScheme.brightness, Brightness.dark);
  });
}
