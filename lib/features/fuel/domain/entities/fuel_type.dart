/// The fuel grades of the backend's `fuelType` enum, in screen order.
enum FuelType {
  regular('regular'),
  superGrade('super'),
  cng('cng'),
  lpg('lpg');

  const FuelType(this.wire);

  /// The value on the wire.
  final String wire;

  /// CNG is measured in cubic metres; the others in litres.
  bool get isCubicMetres => this == cng;

  static FuelType fromWire(String wire) => values.firstWhere((type) => type.wire == wire);
}
