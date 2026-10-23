import 'package:car_assistant/features/reports/presentation/export/report_pdf_text.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  List<String?> parts(pw.TextSpan span) => [
    for (final child in span.children!) (child as pw.TextSpan).text,
  ];

  test('text without a ZWNJ stays one span', () {
    const style = pw.TextStyle(fontSize: 9);
    final span = zwnjSafeSpan('تارا اتوماتیک', style: style);

    expect(span.text, 'تارا اتوماتیک');
    expect(span.children, isNull);
    expect(span.style, style);
  });

  test('cuts the text at each ZWNJ and drops it', () {
    final span = zwnjSafeSpan('تارا نقره‌ای و بیمه‌نامه');

    expect(span.text, isNull);
    expect(parts(span), ['تارا نقره', 'ای و بیمه', 'نامه']);
    expect(parts(span).join(), isNot(contains(zwnj)));
  });

  test('keeps the style on the parent and skips empty parts', () {
    const style = pw.TextStyle(fontSize: 13);
    final span = zwnjSafeSpan('$zwnjمی‌شود$zwnj', style: style);

    expect(span.style, style);
    expect(parts(span), ['می', 'شود']);
  });
}
