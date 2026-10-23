import 'package:pdf/widgets.dart' as pw;

/// The zero-width non-joiner (نیم‌فاصله).
const zwnj = '‌';

/// [text] as a span that is safe to draw with the `pdf` package.
///
/// `pdf` 3.13's TrueType parser reads an empty glyph (such as Vazirmatn's U+200C) as the outline
/// of the glyph stored after it, so a ZWNJ is drawn as a stray letter. Simply deleting it would
/// join the letters around it (`نقره‌ای` → `نقرهای`). Instead the text is cut at each ZWNJ into
/// sibling spans and the ZWNJ is dropped: the package shapes Arabic script one span at a time, so
/// the letter before the cut keeps its final/isolated form and the one after its initial form,
/// exactly as the ZWNJ asks, and nothing is drawn in between.
pw.TextSpan zwnjSafeSpan(String text, {pw.TextStyle? style}) {
  if (!text.contains(zwnj)) return pw.TextSpan(text: text, style: style);
  return pw.TextSpan(
    style: style,
    children: [
      for (final part in text.split(zwnj))
        if (part.isNotEmpty) pw.TextSpan(text: part),
    ],
  );
}

/// A [pw.Text] replacement that draws ZWNJs correctly (see [zwnjSafeSpan]).
pw.Widget pdfText(String text, {pw.TextStyle? style, pw.TextAlign? textAlign}) => pw.RichText(
  text: zwnjSafeSpan(text, style: style),
  textAlign: textAlign,
);
