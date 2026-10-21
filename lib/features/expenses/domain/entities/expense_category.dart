/// The static expense categories (the backend's `category` enum), in screen order. Titles and
/// icons are the client's (see `expenseCategoryTitle` and `expenseCategoryIcon`).
enum ExpenseCategory {
  thirdPartyInsurance('third_party_insurance'),
  bodyInsurance('body_insurance'),
  fine('fine'),
  toll('toll'),
  inspection('inspection'),
  other('other');

  const ExpenseCategory(this.wire);

  /// The value on the wire.
  final String wire;

  /// Insurance and inspection expire: the form suggests `paidAt + 1 year` for them.
  bool get suggestsExpiry => switch (this) {
    thirdPartyInsurance || bodyInsurance || inspection => true,
    fine || toll || other => false,
  };

  static ExpenseCategory fromWire(String wire) =>
      values.firstWhere((category) => category.wire == wire);
}
