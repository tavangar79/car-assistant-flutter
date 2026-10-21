import 'package:equatable/equatable.dart';

import 'service_item.dart';

/// A group of the service catalog, e.g. `fluids` "روغن و مایعات".
class ServiceCategory extends Equatable {
  const ServiceCategory({required this.id, required this.title, required this.items});

  final String id;
  final String title;
  final List<ServiceItem> items;

  @override
  List<Object?> get props => [id, title, items];
}

/// The item [itemId] of [categories], or `null` when the catalog has no such item.
ServiceItem? findServiceItem(List<ServiceCategory> categories, String itemId) {
  for (final category in categories) {
    for (final item in category.items) {
      if (item.id == itemId) return item;
    }
  }
  return null;
}
