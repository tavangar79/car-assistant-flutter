import 'package:equatable/equatable.dart';

/// Values the user typed on earlier visits (`GET /api/service-suggestions`), most recent first:
/// workshop names, and brands per catalog item.
class ServiceSuggestions extends Equatable {
  const ServiceSuggestions({this.workshops = const [], this.brands = const {}});

  static const empty = ServiceSuggestions();

  final List<String> workshops;
  final Map<String, List<String>> brands;

  /// The brands used before for item [itemId]; empty when none.
  List<String> brandsFor(String itemId) => brands[itemId] ?? const [];

  @override
  List<Object?> get props => [workshops, brands];
}
