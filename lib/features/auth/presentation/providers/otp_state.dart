import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';

/// What the code page shows: the typed code, the resend countdown, loading, and the last error.
class OtpState extends Equatable {
  const OtpState({
    required this.codeLength,
    this.code = '',
    this.secondsLeft = 0,
    this.isVerifying = false,
    this.isResending = false,
    this.failure,
  });

  final int codeLength;
  final String code;

  /// Seconds until a new code may be requested.
  final int secondsLeft;
  final bool isVerifying;
  final bool isResending;
  final Failure? failure;

  bool get isComplete => code.length == codeLength;

  /// The code boxes turn red after a failed attempt, until the user types again.
  bool get showsCodeError => failure != null && code.isEmpty;

  /// [failure] is kept unless a new one is given or [clearFailure] is set.
  OtpState copyWith({
    String? code,
    int? secondsLeft,
    bool? isVerifying,
    bool? isResending,
    Failure? failure,
    bool clearFailure = false,
  }) => OtpState(
    codeLength: codeLength,
    code: code ?? this.code,
    secondsLeft: secondsLeft ?? this.secondsLeft,
    isVerifying: isVerifying ?? this.isVerifying,
    isResending: isResending ?? this.isResending,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [codeLength, code, secondsLeft, isVerifying, isResending, failure];
}
