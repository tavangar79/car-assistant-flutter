import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_tones.dart';
import '../../../../../core/widgets/load_error_view.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/service_item.dart';
import '../../providers/service_providers.dart';
import '../../providers/service_wizard.dart';
import 'service_item_tile.dart';
import 'service_stepper.dart';
import 'wizard_footer.dart';

/// Step 1 "انتخاب اقلام" (Stitch `60a05bbc6c0c47ae82f6ea393f737f69`): the selected count, a
/// search box and the catalog as two-column tiles per category, then the sticky continue bar.
class ServiceItemsStep extends ConsumerStatefulWidget {
  const ServiceItemsStep({super.key, required this.args, required this.onNext});

  final ServiceWizardArgs args;
  final VoidCallback onNext;

  @override
  ConsumerState<ServiceItemsStep> createState() => _ServiceItemsStepState();
}

class _ServiceItemsStepState extends ConsumerState<ServiceItemsStep> {
  final _search = TextEditingController();

  ServiceWizard get _wizard => ref.read(serviceWizardProvider(widget.args).notifier);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  /// The categories whose items match the search, without the empty ones.
  static List<ServiceCategory> filter(List<ServiceCategory> categories, String query) {
    final needle = query.trim();
    if (needle.isEmpty) return categories;
    return [
      for (final category in categories)
        if (category.items.where((item) => _matches(item, needle)).toList() case final items
            when items.isNotEmpty)
          ServiceCategory(id: category.id, title: category.title, items: items),
    ];
  }

  static bool _matches(ServiceItem item, String needle) =>
      item.title.contains(needle) || item.subtitle.contains(needle);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tones = AppTones.of(context);
    final selected = ref.watch(
      serviceWizardProvider(widget.args).select((state) => state.draft.itemIds),
    );
    final catalog = ref.watch(serviceCatalogProvider);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const ServiceStepper(current: 0),
              const SizedBox(height: 16),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tones.amber.chipBackground,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 18, color: tones.amber.foreground),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              l10n.serviceSelectedCount(selected.length),
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: tones.amber.chipForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: selected.isEmpty ? null : () => _wizard.clearItems(),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(48, 48),
                      foregroundColor: scheme.onSurfaceVariant,
                      textStyle: theme.textTheme.labelMedium,
                    ),
                    child: Text(l10n.serviceClearAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: l10n.serviceSearchHint,
                  hintStyle: TextStyle(color: scheme.outline),
                  isDense: true,
                  fillColor: scheme.surfaceContainerLowest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  prefixIcon: Icon(Icons.search, size: 20, color: scheme.outline),
                ),
              ),
              const SizedBox(height: 24),
              catalog.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: LoadErrorView(
                    message: l10n.serviceCatalogLoadError,
                    onRetry: () => ref.invalidate(serviceCatalogProvider),
                  ),
                ),
                data: (categories) {
                  final shown = filter(categories, _search.text);
                  if (shown.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        l10n.serviceSearchEmpty,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: tones.muted),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final (index, category) in shown.indexed) ...[
                        if (index > 0) const SizedBox(height: 24),
                        _CategorySection(
                          category: category,
                          selected: selected,
                          onToggle: (id) => _wizard.toggleItem(id),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        WizardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.serviceFooterLabel,
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ),
                    Text(
                      l10n.serviceFooterCount(selected.length),
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              WizardContinueButton(
                label: l10n.serviceContinueStep2,
                onPressed: selected.isEmpty ? null : widget.onNext,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A category heading (navy pill and title) and its items, two per row; a last single item
/// spans the row.
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.selected, required this.onToggle});

  final ServiceCategory category;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final items = category.items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 16,
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                category.title,
                style: theme.textTheme.headlineSmall?.copyWith(color: scheme.onSurface),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < items.length; i += 2) ...[
          if (i > 0) const SizedBox(height: 8),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: _tile(items[i])),
                if (i + 1 < items.length) ...[
                  const SizedBox(width: 8),
                  Expanded(child: _tile(items[i + 1])),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _tile(ServiceItem item) => ServiceItemTile(
    key: ValueKey(item.id),
    item: item,
    selected: selected.contains(item.id),
    onTap: () => onToggle(item.id),
  );
}
