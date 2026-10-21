import 'package:equatable/equatable.dart';

/// The document attached to an expense (its file, not its bytes).
class ExpenseAttachment extends Equatable {
  const ExpenseAttachment({
    required this.fileName,
    required this.contentType,
    required this.sizeBytes,
    required this.updatedAt,
  });

  final String fileName;
  final String contentType;
  final int sizeBytes;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [fileName, contentType, sizeBytes, updatedAt];
}
