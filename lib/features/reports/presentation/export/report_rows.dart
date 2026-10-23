import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../../fuel/presentation/widgets/fuel_formats.dart';
import '../../../history/domain/entities/history_entry.dart';
import '../../../history/domain/entities/history_type.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../vehicles/domain/entities/vehicle.dart';

/// One line of an exported report, with ASCII digits in [description]. The CSV and PDF builders
/// format the other columns themselves.
class ReportRow {
  const ReportRow({
    required this.date,
    required this.vehicleId,
    required this.vehicle,
    required this.type,
    required this.description,
    required this.km,
    required this.amount,
  });

  /// The local record date.
  final DateTime date;
  final String vehicleId;

  /// The vehicle, or `null` when it is not in the garage list.
  final Vehicle? vehicle;
  final HistoryType type;

  /// `شرح`: service = item titles and workshop; fuel = fuel type, volume and station; expense =
  /// category and title.
  final String description;

  /// The odometer of a service or fill-up; `null` for an expense.
  final int? km;

  /// Toman.
  final int amount;
}

/// The report [entries] as rows, in the same order. [catalog] gives the service item titles.
List<ReportRow> reportRows(
  List<HistoryEntry> entries, {
  required List<Vehicle> vehicles,
  required List<ServiceCategory> catalog,
  required AppLocalizations l10n,
}) {
  final byId = {for (final vehicle in vehicles) vehicle.id: vehicle};
  return [
    for (final entry in entries)
      ReportRow(
        date: entry.occurredAt.toLocal(),
        vehicleId: entry.vehicleId,
        vehicle: byId[entry.vehicleId],
        type: entry.type,
        description: _description(entry, catalog, l10n),
        km: entry.service?.odometerKm ?? entry.fuelLog?.odometerKm,
        amount: entry.cost,
      ),
  ];
}

/// The label of the `نوع` column: سرویس / سوخت / هزینه.
String reportTypeLabel(HistoryType type, AppLocalizations l10n) => switch (type) {
  HistoryType.service => l10n.reportTypeService,
  HistoryType.fuel => l10n.reportTypeFuel,
  HistoryType.expense || HistoryType.all => l10n.reportTypeExpense,
};

String _description(HistoryEntry entry, List<ServiceCategory> catalog, AppLocalizations l10n) {
  final parts = switch (entry) {
    HistoryEntry(service: final visit?) => [
      [
        for (final line in visit.lineItems)
          findServiceItem(catalog, line.itemId)?.title ?? line.itemId,
      ].join('، '),
      visit.workshop,
    ],
    HistoryEntry(fuelLog: final log?) => [
      fuelTypeLabel(log.fuelType, l10n),
      l10n.historyRowVolume(
        NumberFormat('0.##', 'en').format(log.volume),
        fuelUnitLabel(log.fuelType, l10n),
      ),
      ?log.station,
    ],
    HistoryEntry(expense: final expense?) => [
      expenseCategoryTitle(expense.category, l10n),
      ?expense.title,
    ],
    _ => const <String>[],
  };
  return parts.where((part) => part.trim().isNotEmpty).join(' - ');
}
