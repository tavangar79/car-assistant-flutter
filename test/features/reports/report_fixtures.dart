import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:car_assistant/features/expenses/domain/entities/expense.dart';
import 'package:car_assistant/features/expenses/domain/entities/expense_category.dart';
import 'package:car_assistant/features/history/domain/entities/history_entry.dart';
import 'package:car_assistant/features/history/domain/entities/history_summary.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/reports/domain/entities/report.dart';
import 'package:car_assistant/features/reports/domain/repositories/report_repository.dart';
import 'package:car_assistant/features/reports/presentation/export/report_pdf_builder.dart';
import 'package:car_assistant/features/reports/presentation/providers/report_file_saver.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pdf/widgets.dart' as pw;

import '../history/history_fixtures.dart';

/// Shared report test data, for vehicle `v1` (`tara` in the vehicle fixtures).

/// A 1×1 PNG.
final onePixelPng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

/// The fixture records, oldest first, as the report endpoint orders them.
Report fixtureReport() => Report(
  entries: [expenseEntry(), fuelEntry(), serviceEntry()],
  summary: const HistorySummary(
    totalCost: 8125500,
    serviceCount: 1,
    fuelVolume: 48.5,
    entryCount: 3,
  ),
);

/// An expense whose title needs CSV quoting.
HistoryEntry quotedExpenseEntry() => HistoryEntry(
  type: HistoryType.expense,
  id: 'e2',
  vehicleId: 'v1',
  occurredAt: DateTime(2024, 11, 18, 12),
  cost: 300000,
  hasAttachment: false,
  expense: Expense(
    id: 'e2',
    vehicleId: 'v1',
    category: ExpenseCategory.toll,
    amount: 300000,
    title: 'عوارض "آزادراه", تهران',
    paidAt: DateTime(2024, 11, 18, 12),
    expiryReminder: false,
    createdAt: DateTime(2024, 11, 18, 12),
    updatedAt: DateTime(2024, 11, 18, 12),
  ),
);

class MockReportRepository extends Mock implements ReportRepository {}

/// Records what would be saved.
class FakeReportFileSaver implements ReportFileSaver {
  final saved = <(String, String, Uint8List)>[];

  @override
  Future<void> save(Uint8List bytes, {required String fileName, required String mimeType}) async =>
      saved.add((fileName, mimeType, bytes));
}

Future<ReportPdfFonts> testFonts() async {
  pw.Font font(String path) => pw.Font.ttf(File(path).readAsBytesSync().buffer.asByteData());
  return ReportPdfFonts(
    regular: font('assets/fonts/Vazirmatn-Regular.ttf'),
    bold: font('assets/fonts/Vazirmatn-Bold.ttf'),
  );
}
