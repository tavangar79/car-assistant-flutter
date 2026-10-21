/// How a fill-up was paid (the backend's `paymentMethod` enum), in screen order.
enum FuelPaymentMethod {
  personalFuelCard('personal_fuel_card'),
  stationFuelCard('station_fuel_card'),
  bankCard('bank_card'),
  cash('cash');

  const FuelPaymentMethod(this.wire);

  /// The value on the wire.
  final String wire;

  static FuelPaymentMethod fromWire(String wire) =>
      values.firstWhere((method) => method.wire == wire);
}
