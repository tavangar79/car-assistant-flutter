import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/plans/presentation/pages/plans_page.dart';
import 'package:car_assistant/features/profile/presentation/widgets/profile_plan_card.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget home) async {
    tester.view
      ..physicalSize = const Size(420, 3600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('fa'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: home,
      ),
    );
    await tester.pumpAndSettle();
  }

  FilledButton button(WidgetTester tester, String label) => tester.widget<FilledButton>(
    find.ancestor(of: find.text(label), matching: find.byType(FilledButton)),
  );

  group('PlansPage', () {
    testWidgets('shows the three plans with monthly prices; پایه is the current plan', (
      tester,
    ) async {
      await pump(tester, const PlansPage());

      expect(find.text('اشتراک و پلن‌ها'), findsOneWidget);
      expect(find.text('پلن‌ها و اشتراک‌ها'), findsOneWidget);
      expect(find.text('پایه (همیشه رایگان)'), findsOneWidget);
      expect(find.text('حرفه‌ای (پلاس)'), findsOneWidget);
      expect(find.text('گاراژ نامحدود'), findsOneWidget);
      expect(find.text('پیشنهاد ما'), findsOneWidget);
      expect(find.text('۰'), findsOneWidget);
      expect(find.text('۴۹٬۰۰۰'), findsOneWidget);
      expect(find.text('۸۹٬۰۰۰'), findsOneWidget);
      expect(find.text('تومان / ماهانه'), findsNWidgets(3));
      expect(find.text('تسویه‌حساب ماهانه بدون تعهد زمانی'), findsOneWidget);
      expect(find.text('برای مجموعه‌داران و مدیران چند خودرو'), findsOneWidget);
      expect(button(tester, 'پلن فعلی شما').onPressed, isNull);
      expect(find.text('تضمین شفافیت و رضایت'), findsOneWidget);
    });

    testWidgets('the yearly toggle switches the prices, units and notes', (tester) async {
      await pump(tester, const PlansPage());

      await tester.tap(find.text('سالیانه'));
      await tester.pumpAndSettle();

      expect(find.text('۴۷۰٬۰۰۰'), findsOneWidget);
      expect(find.text('۸۵۰٬۰۰۰'), findsOneWidget);
      expect(find.text('تومان / سالانه'), findsNWidgets(2));
      // The free plan keeps its monthly unit, as in the screen.
      expect(find.text('تومان / ماهانه'), findsOneWidget);
      expect(find.text('معادل ۳۹٬۰۰۰ تومان در ماه (۲۰٪ صرفه‌جویی)'), findsOneWidget);
      expect(find.text('معادل ۷۰٬۰۰۰ تومان در ماه با اولویت کامل'), findsOneWidget);

      await tester.tap(find.text('ماهانه'));
      await tester.pumpAndSettle();

      expect(find.text('۴۹٬۰۰۰'), findsOneWidget);
    });

    testWidgets('an upgrade button only says "به‌زودی"', (tester) async {
      await pump(tester, const PlansPage());

      await tester.tap(find.text('انتخاب و ارتقا به حرفه‌ای'));
      await tester.pump();
      expect(find.text('به‌زودی'), findsOneWidget);

      await tester.tap(find.text('انتخاب پلن نامحدود'));
      await tester.pump();
      expect(find.text('به‌زودی'), findsWidgets);
      expect(find.byType(PlansPage), findsOneWidget);
    });
  });

  testWidgets('ProfilePlanCard shows the basic plan and opens the plans', (tester) async {
    var opened = 0;
    await pump(tester, Scaffold(body: ProfilePlanCard(onUpgrade: () => opened++)));

    expect(find.text('اشتراک پایه'), findsOneWidget);
    expect(find.text('رایگان'), findsOneWidget);

    await tester.tap(find.text('ارتقا یا تمدید'));

    expect(opened, 1);
  });
}
