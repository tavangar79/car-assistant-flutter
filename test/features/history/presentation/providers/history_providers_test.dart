import 'package:car_assistant/core/error/failure.dart';
import 'package:car_assistant/features/history/domain/entities/history_categories.dart';
import 'package:car_assistant/features/history/domain/entities/history_filter.dart';
import 'package:car_assistant/features/history/domain/entities/history_period.dart';
import 'package:car_assistant/features/history/domain/entities/history_query.dart';
import 'package:car_assistant/features/history/domain/entities/history_result.dart';
import 'package:car_assistant/features/history/domain/entities/history_type.dart';
import 'package:car_assistant/features/history/domain/repositories/history_repository.dart';
import 'package:car_assistant/features/history/presentation/providers/history_providers.dart';
import 'package:car_assistant/features/odometer/presentation/providers/odometer_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../history_fixtures.dart';

class MockHistoryRepository extends Mock implements HistoryRepository {}

void main() {
  final now = DateTime(2026, 10, 21, 18, 45);
  late MockHistoryRepository repository;
  late ProviderContainer container;

  setUpAll(() => registerFallbackValue(const HistoryQuery()));

  setUp(() {
    repository = MockHistoryRepository();
    when(() => repository.getHistory(any(that: _withCursor(null))))
        .thenAnswer((_) async => Right(historyResult()));
    when(() => repository.getHistory(any(that: _withCursor('c1'))))
        .thenAnswer((_) async => Right(HistoryResult(entries: [expenseEntry()], nextCursor: null)));
    container = ProviderContainer(
      overrides: [
        historyRepositoryProvider.overrideWithValue(repository),
        clockProvider.overrideWithValue(() => now),
      ],
    );
    addTearDown(container.dispose);
  });

  group('HistoryFilterNotifier', () {
    test('starts with everything shown', () {
      expect(container.read(historyFilterProvider), HistoryFilter.initial);
    });

    test('showCurrentYear presets only the current year', () {
      final notifier = container.read(historyFilterProvider.notifier)
        ..toggleAttachmentsOnly()
        ..showCurrentYear();

      expect(notifier.state, HistoryFilter.initial.withPeriod(HistoryPeriod.currentYear));
    });

    test('showWithAttachment presets only the attachment filter', () {
      final notifier = container.read(historyFilterProvider.notifier)
        ..setType(HistoryType.fuel)
        ..showWithAttachment();

      expect(notifier.state, const HistoryFilter(attachmentsOnly: true));
    });
  });

  group('HistoryController', () {
    test('loads the first page of the applied filter', () async {
      final state = await container.read(historyControllerProvider.future);

      expect(state.entries, historyResult().entries);
      expect(state.summary, summary);
      expect(state.hasMore, isTrue);
    });

    test('loadMore appends the next page and keeps the summary', () async {
      final sub = container.listen(historyControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(historyControllerProvider.future);

      await container.read(historyControllerProvider.notifier).loadMore();

      final state = container.read(historyControllerProvider).value!;
      expect(state.entries, [...historyResult().entries, expenseEntry()]);
      expect(state.summary, summary);
      expect(state.hasMore, isFalse);
      verify(() => repository.getHistory(any(that: _withCursor('c1')))).called(1);
    });

    test('a failed next page is kept as loadMoreFailed with the loaded entries', () async {
      when(() => repository.getHistory(any(that: _withCursor('c1'))))
          .thenAnswer((_) async => const Left(Failure('boom')));
      final sub = container.listen(historyControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(historyControllerProvider.future);

      await container.read(historyControllerProvider.notifier).loadMore();

      final state = container.read(historyControllerProvider).value!;
      expect(state.loadMoreFailed, isTrue);
      expect(state.entries, historyResult().entries);
      expect(state.hasMore, isTrue);
    });

    test('a new filter starts over from the first page', () async {
      final sub = container.listen(historyControllerProvider, (_, _) {});
      addTearDown(sub.close);
      await container.read(historyControllerProvider.future);

      container.read(historyFilterProvider.notifier).setType(HistoryType.expense);
      await container.read(historyControllerProvider.future);

      verify(
        () => repository.getHistory(
          any(that: isA<HistoryQuery>().having((q) => q.type, 'type', HistoryType.expense)),
        ),
      ).called(1);
    });
  });

  group('HistoryFilterDraft', () {
    test('starts as the applied filter and only applies on apply', () {
      container.read(historyFilterProvider.notifier).showWithAttachment();
      final sub = container.listen(historyFilterDraftProvider, (_, _) {});
      addTearDown(sub.close);

      container.read(historyFilterDraftProvider.notifier).toggleCategory('fluids');

      expect(container.read(historyFilterDraftProvider).categories, {'fluids'});
      expect(container.read(historyFilterProvider), const HistoryFilter(attachmentsOnly: true));
    });

    test('choosing every vehicle one by one means all vehicles', () {
      final sub = container.listen(historyFilterDraftProvider, (_, _) {});
      addTearDown(sub.close);
      final draft = container.read(historyFilterDraftProvider.notifier);

      draft.toggleVehicle('v1', garageSize: 2);
      expect(container.read(historyFilterDraftProvider).vehicleIds, {'v1'});

      draft.toggleVehicle('v2', garageSize: 2);
      expect(container.read(historyFilterDraftProvider).vehicleIds, isEmpty);
    });

    test('select all picks every category; reset clears all but the type', () {
      container.read(historyFilterProvider.notifier).setType(HistoryType.service);
      final sub = container.listen(historyFilterDraftProvider, (_, _) {});
      addTearDown(sub.close);
      final draft = container.read(historyFilterDraftProvider.notifier)
        ..selectAllCategories()
        ..setAttachmentsOnly(true);
      expect(container.read(historyFilterDraftProvider).categories, HistoryCategories.all.toSet());

      draft.reset();

      expect(
        container.read(historyFilterDraftProvider),
        const HistoryFilter(type: HistoryType.service),
      );
    });

    test('the match count is the summary of a limit=1 query', () async {
      final sub = container.listen(historyMatchCountProvider, (_, _) {});
      addTearDown(sub.close);

      expect(await container.read(historyMatchCountProvider.future), 23);
      verify(
        () => repository.getHistory(
          any(that: isA<HistoryQuery>().having((q) => q.limit, 'limit', 1)),
        ),
      ).called(1);
    });
  });
}

Matcher _withCursor(String? cursor) =>
    isA<HistoryQuery>().having((query) => query.cursor, 'cursor', cursor);
