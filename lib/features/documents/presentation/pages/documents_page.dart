import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_tones.dart';
import '../../../../core/widgets/load_error_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../odometer/presentation/providers/odometer_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/document_group.dart';
import '../../domain/entities/vehicle_document.dart';
import '../providers/document_file_picker.dart';
import '../providers/document_form_args.dart';
import '../providers/document_providers.dart';
import '../widgets/document_card.dart';
import '../widgets/document_group_chips.dart';
import '../widgets/document_upload_card.dart';
import '../widgets/documents_vehicle_card.dart';
import '../widgets/open_document_file.dart';

/// "کیف مدارک خودرو" (Stitch `ef4670d3d43149de8878457fea948c23`): the vehicle with its plate and
/// the encryption note, the upload card (camera / gallery / PDF open the add form with the file),
/// the group chips and the document cards. A full page above the tabs.
class DocumentsPage extends ConsumerStatefulWidget {
  const DocumentsPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  /// `null` shows every group.
  DocumentGroup? _group;

  String get _vehicleId => widget.vehicleId;

  Future<void> _upload(DocumentFileSource source) async {
    final messenger = ScaffoldMessenger.of(context);
    final failed = AppLocalizations.of(context).expenseAttachmentPickFailed;
    try {
      final file = await ref.read(documentFilePickerProvider).pick(source);
      if (file != null && mounted) {
        context.push(AppRoutes.newDocumentPath(_vehicleId), extra: DocumentFormArgs(file: file));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(failed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final vehicle = ref.watch(vehicleProvider(_vehicleId));
    final documents = ref.watch(documentsProvider(_vehicleId));
    void retry() {
      ref.invalidate(vehicleProvider(_vehicleId));
      ref.invalidate(documentsProvider(_vehicleId));
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 1,
        scrolledUnderElevation: 1,
        shadowColor: scheme.shadow.withValues(alpha: 0.04),
        leading: IconButton(
          tooltip: l10n.back,
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back),
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.documentsTitle,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (vehicle.value case final loaded?)
              Text(
                loaded.nickname,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(color: AppTones.of(context).muted),
              ),
          ],
        ),
      ),
      body: switch ((vehicle, documents)) {
        (AsyncValue(hasError: true), _) || (_, AsyncValue(hasError: true)) => LoadErrorView(
          message: l10n.documentsLoadError,
          onRetry: retry,
        ),
        (
          AsyncValue(value: final Vehicle loaded),
          AsyncValue(value: final List<VehicleDocument> list),
        ) =>
          _body(loaded, list),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _body(Vehicle vehicle, List<VehicleDocument> documents) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider)();
    final shown = [
      for (final document in documents)
        if (_group == null || document.type.group == _group) document,
    ];
    const gap = SizedBox(height: 14);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        DocumentsVehicleCard(vehicle: vehicle, documentCount: documents.length),
        gap,
        DocumentUploadCard(onPick: _upload),
        gap,
        DocumentGroupChips(
          documents: documents,
          selected: _group,
          onSelected: (group) => setState(() => _group = group),
        ),
        gap,
        if (shown.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Text(
              documents.isEmpty ? l10n.documentsEmpty : l10n.documentsFilterEmpty,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: AppTones.of(context).muted),
            ),
          ),
        for (final document in shown) ...[
          DocumentCard(
            document: document,
            now: now,
            onOpen: () => context.push(AppRoutes.editDocumentPath(_vehicleId, document.id)),
            onViewFile: () => openDocumentFile(context, ref, document.files.first),
            onRenew: () => context.push(
              AppRoutes.newDocumentPath(_vehicleId),
              extra: DocumentFormArgs(type: document.type, issuer: document.issuer),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
