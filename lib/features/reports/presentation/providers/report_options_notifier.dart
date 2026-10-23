import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../history/domain/entities/history_type.dart';
import '../../domain/entities/report_options.dart';
import '../../domain/entities/report_period.dart';

/// The choices of the export page, starting on [initialVehicleId] (or every vehicle when `null`).
class ReportOptionsNotifier extends Notifier<ReportOptions> {
  ReportOptionsNotifier(this.initialVehicleId);

  final String? initialVehicleId;

  @override
  ReportOptions build() => ReportOptions(vehicleId: initialVehicleId);

  /// The single-vehicle segment ([initialVehicleId]) or "همه خودروها".
  void setAllVehicles(bool all) => state = state.withVehicle(all ? null : initialVehicleId);

  void setPeriod(ReportPeriod period) => state = state.withPeriod(period);

  /// A picked "از تاریخ" / "تا تاریخ" day: the range becomes custom.
  void setCustomRange(DateTime now, {DateTime? from, DateTime? to}) =>
      state = state.withCustomRange(now, from: from, to: to);

  void toggleType(HistoryType type) {
    final types = {...state.types};
    if (!types.remove(type)) types.add(type);
    state = state.withTypes(types);
  }

  void toggleImages() => state = state.withImages(!state.includeImages);

  /// "انتخاب همه": checks every box, or clears them all when all are already checked.
  void toggleAll() {
    final allChecked = state.types.length == ReportOptions.allTypes.length && state.includeImages;
    state = state.withTypes(allChecked ? const {} : ReportOptions.allTypes).withImages(!allChecked);
  }
}
