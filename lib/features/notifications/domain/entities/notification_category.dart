/// The inbox tab of a notification (the backend's derived `category`). [system] is a client tab
/// only; nothing is sent for it yet.
enum NotificationCategory {
  service('service'),
  documents('documents'),
  system('system');

  const NotificationCategory(this.wire);

  /// The value on the wire.
  final String wire;

  static NotificationCategory fromWire(String wire) =>
      values.firstWhere((category) => category.wire == wire);
}
