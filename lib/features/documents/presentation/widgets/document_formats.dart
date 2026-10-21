import 'package:flutter/material.dart';

import '../../../../core/theme/app_tones.dart';
import '../../../../core/theme/tone_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/document_file.dart';
import '../../domain/entities/document_status.dart';
import '../../domain/entities/document_type.dart';
import '../../domain/entities/vehicle_document.dart';

/// The screen title of a type (contract table).
String documentTypeTitle(DocumentType type, AppLocalizations l10n) => switch (type) {
  DocumentType.thirdPartyInsurance => l10n.documentTypeThirdPartyInsurance,
  DocumentType.bodyInsurance => l10n.documentTypeBodyInsurance,
  DocumentType.inspection => l10n.documentTypeInspection,
  DocumentType.vehicleCard => l10n.documentTypeVehicleCard,
  DocumentType.greenSheet => l10n.documentTypeGreenSheet,
  DocumentType.powerOfAttorney => l10n.documentTypePowerOfAttorney,
};

/// The icon of a type.
IconData documentTypeIcon(DocumentType type) => switch (type) {
  DocumentType.thirdPartyInsurance => Icons.verified_user_outlined,
  DocumentType.bodyInsurance => Icons.shield_outlined,
  DocumentType.inspection => Icons.fact_check_outlined,
  DocumentType.vehicleCard => Icons.credit_card,
  DocumentType.greenSheet => Icons.description_outlined,
  DocumentType.powerOfAttorney => Icons.history_edu,
};

/// The card title: the document's own title, else its type title.
String documentTitle(VehicleDocument document, AppLocalizations l10n) =>
    document.title ?? documentTypeTitle(document.type, l10n);

/// The status pill: "منقضی شده — ۸۵ روز گذشته", "موعد نزدیک — ۱۸ روز مانده",
/// "معتبر — ۷۴ روز مانده" (both the blue and the green state) or "دائمی / بدون انقضا".
String documentStatusLabel(DocumentStatus status, AppLocalizations l10n) => switch (status.kind) {
  DocumentStatusKind.expired => l10n.documentStatusExpired(status.days),
  DocumentStatusKind.dueSoon => l10n.documentStatusDueSoon(status.days),
  DocumentStatusKind.upcoming || DocumentStatusKind.valid => l10n.documentStatusValid(status.days),
  DocumentStatusKind.permanent => l10n.documentStatusPermanent,
};

/// The status colour: red expired, amber within 15 days, blue within 30 days or permanent, green
/// otherwise.
ToneColors documentStatusTone(DocumentStatusKind kind, AppTones tones) => switch (kind) {
  DocumentStatusKind.expired => tones.overdue,
  DocumentStatusKind.dueSoon => tones.amber,
  DocumentStatusKind.upcoming || DocumentStatusKind.permanent => tones.info,
  DocumentStatusKind.valid => tones.emerald,
};

/// The strip under the file tile: "PDF", "JPG" or "PNG" by the first file, "N تصویر" for several
/// images, `null` without files.
String? documentFileBadge(List<DocumentFile> files, AppLocalizations l10n) {
  if (files.isEmpty) return null;
  if (files.length > 1 && files.every((file) => !file.isPdf)) {
    return l10n.documentImageCount(files.length);
  }
  final first = files.first;
  if (first.isPdf) return 'PDF';
  return first.contentType == DocumentFile.pngType ? 'PNG' : 'JPG';
}

/// "بیمه ایران — شماره: ۱۲۴/۹۸۷۴۳۲", either part alone, or `null` with neither.
String? documentIssuerLine(VehicleDocument document, AppLocalizations l10n) {
  final number = document.number;
  final parts = [?document.issuer, if (number != null) l10n.documentNumber(number)];
  return parts.isEmpty ? null : parts.join(' — ');
}
