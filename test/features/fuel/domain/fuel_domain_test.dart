import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/core/error/network_failure.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_economy.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_failures.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_field.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_log_draft.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_payment_method.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_rules.dart';
import 'package:car_assistant/features/fuel/domain/entities/fuel_type.dart';
import 'package:car_assistant/features/fuel/domain/entities/new_fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/repositories/fuel_repository.dart';
import 'package:car_assistant/features/fuel/domain/usecases/create_fuel_log.dart';
import 'package:car_assistant/features/fuel/domain/usecases/get_fuel_logs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../vehicles/vehicle_fixtures.dart';
import '../fuel_fixtures.dart';

class MockFuelRepository extends Mock implements FuelRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45);

  setUpAll(() {
    registerFallbackValue(
      NewFuelLog(
        fueledAt: now,
        odometerKm: 0,
        fuelType: FuelType.regular,
        volume: 1,
        totalCost: 0,
        isFullFill: true,
      ),
    );
  });

  group('FuelLogDraft', () {
    test('defaults to today at now, the vehicle mileage, regular fuel and a full fill', () {
      const draft = FuelLogDraft();
      expect(draft.fueledAt(now), now);
      expect(draft.odometerKm, isNull);
      expect(draft.fuelType, FuelType.regular);
      expect(draft.isFullFill, isTrue);
    });

    test('combines the chosen day with the chosen time', () {
      final draft = FuelLogDraft(fueledDay: DateTime(2026, 10, 20), fueledMinutes: 16 * 60 + 42);
      expect(draft.fueledAt(now), DateTime(2026, 10, 20, 16, 42));
    });

    test('computes the rate per unit from the cost and the volume', () {
      expect(const FuelLogDraft(volume: 48.5, totalCost: 145500).ratePerUnit, 3000);
      expect(const FuelLogDraft(volume: 48.5).ratePerUnit, isNull);
      expect(const FuelLogDraft(volume: 0, totalCost: 1000).ratePerUnit, isNull);
    });
  });

  group('FuelRules.validate', () {
    const draft = FuelLogDraft(
      odometerKm: 34850,
      fuelType: FuelType.superGrade,
      volume: 48.567,
      totalCost: 145500,
      station: '  جایگاه اختصاصی ۲۴  ',
      paymentMethod: FuelPaymentMethod.cash,
      notes: '   ',
    );

    test('returns the log to send: rounded volume, trimmed station, empty notes dropped', () {
      final result = FuelRules.validate(draft, currentKm: 34500, now: now);

      expect(
        result,
        Right<InvalidFuelLogFailure, NewFuelLog>(
          NewFuelLog(
            fueledAt: now,
            odometerKm: 34850,
            fuelType: FuelType.superGrade,
            volume: 48.57,
            totalCost: 145500,
            isFullFill: true,
            station: 'جایگاه اختصاصی ۲۴',
            paymentMethod: FuelPaymentMethod.cash,
          ),
        ),
      );
    });

    test('uses the vehicle mileage when no odometer was typed', () {
      final result = FuelRules.validate(
        const FuelLogDraft(volume: 10, totalCost: 0),
        currentKm: 34500,
        now: now,
      );
      expect(result.toNullable()!.odometerKm, 34500);
      expect(result.toNullable()!.station, isNull);
    });

    test('names every invalid field', () {
      final result = FuelRules.validate(
        FuelLogDraft(
          fueledMinutes: now.hour * 60 + now.minute + 1,
          odometerKm: -1,
          volume: 0,
          station: 'x' * 101,
          notes: 'y' * 501,
        ),
        currentKm: 34500,
        now: now,
      );

      expect(
        result,
        const Left<InvalidFuelLogFailure, NewFuelLog>(
          InvalidFuelLogFailure({
            FuelField.fueledAt,
            FuelField.odometerKm,
            FuelField.volume,
            FuelField.totalCost,
            FuelField.station,
            FuelField.notes,
          }),
        ),
      );
    });

    test('rejects a volume above the maximum', () {
      final result = FuelRules.validate(
        const FuelLogDraft(volume: 1000.5, totalCost: 1),
        currentKm: 0,
        now: now,
      );
      expect(result.getLeft().toNullable()!.fields, {FuelField.volume});
    });
  });

  group('previewFuelEconomy', () {
    FuelEconomyPreview? preview(
      List<FuelLog> logs, {
      int odometerKm = 34850,
      FuelType fuelType = FuelType.regular,
      double? volume = 48.5,
      bool isFullFill = true,
    }) => previewFuelEconomy(
      logs,
      odometerKm: odometerKm,
      fuelType: fuelType,
      volume: volume,
      isFullFill: isFullFill,
    );

    test('is null without a previous full fill', () {
      expect(preview(const []), isNull);
      expect(preview([fuelLog(odometerKm: 34200, isFullFill: false)]), isNull);
    });

    test('is null for a partial fill, a missing volume or a mixed fuel type', () {
      final previous = fuelLog(odometerKm: 34200);
      expect(preview([previous], isFullFill: false), isNull);
      expect(preview([previous], volume: null), isNull);
      expect(preview([previous], fuelType: FuelType.superGrade), isNull);
      expect(
        preview([
          previous,
          fuelLog(id: 'p', odometerKm: 34500, fuelType: FuelType.cng, isFullFill: false),
        ]),
        isNull,
      );
    });

    test('divides the volume by the distance since the previous full fill', () {
      expect(
        preview([fuelLog(odometerKm: 34200)]),
        const FuelEconomyPreview(economy: 7.46, distanceKm: 650, volume: 48.5),
      );
    });

    test('sums the partial fills between the two full fills', () {
      final logs = [
        fuelLog(id: 'a', odometerKm: 34200),
        fuelLog(id: 'b', odometerKm: 34500, volume: 10, isFullFill: false),
      ];
      expect(
        preview(logs, volume: 38.5),
        const FuelEconomyPreview(economy: 7.46, distanceKm: 650, volume: 48.5),
      );
    });

    test('ignores logs at or beyond the entered odometer and a zero distance', () {
      final logs = [fuelLog(id: 'a', odometerKm: 34200), fuelLog(id: 'b', odometerKm: 36000)];
      expect(preview(logs)!.distanceKm, 650);
      expect(preview([fuelLog(odometerKm: 34850)]), isNull);
    });

    test('list order does not matter', () {
      final logs = [
        fuelLog(id: 'b', odometerKm: 34500, volume: 10, isFullFill: false),
        fuelLog(id: 'a', odometerKm: 34200),
      ];
      expect(preview(logs, volume: 38.5)!.economy, 7.46);
    });
  });

  group('use cases', () {
    late MockFuelRepository repository;

    setUp(() => repository = MockFuelRepository());

    test('GetFuelLogs delegates to the repository', () async {
      when(() => repository.getLogs('v1')).thenAnswer((_) async => Right([contractFuelLog()]));

      final result = await GetFuelLogs(repository)('v1');

      expect(result.toNullable(), [contractFuelLog()]);
    });

    test('CreateFuelLog checks the draft, then sends it for the vehicle', () async {
      when(() => repository.createLog('v1', any()))
          .thenAnswer((_) async => Right(contractFuelLog()));
      final createLog = CreateFuelLog(repository, now: () => now);

      final result = await createLog(
        tara,
        const FuelLogDraft(odometerKm: 34850, volume: 48.5, totalCost: 145500),
      );

      expect(result, Right<Failure, FuelLog>(contractFuelLog()));
      final sent =
          verify(() => repository.createLog('v1', captureAny())).captured.single as NewFuelLog;
      expect(sent.fueledAt, now);
      expect(sent.odometerKm, 34850);
      expect(sent.volume, 48.5);
    });

    test('CreateFuelLog rejects an invalid draft without calling the repository', () async {
      final createLog = CreateFuelLog(repository, now: () => now);

      final result = await createLog(tara, const FuelLogDraft());

      expect(result.getLeft().toNullable()!, isA<InvalidFuelLogFailure>());
      verifyNever(() => repository.createLog(any(), any()));
    });

    test('CreateFuelLog passes a repository failure through', () async {
      when(() => repository.createLog('v1', any()))
          .thenAnswer((_) async => const Left(NetworkFailure()));
      final createLog = CreateFuelLog(repository, now: () => now);

      final result = await createLog(tara, const FuelLogDraft(volume: 10, totalCost: 1000));

      expect(result, const Left<Failure, FuelLog>(NetworkFailure()));
    });
  });
}
