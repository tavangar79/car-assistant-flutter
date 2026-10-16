# car-assistant-flutter — Car Assistant app

## Communication style
- Keep answers short and simple. Answer first, with no preamble or recap.
- Elaborate only when asked.
- Always flag risky or destructive actions in one line.

Flutter with DDD and Clean Architecture, Riverpod 3 (manual providers, no codegen), `http`, `equatable`,
and `mocktail` for tests.
Repo: https://github.com/tavangar79/car-assistant-flutter.git. It's a standalone project, used as a submodule
by the car-assistant manager repo, whose CTO sends tasks with an API contract.

## Before you start
- **Use graphify first:** `graphify query "<question>"`. If `graphify-out/` is missing, run `/graphify .`.
  After meaningful changes, refresh it with `/graphify . --update`.
- Load the `flutter-senior` skill for the full conventions and recipes.
- **Mohammad** (`mohammad` agent, `.claude/agents/mohammad.md`) owns client work.
- Tooling in this repo: the `dart` MCP server (`.mcp.json`) and the `stitch` MCP server (local scope; its API key lives in
  `~/.claude.json` and must never be committed). Use Context7 for library docs.

## Commands
| Task         | Command                                                              |
|--------------|----------------------------------------------------------------------|
| Run          | `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000` (Android emulator) |
| Analyze      | `flutter analyze`                                                    |
| Test         | `flutter test`                                                       |
| Format       | `dart format lib test`                                               |

**Definition of done:** `dart format lib test && flutter analyze && flutter test` with no issues.

## Structure (feature-first, layered)
```
lib/
  main.dart, app.dart
  core/                  cross-cutting: config, error (Failure), network
  features/<feature>/
    domain/              PURE Dart: entities, repository interfaces, use cases
    data/                DTOs (JSON), data sources (HTTP), repository implementations
    presentation/        providers (DI + state), pages, widgets
test/                    mirrors lib/
```

## Dependency rule
`presentation → domain ← data`. The **domain layer imports nothing** from Flutter, http, Riverpod,
or the data/presentation layers.

## Rules
- All steps and code must be **simple, readable and testable**. Don't add speculative abstractions.
- Entities are immutable `Equatable` classes. DTOs own `fromJson` and `toEntity()`. JSON never leaks past data/.
- Repositories convert every exception to `Failure`. `Failure.message` is a developer-facing (English) log
  message; the UI shows a localized message instead.
- **Localization:** always use `AppLocalizations` (gen-l10n, ARB files in `lib/l10n/`, locales `fa` + `en`) for
  any user-facing text, including semantics labels. Never hardcode strings. Every new string must be added to
  both `app_fa.arb` (template, with an `@key` description) and `app_en.arb`. Format numbers with `intl`
  (ARB placeholder formats or `NumberFormat(..., l10n.localeName)`), so `fa` shows Persian digits.
- Wire dependencies with Riverpod `Provider`s in `presentation/providers/`. Async UI state is a `FutureProvider`
  or `AsyncNotifier`, rendered with `.when(loading:, error:, data:)`.
- Tests: use cases use a mocktail repo, repositories use `http/testing.dart` `MockClient`, and widgets use
  `ProviderScope(overrides: [xRepositoryProvider.overrideWithValue(fake)])`.
- Keep widgets small. Extract a widget once a build method gets hard to read.

## UI design: Google Stitch
1. Design new screens in Stitch before writing UI code (`stitch-utilities:enhance-prompt` helps write prompts).
2. Keep one design system, mirrored in `DESIGN.md` (`stitch-utilities:design-md`) and `lib/core/theme/`.
3. Implement screens from the Stitch designs using the shared theme. Never hardcode colors.
4. When UI changes in code, sync it back to Stitch (`stitch-design:code-to-design`).

**Car-context UI rules:** glanceable, large touch targets (≥48dp, prefer 64dp+), high contrast,
dark mode by default, minimal text, short flows.
