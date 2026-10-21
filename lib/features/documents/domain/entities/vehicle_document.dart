import 'package:equatable/equatable.dart';

import 'document_file.dart';
import 'document_type.dart';

/// A document of a vehicle in the wallet: insurance, inspection, card, green sheet or power of
/// attorney, with up to four files.
class VehicleDocument extends Equatable {
  const VehicleDocument({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.expiryReminder,
    required this.files,
    required this.createdAt,
    required this.updatedAt,
    this.title,
    this.issuer,
    this.number,
    this.issuedAt,
    this.expiresAt,
    this.notes,
  });

  final String id;
  final String vehicleId;
  final DocumentType type;

  /// Free text; the screen falls back to the type title.
  final String? title;
  final String? issuer;

  /// Policy, serial or VIN.
  final String? number;
  final DateTime? issuedAt;

  /// `null` means permanent.
  final DateTime? expiresAt;

  /// Whether reminders fire before [expiresAt].
  final bool expiryReminder;
  final String? notes;

  /// Oldest first; empty when none.
  final List<DocumentFile> files;
  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    type,
    title,
    issuer,
    number,
    issuedAt,
    expiresAt,
    expiryReminder,
    notes,
    files,
    createdAt,
    updatedAt,
  ];
}
