import 'package:car_assistant/core/widgets/suggestion_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const suggestions = ['اتوسرویس البرز', 'تعمیرگاه مرکزی', 'اتوسرویس شمال'];

  test('matches keeps the options containing the query, never the exact text, up to max', () {
    // An empty query offers the first ones, most recent first.
    expect(SuggestionTextField.matches(suggestions, ''), suggestions);
    expect(SuggestionTextField.matches(suggestions, '  ', max: 2), suggestions.take(2));
    expect(SuggestionTextField.matches(suggestions, 'اتو'), ['اتوسرویس البرز', 'اتوسرویس شمال']);
    expect(SuggestionTextField.matches(suggestions, 'اتو', max: 1), ['اتوسرویس البرز']);
    expect(SuggestionTextField.matches(['البرز', 'اتوسرویس البرز'], 'البرز'), ['اتوسرویس البرز']);
    expect(SuggestionTextField.matches(suggestions, 'xyz'), isEmpty);
  });

  testWidgets('shows the recent options on focus, the matches while typing; a tap fills', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    final changes = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuggestionTextField(
            controller: controller,
            suggestions: suggestions,
            onChanged: changes.add,
          ),
        ),
      ),
    );

    // Nothing until the field is focused; then every recent option.
    expect(find.byType(ActionChip), findsNothing);
    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.byType(ActionChip), findsNWidgets(3));

    await tester.enterText(find.byType(TextField), 'مرک');
    await tester.pumpAndSettle();
    expect(find.text('تعمیرگاه مرکزی'), findsOneWidget);
    expect(find.text('اتوسرویس البرز'), findsNothing);

    await tester.tap(find.text('تعمیرگاه مرکزی'));
    await tester.pumpAndSettle();
    expect(controller.text, 'تعمیرگاه مرکزی');
    expect(changes.last, 'تعمیرگاه مرکزی');
    // The exact text is no longer offered.
    expect(find.byType(ActionChip), findsNothing);
  });

  testWidgets('without suggestions it is a plain field', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuggestionTextField(controller: controller, suggestions: const []),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();

    expect(find.byType(ActionChip), findsNothing);
    expect(controller.text, 'a');
  });
}
