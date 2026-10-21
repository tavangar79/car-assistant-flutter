import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import 'vehicle_document.dart';

/// The saved [document]. [fileFailure] is set when the document was saved but one of its new
/// files was not (the files after it were not sent either).
class SaveDocumentResult extends Equatable {
  const SaveDocumentResult(this.document, {this.fileFailure});

  final VehicleDocument document;
  final Failure? fileFailure;

  @override
  List<Object?> get props => [document, fileFailure];
}
