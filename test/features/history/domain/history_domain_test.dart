import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/history/domain/entities/history_categories.dart';
import 'package:car_assistant/features/history/domain/entities/history_filter.dart';
import 'package:car_assistant/features/history/domain/entities/history_month_group.dart';
import 'package:car_assistant/features/history/domain/entities/history_period.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/domain/usecases/get_history.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../history_fixtures.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45); // ۲۹ مهر ۱۴۰۵

  group('HistoryFilter', () {
    test('initial has nothing active and no date bounds', () {
      expect(HistoryFilter.initial.activeCount, 0);
      expect(HistoryFilter.initial.range(now), (null, null));
    });

    test('counts the vehicle, category, attachment and period filters, not the type', () {
      final filter = const HistoryFilter(
        vehicleIds: {'v1'},
        type: HistoryType.fuel,
        categories: {'fluids'},
        attachmentsOnly: true,
      ).withPeriod(HistoryPeriod.currentYear);

      expect(filter.activeCount, 4);
    });

    test('the current year runs from ۱ فروردین to now', () {
      final filter = HistoryFilter.initial.withPeriod(HistoryPeriod.currentYear);

      expect(filter.range(now), (DateTime(2026, 3, 21), now));
    });

    test('the last six months start on the first day of the month five months back', () {
      final filter = HistoryFilter.initial.withPeriod(HistoryPeriod.lastSixMonths);

      expect(filter.range(now), (DateTime(2026, 4, 21), now)); // ۱ اردیبهشت ۱۴۰۵
    });

    test('a custom range covers its first and last day completely', () {
      final filter = HistoryFilter.initial.withPeriod(
        HistoryPeriod.custom,
        from: DateTime(2026, 5, 1, 15),
        to: DateTime(2026, 5, 10),
      );

      expect(filter.range(now), (DateTime(2026, 5, 1), DateTime(2026, 5, 10, 23, 59, 59, 999)));
    });

    test('another period drops the custom days', () {
      final filter = HistoryFilter.initial
          .withPeriod(HistoryPeriod.custom, from: DateTime(2026, 5, 1), to: DateTime(2026, 5, 2))
          .withPeriod(HistoryPeriod.allTime);

      expect(filter, HistoryFilter.initial);
    });

    test('compares the sets by content', () {
      expect(
        const HistoryFilter(vehicleIds: {'v1', 'v2'}),
        const HistoryFilter(vehicleIds: {'v2', 'v1'}),
      );
    });
  });

  group('groupByJalaliMonth', () {
    test('groups by Jalali month in order, with the cost total of each', () {
      final groups = groupByJalaliMonth([serviceEntry(), fuelEntry(), expenseEntry()]);

      expect([for (final g in groups) (g.year, g.month)], [(1405, 7), (1404, 8), (1403, 8)]);
      expect(groups.first.totalCost, 2130000);
    });

    test('keeps entries of the same month together', () {
      final groups = groupByJalaliMonth([fuelEntry(), fuelEntry()]);

      expect(groups.single.entries, hasLength(2));
      expect(groups.single.totalCost, 291000);
    });

    test('is empty without entries', () {
      expect(groupByJalaliMonth(const []), isEmpty);
    });
  });

  group('GetHistory', () {
    late MockHistoryRepository repository;

    setUpAll(() => registerFallbackValue(const HistoryQuery()));

    setUp(() {
      repository = MockHistoryRepository();
      when(() => repository.getHistory(any())).thenAnswer((_) async => Right(historyResult()));
    });

    test('turns the filter into a query, categories in screen order', () async {
      final filter = const HistoryFilter(
        vehicleIds: {'v1'},
        type: HistoryType.service,
        categories: {HistoryCategories.legal, 'brakes'},
        attachmentsOnly: true,
      ).withPeriod(HistoryPeriod.currentYear);

      final result = await GetHistory(repository, now: () => now)(filter, cursor: 'c1', limit: 1);

      expect(result, Right<Failure, HistoryResult>(historyResult()));
      verify(
        () => repository.getHistory(
          HistoryQuery(
            vehicleIds: const ['v1'],
            type: HistoryType.service,
            categories: const ['brakes', 'legal'],
            attachmentsOnly: true,
            from: DateTime(2026, 3, 21),
            to: now,
            cursor: 'c1',
            limit: 1,
          ),
        ),
      ).called(1);
    });

    test('passes a failure through', () async {
      when(() => repository.getHistory(any())).thenAnswer((_) async => const Left(Failure('boom')));

      final result = await GetHistory(repository, now: () => now)(HistoryFilter.initial);

      expect(result, const Left<Failure, HistoryResult>(Failure('boom')));
    });
  });
}
