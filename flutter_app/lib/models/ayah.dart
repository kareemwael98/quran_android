class Ayah {
  final int number;
  final int numberInSurah;
  final int surahNumber;
  final String text;
  final String? translation;

  const Ayah({
    required this.number,
    required this.numberInSurah,
    required this.surahNumber,
    required this.text,
    this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> json, {int? surahNumber}) {
    return Ayah(
      number: json['number'] as int,
      numberInSurah: json['numberInSurah'] as int,
      surahNumber: surahNumber ?? (json['surahNumber'] as int? ?? 0),
      text: json['text'] as String,
      translation: json['translation'] as String?,
    );
  }

  Ayah copyWith({String? translation}) {
    return Ayah(
      number: number,
      numberInSurah: numberInSurah,
      surahNumber: surahNumber,
      text: text,
      translation: translation ?? this.translation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ayah && number == other.number;

  @override
  int get hashCode => number.hashCode;
}
