import 'package:car_assistant/features/services/data/models/create_service_request_dto.dart';
import 'package:car_assistant/features/services/data/models/service_catalog_dto.dart';
import 'package:car_assistant/features/services/data/models/service_line_item_dto.dart';
import 'package:car_assistant/features/services/data/models/service_visit_dto.dart';
import 'package:car_assistant/features/services/data/models/update_service_request_dto.dart';
import 'package:car_assistant/features/services/domain/entities/new_service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_update.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../service_fixtures.dart';

void main() {
  test('ServiceCatalogDto parses the categories and items', () {
    expect(ServiceCatalogDto.fromJson(catalogJson).toEntity(), serviceCatalog);
  });

  test('ServiceItemDto reads disabled, defaulting to false when absent', () {
    const json = {'id': 'engine_oil', 'title': 't', 'subtitle': 's', 'icon': 'oil_barrel'};

    expect(ServiceItemDto.fromJson(json).toEntity().disabled, isFalse);
    expect(ServiceItemDto.fromJson({...json, 'disabled': true}).toEntity().disabled, isTrue);
    expect(ServiceItemDto.fromJson({...json, 'disabled': false}).toEntity().disabled, isFalse);
  });

  test('ServiceVisitDto parses a visit without an invoice', () {
    expect(ServiceVisitDto.fromJson(visitJson()).toEntity(), visit());
  });

  test('ServiceVisitDto parses a visit with an invoice', () {
    expect(
      ServiceVisitDto.fromJson(visitJson(withInvoice: true)).toEntity(),
      visit(withInvoice: true),
    );
  });

  test('ServiceLineItemDto writes null for absent optionals', () {
    expect(ServiceLineItemDto.fromEntity(filterLine).toJson(), filterLineJson);
    expect(ServiceLineItemDto.fromEntity(oilLine).toJson(), oilLineJson);
  });

  test('CreateServiceRequestDto sends the contract body with UTC dates and nulls', () {
    final local = DateTime.utc(2026, 10, 20, 10, 30).toLocal();
    final dto = CreateServiceRequestDto(
      NewServiceVisit(
        serviceDate: local,
        odometerKm: 34850,
        workshop: 'اتوسرویس البرز',
        lineItems: const [ServiceLineItem(itemId: 'engine_oil', cost: 0)],
      ),
    );

    expect(dto.toJson(), {
      'serviceDate': '2026-10-20T10:30:00.000Z',
      'odometerKm': 34850,
      'workshop': 'اتوسرویس البرز',
      'notes': null,
      'lineItems': [
        {
          'itemId': 'engine_oil',
          'brand': null,
          'cost': 0,
          'notes': null,
          'nextDueKm': null,
          'nextDueMonths': null,
        },
      ],
    });
  });

  test('UpdateServiceRequestDto sends only the fields that are set', () {
    expect(const UpdateServiceRequestDto(ServiceVisitUpdate(lineItems: [filterLine])).toJson(), {
      'lineItems': [filterLineJson],
    });
    expect(const UpdateServiceRequestDto(ServiceVisitUpdate(workshop: 'x')).toJson(), {
      'workshop': 'x',
    });
  });
}
