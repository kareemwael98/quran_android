class Bookmark {
  final int? id;
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;
  final DateTime createdAt;

  const Bookmark({
    this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
    required this.createdAt,
  });

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] as int?,
      surahNumber: map['surah_number'] as int,
      ayahNumber: map['ayah_number'] as int,
      surahName: map['surah_name'] as String,
      ayahText: map['ayah_text'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'surah_number': surahNumber,
        'ayah_number': ayahNumber,
        'surah_name': surahName,
        'ayah_text': ayahText,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  Bookmark copyWith({int? id}) => Bookmark(
        id: id ?? this.id,
        surahNumber: surahNumber,
        ayahNumber: ayahNumber,
        surahName: surahName,
        ayahText: ayahText,
        createdAt: createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bookmark &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => Object.hash(surahNumber, ayahNumber);

  @override
  String toString() =>
      'Bookmark(surah=$surahNumber, ayah=$ayahNumber)';
}
