import 'dart:typed_data';

import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/services/domain/entities/create_service_result.dart';
import 'package:car_assistant/features/services/domain/entities/invoice_file.dart';
import 'package:car_assistant/features/services/domain/entities/new_service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_failures.dart';
import 'package:car_assistant/features/services/domain/entities/service_field.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_draft.dart';
import 'package:car_assistant/features/services/domain/entities/service_line_item.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_draft.dart';
import 'package:car_assistant/features/services/domain/entities/service_visit_update.dart';
import 'package:car_assistant/features/services/domain/repositories/service_repository.dart';
import 'package:car_assistant/features/services/domain/entities/service_suggestions.dart';
import 'package:car_assistant/features/services/domain/entities/service_category.dart';
import 'package:car_assistant/features/services/domain/usecases/create_service_visit.dart';
import 'package:car_assistant/features/services/domain/usecases/get_service_catalog.dart';
import 'package:car_assistant/features/services/domain/usecases/get_service_suggestions.dart';
import 'package:car_assistant/features/services/domain/usecases/update_service_line_items.dart';
import 'package:car_assistant/features/services/domain/usecases/upload_service_invoice.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../vehicles/vehicle_fixtures.dart';
import '../../service_fixtures.dart';

class MockServiceRepository extends Mock implements ServiceRepository {}

