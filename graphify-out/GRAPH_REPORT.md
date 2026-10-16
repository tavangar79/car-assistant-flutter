# Graph Report - .  (2026-10-16)

## Corpus Check
- Corpus is ~2,310 words - fits in a single context window. You may not need a graph.

## Summary
- 166 nodes · 219 edges · 10 communities
- Extraction: 96% EXTRACTED · 4% INFERRED · 0% AMBIGUOUS · INFERRED: 9 edges (avg confidence: 0.89)
- Token cost: 66,906 input · 0 output

## Community Hubs (Navigation)
- [[_COMMUNITY_Flutter Conventions & Agent|Flutter Conventions & Agent]]
- [[_COMMUNITY_App Shell & Vehicles Page|App Shell & Vehicles Page]]
- [[_COMMUNITY_Client Tests|Client Tests]]
- [[_COMMUNITY_Vehicle Domain & Repository|Vehicle Domain & Repository]]
- [[_COMMUNITY_HTTP Data Source|HTTP Data Source]]
- [[_COMMUNITY_Entities & Failure|Entities & Failure]]
- [[_COMMUNITY_Vehicle DTO|Vehicle DTO]]
- [[_COMMUNITY_App Config|App Config]]
- [[_COMMUNITY_Claude Settings|Claude Settings]]
- [[_COMMUNITY_Dart MCP Config|Dart MCP Config]]

## God Nodes (most connected - your core abstractions)
1. `CLAUDE.md (car-assistant-flutter)` - 15 edges
2. `senior-flutter-engineer agent` - 11 edges
3. `Recipe: Add a Feature (domain/data/presentation)` - 8 edges
4. `flutter-senior skill playbook` - 7 edges
5. `VehicleRepository` - 6 edges
6. `Layered Testing Strategy (mocktail, MockClient, ProviderScope overrides)` - 5 edges
7. `pubspec.yaml (car_assistant)` - 5 edges
8. `Failure` - 4 edges
9. `Definition of Done (format + analyze + test)` - 4 edges
10. `Google Stitch UI Design Workflow` - 4 edges

## Surprising Connections (you probably didn't know these)
- `flutter-senior skill playbook` --conceptually_related_to--> `Lint Rules (prefer_final_locals, prefer_single_quotes, avoid_dynamic_calls)`  [INFERRED]
  .claude/skills/flutter-senior/SKILL.md → analysis_options.yaml
- `senior-flutter-engineer agent` --references--> `dart MCP server`  [EXTRACTED]
  .claude/agents/senior-flutter-engineer.md → CLAUDE.md
- `senior-flutter-engineer agent` --references--> `Use graphify first`  [EXTRACTED]
  .claude/agents/senior-flutter-engineer.md → CLAUDE.md
- `Recipe: Add a Feature (domain/data/presentation)` --implements--> `DDD + Clean Architecture (feature-first, layered)`  [INFERRED]
  .claude/skills/flutter-senior/SKILL.md → CLAUDE.md
- `Recipe: Add a Feature (domain/data/presentation)` --references--> `Failure (error type)`  [EXTRACTED]
  .claude/skills/flutter-senior/SKILL.md → CLAUDE.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Clean Architecture layer flow (use case, DTO, providers under dependency rule)** — claude_dependency_rule, _claude_skills_flutter_senior_skill_use_case_pattern, _claude_skills_flutter_senior_skill_dto_pattern, _claude_skills_flutter_senior_skill_provider_composition_root, claude_failure [INFERRED 0.85]
- **UI design system pipeline (Stitch, DESIGN.md, core/theme, car-context rules)** — claude_google_stitch, claude_design_md, _claude_skills_flutter_senior_skill_core_theme, claude_car_context_ui_rules [INFERRED 0.85]
- **Quality gate (definition of done, strict analyzer, lint rules)** — claude_definition_of_done, analysis_options_strict_analyzer, analysis_options_lint_rules, pubspec_flutter_lints [INFERRED 0.85]

## Communities (10 total, 0 thin omitted)

