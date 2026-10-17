import 'package:equatable/equatable.dart';

/// An Iranian license plate: `72 ب 345 | 68`. Digits are always Latin (`0-9`).
class Plate extends Equatable {
  const Plate({
    required this.twoDigits,
    required this.letter,
    required this.threeDigits,
    required this.provinceCode,
  });

  /// The letters the backend accepts, in Stitch order (`♿` is the disabled-driver plate).
  static const letters = [
    'الف',
    'ب',
    'پ',
    'ت',
    'ث',
    'ج',
    'د',
    'س',
    'ص',
    'ط',
    'ع',
    'ف',
    'ق',
    'ک',
    'گ',
    'ل',
    'م',
    'ن',
    'و',
    'ه',
    'ی',
    'ژ',
    '♿',
  ];

  final String twoDigits;
  final String letter;
  final String threeDigits;
  final String provinceCode;

  @override
  List<Object?> get props => [twoDigits, letter, threeDigits, provinceCode];
}
