import 'package:equatable/equatable.dart';

import 'service_line_draft.dart';

/// What the "ثبت سرویس" wizard holds before it is checked. `ServiceRules.validate` turns it into
/// a `NewServiceVisit`.
class ServiceVisitDraft extends Equatable {
  const ServiceVisitDraft({
    this.itemIds = const [],
    this.serviceDay,
    this.visitMinutes,
    this.odometerKm,
    this.stickerNextKm,
    this.workshop = '',
    this.lines = const {},
  });

  /// The item of the engine-oil sticker whose reminder [stickerNextKm] prefills.
  static const engineOilItemId = 'engine_oil';

  /// The chosen catalog item ids, in selection order.
  final List<String> itemIds;

  /// The day of the visit (local midnight); `null` means today.
  final DateTime? serviceDay;

  /// The visit time as minutes since midnight; `null` means the current time of day.
  final int? visitMinutes;

  /// The odometer at the visit; `null` means the vehicle's current mileage.
  final int? odometerKm;

  /// The next-service km written on the oil-change sticker (absolute km), if any.
  final int? stickerNextKm;

  /// The workshop, shared by every item of the visit.
  final String workshop;

  /// The per-item fields, by item id. A missing id means nothing was typed yet.
  final Map<String, ServiceLineDraft> lines;

  /// The reminder km that the sticker suggests for the engine-oil item: the distance from
  /// [odometerKm] (or [currentKm]) to [stickerNextKm], when that is ahead.
  int? stickerNextDueKm(int currentKm) {
    final sticker = stickerNextKm;
    if (sticker == null) return null;
    final delta = sticker - (odometerKm ?? currentKm);
    return delta > 0 ? delta : null;
  }

  /// The draft of item [itemId], with the sticker reminder filled in for the engine-oil item
  /// unless the user typed their own.
  ServiceLineDraft lineOf(String itemId, {required int currentKm}) {
    final line = lines[itemId] ?? const ServiceLineDraft();
    if (itemId != engineOilItemId || line.nextDueKm != null) return line;
    return line.copyWith(nextDueKm: () => stickerNextDueKm(currentKm));
  }

  /// The sum of the costs typed so far, in toman.
  int get totalCost => itemIds.fold(0, (sum, id) => sum + (lines[id]?.cost ?? 0));

  /// When the visit took place: [serviceDay] at [visitMinutes], today at [now]'s time by default.
  DateTime serviceDate(DateTime now) {
    final day = serviceDay ?? DateTime(now.year, now.month, now.day);
    final minutes = visitMinutes ?? now.hour * 60 + now.minute;
    return DateTime(day.year, day.month, day.day, minutes ~/ 60, minutes % 60);
  }

  ServiceVisitDraft copyWith({
    List<String>? itemIds,
    DateTime? Function()? serviceDay,
    int? Function()? visitMinutes,
    int? Function()? odometerKm,
    int? Function()? stickerNextKm,
    String? workshop,
    Map<String, ServiceLineDraft>? lines,
  }) => ServiceVisitDraft(
    itemIds: itemIds ?? this.itemIds,
    serviceDay: serviceDay == null ? this.serviceDay : serviceDay(),
    visitMinutes: visitMinutes == null ? this.visitMinutes : visitMinutes(),
    odometerKm: odometerKm == null ? this.odometerKm : odometerKm(),
    stickerNextKm: stickerNextKm == null ? this.stickerNextKm : stickerNextKm(),
    workshop: workshop ?? this.workshop,
    lines: lines ?? this.lines,
  );

  @override
  List<Object?> get props => [
    itemIds,
    serviceDay,
    visitMinutes,
    odometerKm,
    stickerNextKm,
    workshop,
    lines,
  ];
}
