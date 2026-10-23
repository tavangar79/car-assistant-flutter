import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/invoice_file.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_line_draft.dart';
import '../../domain/entities/service_visit_draft.dart';
import 'service_providers.dart';

/// What opens the wizard: the vehicle and the items preselected (e.g. from the due list).
class ServiceWizardArgs extends Equatable {
  const ServiceWizardArgs(this.vehicleId, {this.preselectedItemIds = const []});

  final String vehicleId;
  final List<String> preselectedItemIds;

  @override
  List<Object?> get props => [vehicleId, preselectedItemIds];
}

/// The draft of the three steps and the picked invoice photo.
class ServiceWizardState extends Equatable {
  const ServiceWizardState({required this.draft, this.invoice});

  final ServiceVisitDraft draft;
  final InvoiceFile? invoice;

  ServiceWizardState copyWith({ServiceVisitDraft? draft, InvoiceFile? Function()? invoice}) =>
      ServiceWizardState(
        draft: draft ?? this.draft,
        invoice: invoice == null ? this.invoice : invoice(),
      );

  @override
  List<Object?> get props => [draft, invoice];
}

/// Holds the "ثبت سرویس" wizard across its three steps. One instance per visit being recorded;
/// it is dropped when the wizard page closes.
class ServiceWizard extends Notifier<ServiceWizardState> {
  ServiceWizard(this.args);

  final ServiceWizardArgs args;

  @override
  ServiceWizardState build() {
    // Once the vehicle's catalog loads, drop preselected items it disables or doesn't have.
    ref.listen(vehicleServiceCatalogProvider(args.vehicleId), (_, next) {
      if (next.value case final catalog?) _keepAvailable(catalog);
    });
    final loaded = ref.read(vehicleServiceCatalogProvider(args.vehicleId)).value;
    final ids = loaded == null
        ? args.preselectedItemIds
        : availableIds(args.preselectedItemIds, loaded);
    return ServiceWizardState(draft: ServiceVisitDraft(itemIds: ids));
  }

  /// [ids] without the items [catalog] disables or doesn't have, in their order.
  static List<String> availableIds(List<String> ids, List<ServiceCategory> catalog) => [
    for (final id in ids)
      if (findServiceItem(catalog, id) case final item? when !item.disabled) id,
  ];

  void _keepAvailable(List<ServiceCategory> catalog) {
    final ids = availableIds(_draft.itemIds, catalog);
    if (ids.length != _draft.itemIds.length) _update(_draft.copyWith(itemIds: ids));
  }

  ServiceVisitDraft get _draft => state.draft;

  void _update(ServiceVisitDraft draft) => state = state.copyWith(draft: draft);

  // Step 1

  void toggleItem(String itemId) {
    final ids = [..._draft.itemIds];
    if (!ids.remove(itemId)) ids.add(itemId);
    _update(_draft.copyWith(itemIds: ids));
  }

  void removeItem(String itemId) =>
      _update(_draft.copyWith(itemIds: [..._draft.itemIds]..remove(itemId)));

  void clearItems() => _update(_draft.copyWith(itemIds: const []));

  // Step 2

  void setOdometerKm(int? km) => _update(_draft.copyWith(odometerKm: () => km));

  /// [day] is a local date; `null` means today.
  void setServiceDay(DateTime? day) => _update(
    _draft.copyWith(serviceDay: () => day == null ? null : DateTime(day.year, day.month, day.day)),
  );

  void setVisitMinutes(int? minutes) => _update(_draft.copyWith(visitMinutes: () => minutes));

  void setStickerNextKm(int? km) => _update(_draft.copyWith(stickerNextKm: () => km));

  // Step 3

  void setWorkshop(String value) => _update(_draft.copyWith(workshop: value));

  void setInvoice(InvoiceFile? invoice) => state = state.copyWith(invoice: () => invoice);

  /// Replaces the fields of item [itemId] with [change] applied to its current draft.
  void updateLine(String itemId, ServiceLineDraft Function(ServiceLineDraft line) change) {
    final line = _draft.lines[itemId] ?? const ServiceLineDraft();
    _update(_draft.copyWith(lines: {..._draft.lines, itemId: change(line)}));
  }
}
