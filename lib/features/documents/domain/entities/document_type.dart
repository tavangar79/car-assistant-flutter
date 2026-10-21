import 'document_group.dart';

/// The document types (the backend's `type` enum), in screen order. Titles and icons are the
/// client's (see `documentTypeTitle` and `documentTypeIcon`).
enum DocumentType {
  thirdPartyInsurance('third_party_insurance', DocumentGroup.insurance),
  bodyInsurance('body_insurance', DocumentGroup.insurance),
  inspection('inspection', DocumentGroup.inspection),
  vehicleCard('vehicle_card', DocumentGroup.identity),
  greenSheet('green_sheet', DocumentGroup.identity),
  powerOfAttorney('power_of_attorney', DocumentGroup.identity);

  const DocumentType(this.wire, this.group);

  /// The value on the wire.
  final String wire;

  /// The filter chip it is counted under.
  final DocumentGroup group;

  static DocumentType fromWire(String wire) => values.firstWhere((type) => type.wire == wire);
}
