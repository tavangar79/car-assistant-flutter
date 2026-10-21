import 'package:car_assistant/features/services/domain/entities/service_line_draft.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_draft.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 10, 21, 18, 45);

  test('serviceDate defaults to today at the current time', () {
    expect(const ServiceVisitDraft().serviceDate(now), now);
    expect(
      ServiceVisitDraft(
        serviceDay: DateTime(2026, 10, 14),
        visitMinutes: 11 * 60 + 30,
      ).serviceDate(now),
      DateTime(2026, 10, 14, 11, 30),
    );
  });

  test('the sticker km prefills the engine-oil reminder as a distance from the odometer', () {
    const draft = ServiceVisitDraft(itemIds: ['engine_oil', 'oil_filter'], stickerNextKm: 42000);

    expect(draft.lineOf('engine_oil', currentKm: 34500).nextDueKm, 7500);
    expect(draft.lineOf('oil_filter', currentKm: 34500).nextDueKm, isNull);
    // A typed value wins over the sticker; a sticker behind the odometer gives nothing.
    expect(
      draft
          .copyWith(lines: {'engine_oil': const ServiceLineDraft(nextDueKm: 5000)})
          .lineOf('engine_oil', currentKm: 34500)
          .nextDueKm,
      5000,
    );
    expect(
      draft.copyWith(odometerKm: () => 43000).lineOf('engine_oil', currentKm: 34500).nextDueKm,
      isNull,
    );
  });

  test('totalCost sums the typed costs of the selected items', () {
    const draft = ServiceVisitDraft(
      itemIds: ['engine_oil', 'oil_filter'],
      lines: {
        'engine_oil': ServiceLineDraft(cost: 1850000),
        'oil_filter': ServiceLineDraft(cost: 280000),
        'air_filter': ServiceLineDraft(cost: 999),
      },
    );

    expect(draft.totalCost, 2130000);
  });
}
