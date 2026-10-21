import 'package:car_assistant/features/intervals/domain/entities/due_item.dart';
import 'package:car_assistant/features/intervals/domain/entities/due_report.dart';
import 'package:car_assistant/features/intervals/domain/entities/due_status.dart';
import 'package:car_assistant/features/intervals/domain/entities/service_interval.dart';

/// Shared interval test data, for vehicle `v1` (`tara` in the vehicle fixtures). Three of the
/// eight intervals are enough for the shapes.

Map<String, dynamic> intervalJson({
  String id = 'engine_oil',
  String title = 'روغن موتور و فیلتر روغن',
  String icon = 'oil_barrel',
  List<String> covers = const ['engine_oil', 'oil_filter'],
  int km = 5000,
  int months = 6,
  int defaultKm = 5000,
  int defaultMonths = 6,
}) => {
  'id': id,
  'title': title,
  'description': 'تعویض $title',
  'icon': icon,
  'coversItemIds': covers,
  'km': km,
  'months': months,
  'defaultKm': defaultKm,
  'defaultMonths': defaultMonths,
  'isCustom': km != defaultKm || months != defaultMonths,
};

final intervalsJson = {
  'intervals': [
    intervalJson(km: 7000),
    intervalJson(
      id: 'air_filter',
      title: 'فیلتر هوا و اتاق',
      icon: 'air',
      covers: ['air_filter', 'cabin_filter'],
      km: 10000,
      defaultKm: 10000,
    ),
    intervalJson(
      id: 'front_brake_pads',
      title: 'لنت ترمز چرخ‌های جلو',
      icon: 'trip_origin',
      covers: ['front_brake_pads'],
      km: 25000,
      months: 18,
      defaultKm: 25000,
      defaultMonths: 18,
    ),
  ],
};

const engineOilInterval = ServiceInterval(
  id: 'engine_oil',
  title: 'روغن موتور و فیلتر روغن',
  description: 'تعویض روغن موتور و فیلتر روغن',
  icon: 'oil_barrel',
  coversItemIds: ['engine_oil', 'oil_filter'],
  km: 7000,
  months: 6,
  defaultKm: 5000,
  defaultMonths: 6,
  isCustom: true,
);

const airFilterInterval = ServiceInterval(
  id: 'air_filter',
  title: 'فیلتر هوا و اتاق',
  description: 'تعویض فیلتر هوا و اتاق',
  icon: 'air',
  coversItemIds: ['air_filter', 'cabin_filter'],
  km: 10000,
  months: 6,
  defaultKm: 10000,
  defaultMonths: 6,
  isCustom: false,
);

const brakePadsInterval = ServiceInterval(
  id: 'front_brake_pads',
  title: 'لنت ترمز چرخ‌های جلو',
  description: 'تعویض لنت ترمز چرخ‌های جلو',
  icon: 'trip_origin',
  coversItemIds: ['front_brake_pads'],
  km: 25000,
  months: 18,
  defaultKm: 25000,
  defaultMonths: 18,
  isCustom: false,
);

const intervals = [engineOilInterval, airFilterInterval, brakePadsInterval];

Map<String, dynamic> dueItemJson({
  required String id,
  required String title,
  required String icon,
  required List<String> covers,
  required String status,
  required int dueKm,
  required int remainingKm,
  required int remainingDays,
  String? baselineServiceId = 's1',
}) => {
  'intervalId': id,
  'title': title,
  'description': 'شرح $title',
  'icon': icon,
  'coversItemIds': covers,
  'status': status,
  'baselineKm': 29500,
  'baselineDate': '2026-05-10T00:00:00.000Z',
  'baselineServiceId': baselineServiceId,
  'dueKm': dueKm,
  'dueDate': '2026-11-10T00:00:00.000Z',
  'remainingKm': remainingKm,
  'remainingDays': remainingDays,
};

/// Overdue by km, due soon by km, upcoming by km (about a month left), then an ok item.
final dueJson = {
  'asOf': '2026-10-21T15:15:00.000Z',
  'mileageKm': 34850,
  'items': [
    dueItemJson(
      id: 'engine_oil',
      title: 'تعویض روغن موتور و فیلترها',
      icon: 'oil_barrel',
      covers: ['engine_oil', 'oil_filter'],
      status: 'overdue',
      dueKm: 34500,
      remainingKm: -350,
      remainingDays: 20,
    ),
    dueItemJson(
      id: 'front_brake_pads',
      title: 'تعویض لنت ترمز جلو',
      icon: 'disc_full',
      covers: ['front_brake_pads'],
      status: 'due_soon',
      dueKm: 35000,
      remainingKm: 150,
      remainingDays: 90,
    ),
    dueItemJson(
      id: 'air_filter',
      title: 'فیلتر هوا و اتاق',
      icon: 'air',
      covers: ['air_filter', 'cabin_filter'],
      status: 'upcoming',
      dueKm: 36000,
      remainingKm: 1150,
      remainingDays: 35,
      baselineServiceId: null,
    ),
    dueItemJson(
      id: 'coolant',
      title: 'مایع خنک‌کننده',
      icon: 'ac_unit',
      covers: ['coolant'],
      status: 'ok',
      dueKm: 69500,
      remainingKm: 34650,
      remainingDays: 700,
    ),
  ],
};

DueItem dueItem({
  required String id,
  required String title,
  required String icon,
  required List<String> covers,
  required DueStatus status,
  required int dueKm,
  required int remainingKm,
  required int remainingDays,
  String? baselineServiceId = 's1',
}) => DueItem(
  intervalId: id,
  title: title,
  description: 'شرح $title',
  icon: icon,
  coversItemIds: covers,
  status: status,
  baselineKm: 29500,
  baselineDate: DateTime.utc(2026, 5, 10),
  baselineServiceId: baselineServiceId,
  dueKm: dueKm,
  dueDate: DateTime.utc(2026, 11, 10),
  remainingKm: remainingKm,
  remainingDays: remainingDays,
);

final overdueOil = dueItem(
  id: 'engine_oil',
  title: 'تعویض روغن موتور و فیلترها',
  icon: 'oil_barrel',
  covers: ['engine_oil', 'oil_filter'],
  status: DueStatus.overdue,
  dueKm: 34500,
  remainingKm: -350,
  remainingDays: 20,
);

final dueSoonPads = dueItem(
  id: 'front_brake_pads',
  title: 'تعویض لنت ترمز جلو',
  icon: 'disc_full',
  covers: ['front_brake_pads'],
  status: DueStatus.dueSoon,
  dueKm: 35000,
  remainingKm: 150,
  remainingDays: 90,
);

final upcomingAir = dueItem(
  id: 'air_filter',
  title: 'فیلتر هوا و اتاق',
  icon: 'air',
  covers: ['air_filter', 'cabin_filter'],
  status: DueStatus.upcoming,
  dueKm: 36000,
  remainingKm: 1150,
  remainingDays: 35,
  baselineServiceId: null,
);

final okCoolant = dueItem(
  id: 'coolant',
  title: 'مایع خنک‌کننده',
  icon: 'ac_unit',
  covers: ['coolant'],
  status: DueStatus.ok,
  dueKm: 69500,
  remainingKm: 34650,
  remainingDays: 700,
);

final dueReport = DueReport(
  asOf: DateTime.utc(2026, 10, 21, 15, 15),
  mileageKm: 34850,
  items: [overdueOil, dueSoonPads, upcomingAir, okCoolant],
);

/// A report where everything is fine.
final allOkReport = DueReport(
  asOf: DateTime.utc(2026, 10, 21, 15, 15),
  mileageKm: 34850,
  items: [okCoolant],
);
