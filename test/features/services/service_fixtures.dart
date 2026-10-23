import 'package:car_assistant/features/services/domain/entities/service_category.dart';
import 'package:car_assistant/features/services/domain/entities/service_invoice.dart';
import 'package:car_assistant/features/services/domain/entities/service_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit.dart';

/// Shared service test data, for vehicle `v1` (`tara` in the vehicle fixtures).

const catalogJson = {
  'categories': [
    {
      'id': 'fluids',
      'title': 'روغن و مایعات مصرفی',
      'items': [
        {
          'id': 'engine_oil',
          'title': 'روغن موتور',
          'subtitle': 'تعویض و فلاش',
          'icon': 'oil_barrel',
        },
        {
          'id': 'oil_filter',
          'title': 'فیلتر روغن',
          'subtitle': 'همراه با تعویض روغن',
          'icon': 'filter_alt',
        },
      ],
    },
    {
      'id': 'brakes',
      'title': 'ترمز و ایمنی',
      'items': [
        {
          'id': 'front_brake_pads',
          'title': 'لنت ترمز جلو',
          'subtitle': 'دیسکی / سنسوردار',
          'icon': 'disc_full',
        },
      ],
    },
  ],
};

const engineOil = ServiceItem(
  id: 'engine_oil',
  title: 'روغن موتور',
  subtitle: 'تعویض و فلاش',
  icon: 'oil_barrel',
);

const oilFilter = ServiceItem(
  id: 'oil_filter',
  title: 'فیلتر روغن',
  subtitle: 'همراه با تعویض روغن',
  icon: 'filter_alt',
);

const frontBrakePads = ServiceItem(
  id: 'front_brake_pads',
  title: 'لنت ترمز جلو',
  subtitle: 'دیسکی / سنسوردار',
  icon: 'disc_full',
);

const serviceCatalog = [
  ServiceCategory(id: 'fluids', title: 'روغن و مایعات مصرفی', items: [engineOil, oilFilter]),
  ServiceCategory(id: 'brakes', title: 'ترمز و ایمنی', items: [frontBrakePads]),
];

/// [serviceCatalog] as resolved for a vehicle on which the items [disabledIds] are disabled.
List<ServiceCategory> catalogWithDisabled(Set<String> disabledIds) => [
  for (final category in serviceCatalog)
    ServiceCategory(
      id: category.id,
      title: category.title,
      items: [
        for (final item in category.items)
          ServiceItem(
            id: item.id,
            title: item.title,
            subtitle: item.subtitle,
            icon: item.icon,
            disabled: disabledIds.contains(item.id),
          ),
      ],
    ),
];

const oilLineJson = {
  'itemId': 'engine_oil',
  'brand': 'بهران رانا 5W-40',
  'cost': 1850000,
  'notes': null,
  'nextDueKm': 7000,
  'nextDueMonths': 6,
};

const filterLineJson = {
  'itemId': 'oil_filter',
  'brand': 'سرکان',
  'cost': 280000,
  'notes': null,
  'nextDueKm': null,
  'nextDueMonths': null,
};

const oilLine = ServiceLineItem(
  itemId: 'engine_oil',
  brand: 'بهران رانا 5W-40',
  cost: 1850000,
  nextDueKm: 7000,
  nextDueMonths: 6,
);

const filterLine = ServiceLineItem(itemId: 'oil_filter', brand: 'سرکان', cost: 280000);

const invoiceJson = {
  'fileName': 'فاکتور.jpg',
  'contentType': 'image/jpeg',
  'sizeBytes': 1468006,
  'updatedAt': '2026-10-20T15:16:00.000Z',
};

final invoice = ServiceInvoice(
  fileName: 'فاکتور.jpg',
  contentType: 'image/jpeg',
  sizeBytes: 1468006,
  updatedAt: DateTime.utc(2026, 10, 20, 15, 16),
);

/// The visit JSON of the contract; [withInvoice] attaches the invoice.
Map<String, dynamic> visitJson({bool withInvoice = false, List<Map<String, dynamic>>? lines}) => {
  'id': 's1',
  'vehicleId': 'v1',
  'serviceDate': '2026-10-20T10:30:00.000Z',
  'odometerKm': 34850,
  'workshop': 'اتوسرویس البرز',
  'notes': null,
  'lineItems': lines ?? [oilLineJson, filterLineJson],
  'totalCost': 2130000,
  'invoice': withInvoice ? invoiceJson : null,
  'invoiceUrl': withInvoice ? '/api/vehicles/v1/services/s1/invoice?v=1' : null,
  'createdAt': '2026-10-20T15:16:00.000Z',
  'updatedAt': '2026-10-20T15:16:00.000Z',
};

ServiceVisit visit({bool withInvoice = false, List<ServiceLineItem>? lines}) => ServiceVisit(
  id: 's1',
  vehicleId: 'v1',
  serviceDate: DateTime.utc(2026, 10, 20, 10, 30),
  odometerKm: 34850,
  workshop: 'اتوسرویس البرز',
  lineItems: lines ?? const [oilLine, filterLine],
  totalCost: 2130000,
  invoice: withInvoice ? invoice : null,
  invoiceUrl: withInvoice ? '/api/vehicles/v1/services/s1/invoice?v=1' : null,
  createdAt: DateTime.utc(2026, 10, 20, 15, 16),
  updatedAt: DateTime.utc(2026, 10, 20, 15, 16),
);
