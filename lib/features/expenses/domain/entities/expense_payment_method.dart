/// How an expense was paid (the backend's `paymentMethod` enum), in screen order.
enum ExpensePaymentMethod {
  online('online'),
  pos('pos');

  const ExpensePaymentMethod(this.wire);

  /// The value on the wire.
  final String wire;

  static ExpensePaymentMethod fromWire(String wire) =>
      values.firstWhere((method) => method.wire == wire);
}
