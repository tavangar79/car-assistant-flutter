import 'package:car_assistant/core/theme/app_tones.dart';
import 'package:car_assistant/features/documents/domain/entities/document_status.dart';
import 'package:car_assistant/features/documents/presentation/widgets/document_formats.dart';
import 'package:car_assistant/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../document_fixtures.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('fa'));
  const tones = AppTones.light;

  test('status labels', () {
    String label(DocumentStatusKind kind, int days) =>
        documentStatusLabel(DocumentStatus(kind, days), l10n);
    expect(label(DocumentStatusKind.expired, 85), 'منقضی شده — ۸۵ روز گذشته');
    expect(label(DocumentStatusKind.dueSoon, 18), 'موعد نزدیک — ۱۸ روز مانده');
    expect(label(DocumentStatusKind.upcoming, 25), 'معتبر — ۲۵ روز مانده');
    expect(label(DocumentStatusKind.valid, 74), 'معتبر — ۷۴ روز مانده');
    expect(label(DocumentStatusKind.permanent, 0), 'دائمی / بدون انقضا');
  });

  test('status colours: red, amber, blue, green, blue', () {
    expect(documentStatusTone(DocumentStatusKind.expired, tones), tones.overdue);
    expect(documentStatusTone(DocumentStatusKind.dueSoon, tones), tones.amber);
    expect(documentStatusTone(DocumentStatusKind.upcoming, tones), tones.info);
    expect(documentStatusTone(DocumentStatusKind.valid, tones), tones.emerald);
    expect(documentStatusTone(DocumentStatusKind.permanent, tones), tones.info);
  });

  test('file badge: PDF, N images, none', () {
    expect(documentFileBadge(insurance().files, l10n), 'PDF');
    expect(documentFileBadge(vehicleCard().files, l10n), '۲ تصویر');
    expect(documentFileBadge(vehicleCard().files.take(1).toList(), l10n), 'JPG');
    expect(documentFileBadge(const [], l10n), isNull);
  });

  test('title falls back to the type; issuer line joins issuer and number', () {
    expect(documentTitle(insurance(), l10n), 'بیمه شخص ثالث');
    expect(documentTitle(vehicleCard(), l10n), 'کارت هوشمند خودرو');
    expect(documentIssuerLine(insurance(), l10n), 'بیمه ایران — شماره: 124/987432');
    expect(documentIssuerLine(vehicleCard(), l10n), 'شماره: IRN-847291039401');
  });
}
