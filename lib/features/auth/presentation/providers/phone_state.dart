import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/phone_number.dart';

/// What the phone page shows: the typed national digits, loading, and the last error.
class PhoneState extends Equatable {
  const PhoneState({this.digits = '', this.isSubmitting = false, this.failure});

  /// National digits after +98 (e.g. `9121234567`).
  final String digits;
  final bool isSubmitting;
  final Failure? failure;

  /// The number as the API expects it to start: `09…`.
  String get phone => '0$digits';

  bool get isValid => PhoneNumber.normalize(phone) != null;

  bool get canSubmit => isValid && !isSubmitting;

  PhoneState copyWith({String? digits, bool? isSubmitting, Failure? failure}) => PhoneState(
    digits: digits ?? this.digits,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    failure: failure,
  );

  @override
  List<Object?> get props => [digits, isSubmitting, failure];
}
