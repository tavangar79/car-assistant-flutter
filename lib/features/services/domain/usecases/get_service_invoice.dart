import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../repositories/service_repository.dart';

/// The bytes of an invoice photo, for the details page and its viewer.
class GetServiceInvoice {
  const GetServiceInvoice(this._repository);

  final ServiceRepository _repository;

  Future<Either<Failure, Uint8List>> call(String invoiceUrl) =>
      _repository.fetchInvoice(invoiceUrl);
}
