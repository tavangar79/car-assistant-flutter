import 'dart:convert';
import 'dart:typed_data';

import '../../../../l10n/app_localizations.dart';
import '../../../expenses/presentation/widgets/expense_formats.dart';
import '../../../services/domain/entities/service_category.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../domain/entities/report.dart';
import 'report_rows.dart';

/// The report as a CSV file: UTF-8 with a BOM (so Excel shows Persian), comma-separated, RFC 4180
/// quoting and CRLF line ends. Columns: date (Jalali), vehicle, plate, type, description, km and
/// amount, then a `جمع کل` row. Every digit the builder writes is ASCII, so spreadsheets parse them.
Uint8List buildReportCsv(
  Report report, {
  required List<Vehicle> vehicles,
  required List<ServiceCategory> catalog,
  required AppLocalizations l10n,
}) {
  final rows = reportRows(report.entries, vehicles: vehicles, catalog: catalog, l10n: l10n);
  final lines = [
    [
      l10n.reportColumnDate,
      l10n.reportColumnVehicle,
      l10n.reportColumnPlate,
      l10n.reportColumnType,
      l10n.reportColumnDescription,
      l10n.reportColumnKm,
      l10n.reportColumnAmount,
    ],
    for (final row in rows)
      [
        formatJalaliNumeric(row.date, 'en'),
        row.vehicle?.nickname ?? '',
        switch (row.vehicle?.plate) {
          final plate? => l10n.vehiclePlateText(
            plate.twoDigits,
            plate.letter,
            plate.threeDigits,
            plate.provinceCode,
          ),
          null => '',
        },
        reportTypeLabel(row.type, l10n),
        row.description,
        row.km?.toString() ?? '',
        '${row.amount}',
      ],
    [l10n.reportTotalRow, '', '', '', '', '', '${report.summary.totalCost}'],
  ];
  final csv = lines.map((cells) => cells.map(_quote).join(',')).join('\r\n');
  return Uint8List.fromList(utf8.encode('﻿$csv\r\n'));
}

/// RFC 4180: a cell with a comma, a quote or a line break is quoted, inner quotes doubled.
String _quote(String cell) {
  if (!cell.contains(RegExp('[",\r\n]'))) return cell;
  return '"${cell.replaceAll('"', '""')}"';
}
