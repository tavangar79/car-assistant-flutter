import '../../domain/entities/plate.dart';

/// JSON shape of a plate: `{ "twoDigits", "letter", "threeDigits", "provinceCode" }`.
class PlateDto {
  const PlateDto({
    required this.twoDigits,
    required this.letter,
    required this.threeDigits,
    required this.provinceCode,
  });

  factory PlateDto.fromJson(Map<String, dynamic> json) => PlateDto(
    twoDigits: json['twoDigits'] as String,
    letter: json['letter'] as String,
    threeDigits: json['threeDigits'] as String,
    provinceCode: json['provinceCode'] as String,
  );

  factory PlateDto.fromEntity(Plate plate) => PlateDto(
    twoDigits: plate.twoDigits,
    letter: plate.letter,
    threeDigits: plate.threeDigits,
    provinceCode: plate.provinceCode,
  );

  final String twoDigits;
  final String letter;
  final String threeDigits;
  final String provinceCode;

  Map<String, dynamic> toJson() => {
    'twoDigits': twoDigits,
    'letter': letter,
    'threeDigits': threeDigits,
    'provinceCode': provinceCode,
  };

  Plate toEntity() => Plate(
    twoDigits: twoDigits,
    letter: letter,
    threeDigits: threeDigits,
    provinceCode: provinceCode,
  );
}
