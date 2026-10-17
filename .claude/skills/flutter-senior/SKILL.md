---
name: flutter-senior
description: Conventions and step-by-step recipes for the Car Assistant Flutter app (DDD + Clean Architecture, Riverpod 3 without codegen, dio, fpdart, equatable, mocktail). Use when adding or changing a feature, screen, widget, provider, entity, repository, DTO, or Flutter test in client/.
---

# Flutter senior playbook

Goal: code that is **simple, readable, and testable**. Read `client/CLAUDE.md` first.

## Recipe: add a feature (e.g. `trips`)

Create `lib/features/trips/` with three layers, and mirror it in `test/features/trips/`.

### 1. Domain (pure Dart, no Flutter, Dio, or Riverpod imports; fpdart is fine)
- `domain/entities/trip.dart`: an immutable `Equatable` class with `const` constructor and `final` fields.
- `domain/repositories/trip_repository.dart`: `abstract interface class TripRepository { Future<Either<Failure, List<Trip>>> getTrips(); }`.
- `domain/usecases/get_trips.dart`: a class with a single `call()` that holds business rules (sorting, filtering).
- **Test first** in `test/.../usecases/get_trips_test.dart`, using `class MockTripRepository extends Mock implements TripRepository {}`.

### 2. Data
- `data/models/trip_dto.dart`: `fromJson` matching the backend contract exactly, plus `toEntity()`.
- `data/datasources/trip_remote_data_source.dart`: takes the `Dio` by constructor (paths like `/api/trips`;
  base URL and token come from `dioProvider`). Dio throws `DioException` on a non-2xx response.
- `data/repositories/trip_repository_impl.dart`: implements the domain interface, wrapping each call in
  `apiCall(() => ..., onStatus: (status, error) => ...)` so every error becomes a `Left(Failure)`.
- **Test** with a mocktail `MockDio`, covering success mapping, non-2xx (`DioException.badResponse`), and network
  errors (`DioException.connectionError` → `NetworkFailure`).

### 3. Presentation
- `presentation/providers/trip_providers.dart`:
  ```dart
  final tripRepositoryProvider = Provider<TripRepository>((ref) =>
      TripRepositoryImpl(TripRemoteDataSource(ref.watch(dioProvider))));
  final getTripsProvider = Provider((ref) => GetTrips(ref.watch(tripRepositoryProvider)));
  final tripsProvider = FutureProvider<List<Trip>>((ref) async =>
      (await ref.watch(getTripsProvider).call()).getOrElse((failure) => throw failure));
  ```
  For mutable state (create, update, delete), use an `AsyncNotifier` + `AsyncNotifierProvider` and call
  `ref.invalidate(...)` after a write.
- `presentation/pages/trips_page.dart`: a `ConsumerWidget` that renders `ref.watch(tripsProvider).when(...)`
  with loading, error (`Failure.message` + Retry), empty, and data states.
- `presentation/widgets/`: small `StatelessWidget`s that receive entities, with no providers inside.
- **Widget test** with `ProviderScope(overrides: [tripRepositoryProvider.overrideWithValue(mock)])` +
  `pumpAndSettle()`, covering data, empty, and error with retry.

### 4. Verify
`dart format lib test && flutter analyze && flutter test`

## Conventions
- Files are `snake_case.dart`, and each file holds one public class.
- Pass dependencies through constructors. Riverpod providers are the only composition root.
- Use `const` wherever possible, `final` locals, and single quotes.
- Never use `dynamic` outside JSON parsing, and cast JSON fields explicitly in `fromJson`.
- UI follows the Stitch designs and the car-context rules: touch targets ≥48dp (prefer 64dp+), high contrast,
  light theme only, minimal text.
- Theme values (colors, typography, spacing) live in one place (`core/theme/`, created when the
  Stitch design system lands). Widgets never hardcode colors.

## Avoid
- Business logic in widgets, and Dio or JSON in domain or presentation.
- Codegen (freezed, riverpod_generator) unless the CTO approves it. Keep it plain Dart.
- Global singletons and `ref.read` inside `build` (use `ref.watch`; use `ref.read` only in callbacks).
