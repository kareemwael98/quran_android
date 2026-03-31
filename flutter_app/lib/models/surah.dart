class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishMeaning;
  final int numberOfAyahs;
  final String revelationType;

  const Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishMeaning,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishMeaning: json['englishMeaning'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishMeaning': englishMeaning,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': revelationType,
      };

  bool get isMeccan => revelationType == 'Meccan';

  @override
  String toString() => 'Surah($number: $englishName)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Surah && number == other.number;

  @override
  int get hashCode => number.hashCode;
}
