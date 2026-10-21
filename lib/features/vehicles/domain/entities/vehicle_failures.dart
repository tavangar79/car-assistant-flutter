import '../../../../core/error/failure.dart';
import 'vehicle_field.dart';

/// The vehicle was rejected, by the client rules or by the server (HTTP 400). [fields] names the
/// invalid fields; it is empty when the server did not say which.
class InvalidVehicleFailure extends Failure {
  const InvalidVehicleFailure(this.fields, [super.message = 'Invalid vehicle']);

  final Set<VehicleField> fields;

  @override
  List<Object?> get props => [message, fields];
}

/// The same plate is already in the user's garage (HTTP 409).
class PlateTakenFailure extends Failure {
  const PlateTakenFailure([super.message = 'Plate already registered']);
}

/// The photo is empty or not a JPEG or PNG image (client check or HTTP 400 on the upload).
class InvalidVehiclePhotoFailure extends Failure {
  const InvalidVehiclePhotoFailure([super.message = 'Invalid image']);
}

/// The photo is larger than `VehiclePhoto.maxBytes` (client check or HTTP 413).
class VehiclePhotoTooLargeFailure extends Failure {
  const VehiclePhotoTooLargeFailure([super.message = 'Image too large']);
}

/// The server refused an update it understood (HTTP 422), e.g. unsetting the only default vehicle.
/// [message] is the server's explanation, shown to the user as is.
class VehicleRejectedFailure extends Failure {
  const VehicleRejectedFailure(super.message);
}