### Community 0 - "Flutter Conventions & Agent"
Cohesion: 0.12
Nodes (30): senior-flutter-engineer agent, Implement Exactly the API Contract, Agent Report-Back Format (path:line, check summary), flutter-senior skill playbook, Recipe: Add a Feature (domain/data/presentation), Centralized Theme (core/theme/), DTO fromJson + toEntity, No Codegen (freezed, riverpod_generator) (+22 more)

### Community 1 - "App Shell & Vehicles Page"
Cohesion: 0.09
Nodes (22): app.dart, ConsumerWidget, ../../domain/entities/vehicle.dart, features/vehicles/presentation/pages/vehicles_page.dart, build, CarAssistantApp, build, _ErrorView (+14 more)

### Community 2 - "Client Tests"
Cohesion: 0.10
Nodes (23): MockVehicleRepository, package:car_assistant/core/error/failure.dart, package:car_assistant/features/vehicles/data/datasources/vehicle_remote_data_source.dart, package:car_assistant/features/vehicles/data/repositories/vehicle_repository_impl.dart, package:car_assistant/features/vehicles/domain/entities/vehicle.dart, package:car_assistant/features/vehicles/domain/repositories/vehicle_repository.dart, package:car_assistant/features/vehicles/domain/usecases/get_vehicles.dart, package:car_assistant/features/vehicles/presentation/pages/vehicles_page.dart (+15 more)

### Community 3 - "Vehicle Domain & Repository"
Cohesion: 0.10
Nodes (20): ../../../../core/config/app_config.dart, ../../../../core/network/http_client_provider.dart, ../../data/datasources/vehicle_remote_data_source.dart, ../../data/repositories/vehicle_repository_impl.dart, ../../domain/usecases/get_vehicles.dart, ../entities/vehicle.dart, VehicleRepositoryImpl, getVehicles (+12 more)

### Community 4 - "HTTP Data Source"
Cohesion: 0.12
Nodes (16): Client, ../../../../core/error/failure.dart, dart:convert, ../datasources/vehicle_remote_data_source.dart, ../../domain/repositories/vehicle_repository.dart, client, httpClientProvider, _baseUrl (+8 more)

### Community 5 - "Entities & Failure"
Cohesion: 0.12
Nodes (17): Equatable, Exception, Failure, message, props, toString, displayName, id (+9 more)

### Community 6 - "Vehicle DTO"
Cohesion: 0.22
Nodes (8): fromJson, id, make, mileageKm, model, toEntity, VehicleDto, year

### Community 7 - "App Config"
Cohesion: 0.40
Nodes (4): _, apiBaseUrl, AppConfig, static const

### Community 8 - "Claude Settings"
Cohesion: 0.50
Nodes (3): permissions, allow, $schema

### Community 9 - "Dart MCP Config"
Cohesion: 0.50
Nodes (3): dart, dart, mcp-server

## Knowledge Gaps
- **57 isolated node(s):** `$schema`, `allow`, `dart`, `mcp-server`, `build` (+52 more)
  These have ≤1 connection - possible missing edges or undocumented components.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Vehicle` connect `Entities & Failure` to `App Shell & Vehicles Page`?**
  _High betweenness centrality (0.086) - this node is a cross-community bridge._
- **Why does `Failure` connect `Entities & Failure` to `Client Tests`?**
  _High betweenness centrality (0.060) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Recipe: Add a Feature (domain/data/presentation)` (e.g. with `DDD + Clean Architecture (feature-first, layered)` and `Layered Testing Strategy (mocktail, MockClient, ProviderScope overrides)`) actually correct?**
  _`Recipe: Add a Feature (domain/data/presentation)` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `$schema`, `allow`, `dart` to the rest of the system?**
  _57 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Flutter Conventions & Agent` be split into smaller, more focused modules?**
  _Cohesion score 0.12473118279569892 - nodes in this community are weakly interconnected._
- **Should `App Shell & Vehicles Page` be split into smaller, more focused modules?**
  _Cohesion score 0.08923076923076922 - nodes in this community are weakly interconnected._
- **Should `Client Tests` be split into smaller, more focused modules?**
  _Cohesion score 0.09538461538461539 - nodes in this community are weakly interconnected._