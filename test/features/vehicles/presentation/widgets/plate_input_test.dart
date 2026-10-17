import 'package:car_assistant/core/theme/app_theme.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/vehicle_form/digits_input_formatter.dart';
import 'package:car_assistant/features/vehicles/presentation/widgets/vehicle_form/plate_input.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late TextEditingController two;
  late TextEditingController three;
  late TextEditingController province;

  setUp(() {
    two = TextEditingController();
    three = TextEditingController();
    province = TextEditingController();
  });

  tearDown(() {
    two.dispose();
    three.dispose();
    province.dispose();
  });

  Future<void> pump(
    WidgetTester tester, {
    String? letter,
    ValueChanged<String>? onLetter,
    String? error,
    Locale locale = const Locale('fa'),
  }) => tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(
        body: PlateInput(
          twoDigits: two,
          letter: letter,
          threeDigits: three,
          provinceCode: province,
          onLetterChanged: onLetter ?? (_) {},
          error: error,
        ),
      ),
    ),
  );

  Finder box(int index) => find.byType(TextField).at(index);

  testWidgets('shows typed digits in Persian and reads them back in Latin', (tester) async {
    await pump(tester);

    await tester.enterText(box(0), '72');
    await tester.enterText(box(1), '۳۴۵');
    await tester.enterText(box(2), '68');

    expect(find.text('۷۲'), findsOneWidget);
    expect(find.text('۳۴۵'), findsOneWidget);
    expect(find.text('۶۸'), findsOneWidget);
    expect(DigitsInputFormatter.digitsOf(two.text), '72');
    expect(DigitsInputFormatter.digitsOf(three.text), '345');
    expect(DigitsInputFormatter.digitsOf(province.text), '68');
  });

  testWidgets('drops non-digits and caps each box at its length', (tester) async {
    await pump(tester);

    await tester.enterText(box(0), '7a29');
    await tester.enterText(box(1), '12345');

    expect(DigitsInputFormatter.digitsOf(two.text), '72');
    expect(DigitsInputFormatter.digitsOf(three.text), '123');
  });

  testWidgets('picks the letter from the dropdown', (tester) async {
    String? picked;
    await pump(tester, onLetter: (letter) => picked = letter);

    expect(find.text('حرف'), findsOneWidget); // hint before a letter is chosen
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ب').last);
    await tester.pumpAndSettle();

    expect(picked, 'ب');
  });

  testWidgets('shows the chosen letter, the Iran band and the province label', (tester) async {
    await pump(tester, letter: 'ی');

    expect(find.text('ی'), findsOneWidget);
    expect(find.text('I.R.'), findsOneWidget);
    expect(find.text('IRAN'), findsOneWidget);
    expect(find.text('ایران'), findsOneWidget);
  });

  testWidgets('shows the error instead of the help text', (tester) async {
    await pump(tester, error: 'این پلاک قبلاً در گاراژ شما ثبت شده است');

    expect(find.text('این پلاک قبلاً در گاراژ شما ثبت شده است'), findsOneWidget);
    expect(find.textContaining('ترتیب درج'), findsNothing);
  });

  testWidgets('keeps Latin digits in English', (tester) async {
    await pump(tester, locale: const Locale('en'));

    await tester.enterText(box(0), '۷۲');

    expect(find.text('72'), findsOneWidget);
  });
}
