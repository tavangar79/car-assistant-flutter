import 'package:car_assistant/features/history/domain/entities/history_entry.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/entities/history_summary.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';

import '../expenses/expense_fixtures.dart';
import '../fuel/fuel_fixtures.dart';
import '../services/service_fixtures.dart';

/// Shared history test data: one entry of each type for vehicle `v1`, in contract order (newest
/// first), each in a different Jalali month (مهر ۱۴۰۵, آبان ۱۴۰۴, آبان ۱۴۰۳).

Map<String, dynamic> serviceEntryJson() => {
  'type': 'service',
  'id': 's1',
  'vehicleId': 'v1',
  'occurredAt': '2026-10-20T10:30:00.000Z',
  'cost': 2130000,
  'hasAttachment': true,
  'service': visitJson(withInvoice: true),
  'fuelLog': null,
  'expense': null,
};

Map<String, dynamic> fuelEntryJson() => {
  'type': 'fuel',
  'id': 'f1',
  'vehicleId': 'v1',
  'occurredAt': '2025-11-15T13:12:00.000Z',
  'cost': 145500,
  'hasAttachment': false,
  'service': null,
  'fuelLog': fuelLogJson(),
  'expense': null,
};

Map<String, dynamic> expenseEntryJson() => {
  'type': 'expense',
  'id': 'e1',
  'vehicleId': 'v1',
  'occurredAt': '2024-11-17T00:00:00.000Z',
  'cost': 5850000,
  'hasAttachment': true,
  'service': null,
  'fuelLog': null,
  'expense': expenseJson(withAttachment: true),
};

const summaryJson = {
  'totalCost': 14280000,
  'serviceCount': 8,
  'fuelVolume': 240.5,
  'entryCount': 23,
};

/// The first page of the contract: three entries, a cursor and the summary.
Map<String, dynamic> historyJson({String? nextCursor = 'c1', bool withSummary = true}) => {
  'entries': [serviceEntryJson(), fuelEntryJson(), expenseEntryJson()],
  'nextCursor': nextCursor,
  'summary': withSummary ? summaryJson : null,
};

HistoryEntry serviceEntry() => HistoryEntry(
  type: HistoryType.service,
  id: 's1',
  vehicleId: 'v1',
  occurredAt: DateTime.utc(2026, 10, 20, 10, 30),
  cost: 2130000,
  hasAttachment: true,
  service: visit(withInvoice: true),
);

HistoryEntry fuelEntry() => HistoryEntry(
  type: HistoryType.fuel,
  id: 'f1',
  vehicleId: 'v1',
  occurredAt: DateTime.utc(2025, 11, 15, 13, 12),
  cost: 145500,
  hasAttachment: false,
  fuelLog: contractFuelLog(),
);

HistoryEntry expenseEntry() => HistoryEntry(
  type: HistoryType.expense,
  id: 'e1',
  vehicleId: 'v1',
  occurredAt: DateTime.utc(2024, 11, 17),
  cost: 5850000,
  hasAttachment: true,
  expense: expense(withAttachment: true),
);

const summary = HistorySummary(
  totalCost: 14280000,
  serviceCount: 8,
  fuelVolume: 240.5,
  entryCount: 23,
);

HistoryResult historyResult({String? nextCursor = 'c1', bool withSummary = true}) => HistoryResult(
  entries: [serviceEntry(), fuelEntry(), expenseEntry()],
  nextCursor: nextCursor,
  summary: withSummary ? summary : null,
);
