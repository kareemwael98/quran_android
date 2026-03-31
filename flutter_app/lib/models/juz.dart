class Juz {
  final int number;
  final int surahStart;
  final int ayahStart;
  final int surahEnd;
  final int ayahEnd;

  const Juz({
    required this.number,
    required this.surahStart,
    required this.ayahStart,
    required this.surahEnd,
    required this.ayahEnd,
  });

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      number: json['number'] as int,
      surahStart: json['surahStart'] as int,
      ayahStart: json['ayahStart'] as int,
      surahEnd: json['surahEnd'] as int,
      ayahEnd: json['ayahEnd'] as int,
    );
  }

  @override
  String toString() => 'Juz $number';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Juz && number == other.number;

  @override
  int get hashCode => number.hashCode;
}
