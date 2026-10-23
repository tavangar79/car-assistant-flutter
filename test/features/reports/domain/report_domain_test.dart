import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/reports/domain/entities/report.dart';
import 'package:car_assistant/features/reports/domain/entities/report_options.dart';
import 'package:car_assistant/features/reports/domain/entities/report_period.dart';
import 'package:car_assistant/features/reports/domain/entities/report_query.dart';
import 'package:car_assistant/features/reports/domain/repositories/report_repository.dart';
import 'package:car_assistant/features/reports/domain/usecases/get_report.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../history/history_fixtures.dart';

class MockReportRepository extends Mock implements ReportRepository {}

void main() {
  // ۲۵ آبان ۱۴۰۳, as in the Stitch screen.
  final now = DateTime(2024, 11, 15, 18, 30);

  group('ReportOptions.range', () {
    (DateTime?, DateTime?) range(ReportPeriod period) => ReportOptions(period: period).range(now);

    test('the last 3 and 6 months start on the same Jalali day', () {
      expect(range(ReportPeriod.lastThreeMonths), (DateTime(2024, 8, 15), now)); // ۲۵ مرداد
      expect(range(ReportPeriod.lastSixMonths), (DateTime(2024, 5, 14), now)); // ۲۵ اردیبهشت
    });

    test('the current year starts on 1 Farvardin', () {
      expect(range(ReportPeriod.currentYear), (DateTime(2024, 3, 20), now)); // ۱ فروردین ۱۴۰۳
    });

    test('all records have no bounds', () {
      expect(range(ReportPeriod.allTime), (null, null));
    });

    test('a day missing in the target month falls back to its last day', () {
      // Six months before ۳۱ شهریور ۱۴۰۳ is اسفند ۱۴۰۲, which has 29 days.
      final day = DateTime(2024, 9, 21); // ۳۱ شهریور ۱۴۰۳
      final (from, _) = const ReportOptions(period: ReportPeriod.lastSixMonths).range(day);
      expect(from, DateTime(2024, 3, 19)); // ۲۹ اسفند ۱۴۰۲
    });

    test('a custom range covers whole days', () {
      final options = const ReportOptions().withCustomRange(
        now,
        from: DateTime(2024, 4, 1),
        to: DateTime(2024, 4, 30),
      );
      expect(options.period, ReportPeriod.custom);
      expect(options.range(now), (
        DateTime(2024, 4, 1),
        DateTime(2024, 5, 1).subtract(const Duration(milliseconds: 1)),
      ));
    });

    test('picking one bound keeps the other one of the current range', () {
      final options = const ReportOptions().withCustomRange(now, to: DateTime(2024, 10, 1));
      expect(options.customFrom, DateTime(2024, 3, 20));
      expect(options.customTo, DateTime(2024, 10, 1));
    });
  });

  group('ReportOptions.toQuery', () {
    test('sends the vehicle, the chosen types in a fixed order and the range', () {
      final options = const ReportOptions(
        vehicleId: 'v1',
        types: {HistoryType.expense, HistoryType.service},
      );
      expect(
        options.toQuery(now),
        ReportQuery(
          vehicleIds: const ['v1'],
          types: const [HistoryType.service, HistoryType.expense],
          from: DateTime(2024, 3, 20),
          to: now,
        ),
      );
    });

    test('every vehicle is no vehicle id', () {
      expect(const ReportOptions().toQuery(now).vehicleIds, isEmpty);
    });

    test('a quick period drops the custom days', () {
      final options = const ReportOptions()
          .withCustomRange(now, from: DateTime(2024, 1, 1))
          .withPeriod(ReportPeriod.allTime);
      expect(options.customFrom, isNull);
      expect(options.customTo, isNull);
    });
  });

  group('GetReport', () {
    late MockReportRepository repository;
    late GetReport getReport;

    setUpAll(() => registerFallbackValue(const ReportQuery()));

    setUp(() {
      repository = MockReportRepository();
      getReport = GetReport(repository, now: () => now);
    });

    test('asks the repository with the options resolved at now', () async {
      final report = Report(entries: [serviceEntry()], summary: summary);
      when(() => repository.getReport(any())).thenAnswer((_) async => Right(report));

      final result = await getReport(const ReportOptions(vehicleId: 'v1'));

      expect(result, Right<Failure, Report>(report));
      verify(
        () => repository.getReport(
          ReportQuery(vehicleIds: const ['v1'], from: DateTime(2024, 3, 20), to: now),
        ),
      ).called(1);
    });

    test('without a record type it answers an empty report and sends nothing', () async {
      final result = await getReport(const ReportOptions(types: {}));

      expect(result, const Right<Failure, Report>(GetReport.empty));
      verifyNever(() => repository.getReport(any()));
    });

    test('passes failures through', () async {
      when(() => repository.getReport(any())).thenAnswer((_) async => const Left(Failure('boom')));

      expect(await getReport(const ReportOptions()), const Left<Failure, Report>(Failure('boom')));
    });
  });
}
