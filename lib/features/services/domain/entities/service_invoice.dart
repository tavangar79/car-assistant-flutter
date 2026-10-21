import 'package:equatable/equatable.dart';

/// The invoice photo attached to a service visit (its file, not its bytes).
class ServiceInvoice extends Equatable {
  const ServiceInvoice({
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
