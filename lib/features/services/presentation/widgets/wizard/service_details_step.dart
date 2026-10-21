import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../auth/presentation/widgets/auth_error_text.dart';
import '../../../../auth/presentation/widgets/format_jalali_date.dart';
import '../../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../../vehicles/domain/entities/vehicle.dart';
import '../../../domain/entities/service_category.dart';
import '../../../domain/entities/service_failures.dart';
import '../../../domain/entities/service_field.dart';
import '../../../domain/entities/service_rules.dart';
import '../../../domain/entities/service_suggestions.dart';
import '../../providers/service_providers.dart';
import '../../providers/service_wizard.dart';
import 'service_line_card.dart';
import 'service_stepper.dart';
import 'service_visit_card.dart';
import 'wizard_footer.dart';

/// Step 3 "جزئیات و هزینه" (Stitch `262e74911b5b45158bec636a3f484ef4`): the summary pill, the
/// shared card (workshop and invoice), one card per selected item, the add-item button, then the
/// running total and the submit bar.
class ServiceDetailsStep extends ConsumerStatefulWidget {
  const ServiceDetailsStep({
    super.key,
    required this.args,
    required this.vehicle,
    required this.onAddItem,
    required this.onSubmit,
  });

  final ServiceWizardArgs args;
  final Vehicle vehicle;
  final VoidCallback onAddItem;
  final VoidCallback onSubmit;

  @override
  ConsumerState<ServiceDetailsStep> createState() => _ServiceDetailsStepState();
}

class _ServiceDetailsStepState extends ConsumerState<ServiceDetailsStep> {
  late final TextEditingController _workshop;

  @override
  void initState() {
    super.initState();
    _workshop = TextEditingController(
      text: ref.read(serviceWizardProvider(widget.args)).draft.workshop,
    );
  }

  @override
  void dispose() {
    _workshop.dispose();
    super.dispose();
  }

  ServiceWizard get _wizard => ref.read(serviceWizardProvider(widget.args).notifier);

  void _edited() => ref.read(newServiceControllerProvider.notifier).clearError();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final now = ref.watch(clockProvider)();
    final state = ref.watch(serviceWizardProvider(widget.args));
    final draft = state.draft;
    final catalog = ref.watch(serviceCatalogProvider).value ?? const <ServiceCategory>[];
    final suggestions = ref.watch(serviceSuggestionsProvider).value ?? ServiceSuggestions.empty;
    final items = [for (final id in draft.itemIds) ?findServiceItem(catalog, id)];
    final baseKm = draft.odometerKm ?? widget.vehicle.mileageKm;
    final baseDate = draft.serviceDate(now);
    final controller = ref.watch(newServiceControllerProvider);
    final failure = controller.isLoading ? null : controller.error;
    final invalid = failure is InvalidServiceFailure ? failure.fields : const <ServiceField>{};
    final generalError = switch (failure) {
      InvalidServiceFailure(:final fields)
          when fields.contains(ServiceField.serviceDate) ||
              fields.contains(ServiceField.odometerKm) =>
        l10n.serviceDateInFuture,
      _ => null,
    };
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              ServiceStepper(
                current: 2,
                summary: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.speed, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          l10n.serviceKmValue(baseKm),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: scheme.outlineVariant,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Icon(Icons.calendar_today, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          formatJalaliDate(baseDate, l10n),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ServiceVisitCard(
                workshopController: _workshop,
                workshopSuggestions: suggestions.workshops,
                invoice: state.invoice,
                workshopError: invalid.contains(ServiceField.workshop)
                    ? l10n.serviceWorkshopError(ServiceRules.workshopMaxLength)
                    : null,
                onWorkshopChanged: (value) {
                  _edited();
                  _wizard.setWorkshop(value);
                },
                onInvoiceChanged: (invoice) {
                  _edited();
                  _wizard.setInvoice(invoice);
                },
              ),
              for (final (index, item) in items.indexed) ...[
                const SizedBox(height: 24),
                ServiceLineCard(
                  key: ValueKey(item.id),
                  item: item,
                  index: index,
                  count: items.length,
                  line: draft.lineOf(item.id, currentKm: widget.vehicle.mileageKm),
                  baseKm: baseKm,
                  baseDate: baseDate,
                  brandSuggestions: suggestions.brandsFor(item.id),
                  lineError: invalid.contains(ServiceField.lineItems)
                      ? l10n.serviceLineItemsError
                      : null,
                  onLineChanged: (line) {
                    _edited();
                    _wizard.updateLine(item.id, (_) => line);
                  },
                  onRemove: () => _wizard.removeItem(item.id),
                ),
              ],
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: widget.onAddItem,
                style: TextButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: scheme.surfaceContainerLow,
                  foregroundColor: scheme.onSurface,
                  textStyle: theme.textTheme.labelLarge,
                ),
                icon: Icon(Icons.add_circle_outline, size: 22, color: scheme.onSurfaceVariant),
                label: Text(l10n.serviceAddAnotherItem),
              ),
            ],
          ),
        ),
        WizardFooter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (generalError case final error?) ...[
                AuthErrorText(error),
                const SizedBox(height: 8),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.serviceTotalLabel(items.length),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            l10n.serviceTotalHint,
                            style: theme.textTheme.labelSmall?.copyWith(color: scheme.secondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      NumberFormat.decimalPattern(l10n.localeName).format(draft.totalCost),
                      style: AppTextStyles.metricOdometer.copyWith(color: scheme.onSurface),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.currencyToman,
                      style: theme.textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: controller.isLoading ? null : widget.onSubmit,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  disabledBackgroundColor: scheme.primary.withValues(alpha: 0.8),
                  disabledForegroundColor: scheme.onPrimary,
                ),
                icon: controller.isLoading
                    ? SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: scheme.onPrimary),
                      )
                    : const Icon(Icons.task_alt, size: 20),
                label: Text(controller.isLoading ? l10n.serviceSaving : l10n.serviceSubmit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
