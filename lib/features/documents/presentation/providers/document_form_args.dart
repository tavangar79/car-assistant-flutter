import '../../../expenses/domain/entities/attachment_file.dart';
import '../../domain/entities/document_type.dart';

/// What the add-document form starts with: a [file] picked on the documents page, or the [type]
/// and [issuer] of an expired document being renewed.
class DocumentFormArgs {
  const DocumentFormArgs({this.type, this.issuer, this.file});

  final DocumentType? type;
  final String? issuer;
  final AttachmentFile? file;
}