void main() {
  late MockServiceRepository repository;
  final now = DateTime(2026, 10, 21, 18, 45);
  final file = InvoiceFile(bytes: Uint8List.fromList([1, 2, 3]), fileName: 'فاکتور.jpg');

  setUpAll(() {
    registerFallbackValue(
      NewServiceVisit(serviceDate: now, odometerKm: 0, workshop: 'x', lineItems: const []),
    );
    registerFallbackValue(file);
    registerFallbackValue(const ServiceVisitUpdate());
  });

  setUp(() => repository = MockServiceRepository());

  group('CreateServiceVisit', () {
    late CreateServiceVisit createVisit;

    setUp(() => createVisit = CreateServiceVisit(repository, now: () => now));

    const draft = ServiceVisitDraft(
      itemIds: ['engine_oil', 'oil_filter'],
      odometerKm: 34850,
      stickerNextKm: 41850,
      workshop: ' اتوسرویس البرز ',
      lines: {
        'engine_oil': ServiceLineDraft(brand: 'بهران', cost: 1850000, nextDueMonths: 6),
        'oil_filter': ServiceLineDraft(cost: 280000),
      },
    );

    test(
      'checks the draft, sends the visit at now with the sticker reminder, then returns it',
      () async {
        when(() => repository.createVisit('v1', any())).thenAnswer((_) async => Right(visit()));

        final result = await createVisit(tara, draft);

        expect(result, Right<Failure, CreateServiceResult>(CreateServiceResult(visit())));
        final sent =
            verify(() => repository.createVisit('v1', captureAny())).captured.single
                as NewServiceVisit;
        expect(sent.serviceDate, now);
        expect(sent.odometerKm, 34850);
        expect(sent.workshop, 'اتوسرویس البرز');
        expect(sent.lineItems, const [
          ServiceLineItem(
            itemId: 'engine_oil',
            brand: 'بهران',
            cost: 1850000,
            nextDueKm: 7000,
            nextDueMonths: 6,
          ),
          ServiceLineItem(itemId: 'oil_filter', cost: 280000),
        ]);
        verifyNever(() => repository.uploadInvoice(any(), any(), any()));
      },
    );

    test('uploads the invoice after the visit; an upload failure is reported, not fatal', () async {
      when(() => repository.createVisit('v1', any())).thenAnswer((_) async => Right(visit()));
      when(() => repository.uploadInvoice('v1', 's1', file))
          .thenAnswer((_) async => const Left(InvoiceTooLargeFailure()));

      final result = await createVisit(tara, draft, invoice: file);

      expect(
        result,
        Right<Failure, CreateServiceResult>(
          CreateServiceResult(visit(), invoiceFailure: const InvoiceTooLargeFailure()),
        ),
      );
    });

    test(
      'rejects an empty selection, a missing workshop and a future date before sending',
      () async {
        final result = await createVisit(
          tara,
          ServiceVisitDraft(serviceDay: DateTime(2026, 10, 22), workshop: ''),
        );

        expect(
          result,
          const Left<Failure, CreateServiceResult>(
            InvalidServiceFailure({
              ServiceField.serviceDate,
              ServiceField.workshop,
              ServiceField.lineItems,
            }),
          ),
        );
        verifyNever(() => repository.createVisit(any(), any()));
      },
    );

    test('rejects a line with a reminder out of range', () async {
      final result = await createVisit(
        tara,
        const ServiceVisitDraft(
          itemIds: ['engine_oil'],
          workshop: 'x',
          lines: {'engine_oil': ServiceLineDraft(cost: 1, nextDueKm: 50)},
        ),
      );

      expect(
        result,
        const Left<Failure, CreateServiceResult>(InvalidServiceFailure({ServiceField.lineItems})),
      );
    });

    test('rejects an empty or oversized invoice before sending', () async {
      expect(
        await createVisit(
          tara,
          draft,
          invoice: InvoiceFile(bytes: Uint8List(0), fileName: 'a.jpg'),
        ),
        const Left<Failure, CreateServiceResult>(InvalidInvoiceFailure()),
      );
      expect(
        await createVisit(
          tara,
          draft,
          invoice: InvoiceFile(bytes: Uint8List(InvoiceFile.maxBytes + 1), fileName: 'a.jpg'),
        ),
        const Left<Failure, CreateServiceResult>(InvoiceTooLargeFailure()),
      );
      verifyNever(() => repository.createVisit(any(), any()));
    });

    test('passes the repository failure through', () async {
      when(() => repository.createVisit('v1', any()))
          .thenAnswer((_) async => const Left(ServiceRejectedFailure('future')));

      expect(
        await createVisit(tara, draft),
        const Left<Failure, CreateServiceResult>(ServiceRejectedFailure('future')),
      );
    });
  });

  test('GetServiceCatalog passes the vehicle id through (null for the title lookup)', () async {
    when(() => repository.getCatalog(vehicleId: any(named: 'vehicleId')))
        .thenAnswer((_) async => const Right(serviceCatalog));
    final getCatalog = GetServiceCatalog(repository);

    expect(
      await getCatalog(vehicleId: 'v1'),
      const Right<Failure, List<ServiceCategory>>(serviceCatalog),
    );
    await getCatalog();

    verify(() => repository.getCatalog(vehicleId: 'v1')).called(1);
    verify(() => repository.getCatalog()).called(1);
  });

  test('GetServiceSuggestions passes the repository result through', () async {
    const suggestions = ServiceSuggestions(
      workshops: ['x'],
      brands: {
        'engine_oil': ['y'],
      },
    );
    when(() => repository.getSuggestions()).thenAnswer((_) async => const Right(suggestions));

    expect(
      await GetServiceSuggestions(repository)(),
      const Right<Failure, ServiceSuggestions>(suggestions),
    );
    expect(suggestions.brandsFor('engine_oil'), ['y']);
    expect(suggestions.brandsFor('coolant'), isEmpty);
  });

  group('UpdateServiceLineItems', () {
    late UpdateServiceLineItems updateLines;

    setUp(() => updateLines = UpdateServiceLineItems(repository));

    test('replaces the list', () async {
      when(
        () => repository.updateVisit('v1', 's1', const ServiceVisitUpdate(lineItems: [filterLine])),
      ).thenAnswer((_) async => Right(visit(lines: const [filterLine])));

      expect(
        await updateLines('v1', 's1', const [filterLine]),
        Right<Failure, ServiceVisit>(visit(lines: const [filterLine])),
      );
    });

    test('rejects an empty list and duplicate items before sending', () async {
      expect(
        await updateLines('v1', 's1', const []),
        const Left<Failure, ServiceVisit>(InvalidServiceFailure({ServiceField.lineItems})),
      );
      expect(
        await updateLines('v1', 's1', const [filterLine, filterLine]),
        const Left<Failure, ServiceVisit>(InvalidServiceFailure({ServiceField.lineItems})),
      );
      verifyNever(() => repository.updateVisit(any(), any(), any()));
    });
  });

  group('UploadServiceInvoice', () {
    test('rejects an empty file and uploads a valid one', () async {
      final upload = UploadServiceInvoice(repository);
      when(() => repository.uploadInvoice('v1', 's1', file))
          .thenAnswer((_) async => Right(visit(withInvoice: true)));

      expect(
        await upload('v1', 's1', InvoiceFile(bytes: Uint8List(0), fileName: 'a.jpg')),
        const Left<Failure, ServiceVisit>(InvalidInvoiceFailure()),
      );
      expect(
        await upload('v1', 's1', file),
        Right<Failure, ServiceVisit>(visit(withInvoice: true)),
      );
    });
  });
}
