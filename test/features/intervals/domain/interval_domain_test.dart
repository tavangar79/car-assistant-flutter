import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/intervals/domain/entities/due_item.dart';
import 'package:car_assistant/features/intervals/domain/entities/due_status.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_failures.dart';
import 'package:car_assistant/features/intervals/domain/entities/interval_setting.dart';
import 'package:car_assistant/features/intervals/domain/entities/service_interval.dart';
import 'package:car_assistant/features/intervals/domain/repositories/interval_repository.dart';
import 'package:car_assistant/features/intervals/domain/usecases/save_service_intervals.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../interval_fixtures.dart';

class MockIntervalRepository extends Mock implements IntervalRepository {}

void main() {
  group('SaveServiceIntervals', () {
    late MockIntervalRepository repository;
    late SaveServiceIntervals save;

    setUp(() {
      repository = MockIntervalRepository();
      save = SaveServiceIntervals(repository);
    });

    test('sends valid settings', () async {
      const settings = [IntervalSetting(id: 'engine_oil', km: 7000, months: 6)];
      when(() => repository.setIntervals('v1', settings))
          .thenAnswer((_) async => const Right(intervals));

      expect(await save('v1', settings), const Right<Failure, List<ServiceInterval>>(intervals));
    });

    test('rejects values outside the limits, naming the intervals, before sending', () async {
      final result = await save('v1', const [
        IntervalSetting(id: 'engine_oil', km: 400, months: 6),
        IntervalSetting(id: 'air_filter', km: 10000, months: 121),
        IntervalSetting(id: 'coolant', km: 40000, months: 24),
      ]);

      expect(
        result,
        const Left<Failure, List<ServiceInterval>>(
          InvalidIntervalsFailure({'engine_oil', 'air_filter'}),
        ),
      );
      expect(
        await save('v1', const []),
        const Left<Failure, List<ServiceInterval>>(InvalidIntervalsFailure({})),
      );
      verifyNever(() => repository.setIntervals(any(), any()));
    });
  });

  group('DueItem.worseAxis', () {
    DueItem item(int km, int days) => dueItem(
      id: 'x',
      title: 'x',
      icon: 'x',
      covers: const [],
      status: DueStatus.ok,
      dueKm: 0,
      remainingKm: km,
      remainingDays: days,
    );

    test('picks the axis whose status is worse, km on a tie', () {
      expect(item(-350, 20).worseAxis, DueAxis.km); // overdue by km, upcoming by days
      expect(item(2000, -2).worseAxis, DueAxis.days); // overdue by days only
      expect(item(150, 10).worseAxis, DueAxis.km); // both due soon → km
      expect(item(1200, 10).worseAxis, DueAxis.days); // upcoming by km, due soon by days
      expect(item(5000, 200).worseAxis, DueAxis.km); // both ok → km
    });
  });

  test(
    'DueReport.pending keeps the non-ok items in order; reachedCount counts overdue and due soon',
    () {
      expect(dueReport.pending, [overdueOil, dueSoonPads, upcomingAir]);
      expect(dueReport.reachedCount, 2);
      expect(allOkReport.pending, isEmpty);
      expect(allOkReport.reachedCount, 0);
    },
  );

  test('DueStatus.fromApi reads the wire values', () {
    expect(DueStatus.fromApi('due_soon'), DueStatus.dueSoon);
    expect(DueStatus.fromApi('weird'), DueStatus.ok);
  });
}
