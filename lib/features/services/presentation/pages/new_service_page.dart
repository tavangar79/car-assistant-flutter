import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/service_failures.dart';
import '../providers/service_providers.dart';
import '../providers/service_wizard.dart';
import '../widgets/wizard/service_details_step.dart';
import '../widgets/wizard/service_items_step.dart';
import '../widgets/wizard/service_time_step.dart';

/// "ثبت سرویس جدید": the three-step wizard that records a workshop visit for a vehicle (Stitch
/// steps `60a05bbc…`, `8c226f9a…`, `262e7491…`). A full page above the tabs. On save it opens
/// the new visit's details.
class NewServicePage extends ConsumerStatefulWidget {
  const NewServicePage({super.key, required this.vehicleId, this.preselectedItemIds = const []});

  final String vehicleId;

  /// Items already ticked on step 1 (e.g. from the due list).
  final List<String> preselectedItemIds;

  @override
  ConsumerState<NewServicePage> createState() => _NewServicePageState();
}

class _NewServicePageState extends ConsumerState<NewServicePage> {
  int _step = 0;

  ServiceWizardArgs get _args =>
      ServiceWizardArgs(widget.vehicleId, preselectedItemIds: widget.preselectedItemIds);

  void _go(int step) => setState(() => _step = step);

  void _back() {
    if (_step > 0) {
      _go(_step - 1);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _submit(Vehicle vehicle) async {
    if (ref.read(newServiceControllerProvider).isLoading) return;
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final state = ref.read(serviceWizardProvider(_args));
    final result = await ref
        .read(newServiceControllerProvider.notifier)
        .submit(vehicle, state.draft, invoice: state.invoice);
    if (!mounted) return;
    if (result == null) {
      final failure = ref.read(newServiceControllerProvider).error;
      final message = switch (failure) {
        // Field errors are shown inline on the cards.
        InvalidServiceFailure() || ServiceRejectedFailure() => l10n.serviceSaveInvalid,
        InvoiceTooLargeFailure() => l10n.serviceInvoiceTooLarge(InvoiceFile.maxMegabytes),
        InvalidInvoiceFailure() => l10n.serviceInvoiceInvalid,
        _ => l10n.serviceSaveFailed,
      };
      messenger.showSnackBar(SnackBar(content: Text(message)));
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.invoiceFailure == null ? l10n.serviceSaved : l10n.serviceSavedInvoiceFailed,
        ),
      ),
    );
    router.go(AppRoutes.serviceDetailsPath(vehicle.id, result.visit.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final vehicle = ref.watch(vehicleProvider(widget.vehicleId));
    // Keeps the auto-disposed draft alive while the page switches between steps.
    ref.listen(serviceWizardProvider(_args), (_, _) {});
    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 64,
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          elevation: 1,
          scrolledUnderElevation: 1,
          shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.04),
          leading: IconButton(
            tooltip: l10n.back,
            onPressed: _back,
            icon: const Icon(Icons.arrow_back),
          ),
          titleSpacing: 0,
          title: Text(l10n.serviceWizardTitle, style: theme.textTheme.headlineMedium),
        ),
        body: vehicle.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => LoadErrorView(
            message: l10n.vehicleDetailsLoadError,
            onRetry: () => ref.invalidate(vehicleProvider(widget.vehicleId)),
          ),
          data: (vehicle) => switch (_step) {
            0 => ServiceItemsStep(args: _args, onNext: () => _go(1)),
            1 => ServiceTimeStep(
              args: _args,
              vehicle: vehicle,
              onNext: () => _go(2),
              onBack: () => _go(0),
            ),
            _ => ServiceDetailsStep(
              args: _args,
              vehicle: vehicle,
              onAddItem: () => _go(0),
              onSubmit: () => _submit(vehicle),
            ),
          },
        ),
      ),
    );
  }
}
