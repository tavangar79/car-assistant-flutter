import 'package:car_assistant/app.dart';
import 'package:car_assistant/core/router/app_router.dart';
import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/core/theme/app_tones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final theme = AppTheme.light;

  test('uses the Vazirmatn font', () {
    expect(theme.textTheme.bodyMedium?.fontFamily, 'Vazirmatn');
  });

  test('buttons and inputs share the 12px radius', () {
    const shape = RoundedRectangleBorder(borderRadius: AppTheme.radius);
    expect(theme.filledButtonTheme.style!.shape!.resolve({}), shape);
    expect(theme.textButtonTheme.style!.shape!.resolve({}), shape);
    expect(theme.outlinedButtonTheme.style!.shape!.resolve({}), shape);
    expect(theme.iconButtonTheme.style!.shape!.resolve({}), shape);
    final input = theme.inputDecorationTheme.border! as OutlineInputBorder;
    expect(input.borderRadius, AppTheme.radius);
  });

  test('matches the Stitch light palette', () {
    final scheme = theme.colorScheme;
    expect(scheme.brightness, Brightness.light);
    expect(scheme.primary, const Color(0xFF0F172A));
    expect(scheme.secondary, const Color(0xFF1E293B));
    expect(scheme.tertiary, const Color(0xFFF59E0B));
    expect(scheme.surface, const Color(0xFFF8FAFC));
    expect(scheme.surfaceContainerLowest, const Color(0xFFFFFFFF));
    expect(scheme.outlineVariant, const Color(0xFFE2E8F0));
    expect(scheme.surfaceContainerHighest, const Color(0xFFCBD5E1));
    expect(scheme.outline, const Color(0xFF94A3B8));
  });

  test('carries the extra Stitch colors, with amber on primary for the add button', () {
    final tones = theme.extension<AppTones>()!;
    expect(tones, AppTones.light);
    expect(tones.accentOnPrimary, const Color(0xFFF59E0B));
    expect(tones.ok.foreground, const Color(0xFF10B981));
    expect(tones.overdue.background, const Color(0xFFFEF2F2));
  });

  testWidgets('the app always runs in light mode', (tester) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (context, state) => const SizedBox())],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appRouterProvider.overrideWithValue(router)],
        child: const CarAssistantApp(),
      ),
    );

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.light);
    expect(app.darkTheme, isNull);
    expect(Theme.of(tester.element(find.byType(SizedBox).last)).brightness, Brightness.light);
  });
}
