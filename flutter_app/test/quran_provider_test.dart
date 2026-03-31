import 'package:flutter_test/flutter_test.dart';
import 'package:quran_flutter/providers/quran_provider.dart';
import 'package:quran_flutter/repositories/quran_repository.dart';
import 'package:quran_flutter/models/surah.dart';
import 'package:quran_flutter/models/ayah.dart';
import 'package:quran_flutter/models/juz.dart';

class _FakeQuranRepository extends QuranRepository {
  static final List<Surah> fakeSurahs = [
    const Surah(
      number: 1,
      name: 'الفاتحة',
      englishName: 'Al-Fatihah',
      englishMeaning: 'The Opening',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    ),
    const Surah(
      number: 2,
      name: 'البقرة',
      englishName: 'Al-Baqarah',
      englishMeaning: 'The Cow',
      numberOfAyahs: 286,
      revelationType: 'Medinan',
    ),
  ];

  static final List<Juz> fakeJuz = [
    const Juz(number: 1, surahStart: 1, ayahStart: 1, surahEnd: 2, ayahEnd: 141),
  ];

  static final List<Ayah> fakeAyahs = [
    Ayah(number: 1, numberInSurah: 1, surahNumber: 1, text: 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ'),
    Ayah(number: 2, numberInSurah: 2, surahNumber: 1, text: 'ٱلۡحَمۡدُ لِلَّهِ رَبِّ ٱلۡعَٰلَمِينَ'),
  ];

  @override
  Future<List<Surah>> getSurahs() async => fakeSurahs;

  @override
  Future<List<Juz>> getJuz() async => fakeJuz;

  @override
  Future<List<Ayah>> getSurahAyahs(int surahNumber,
      {String edition = 'quran-uthmani'}) async {
    return fakeAyahs;
  }

  @override
  Future<List<Ayah>> getSurahWithTranslation(int surahNumber,
      {String translationEdition = 'en.sahih'}) async {
    return fakeAyahs
        .map((a) => a.copyWith(translation: 'Translation for ${a.numberInSurah}'))
        .toList();
  }
}

void main() {
  group('QuranProvider', () {
    late QuranProvider provider;

    setUp(() {
      provider = QuranProvider(_FakeQuranRepository());
    });

    test('initial state is idle with empty lists', () {
      expect(provider.surahs, isEmpty);
      expect(provider.juz, isEmpty);
      expect(provider.currentAyahs, isEmpty);
      expect(provider.surahsState, LoadingState.idle);
      expect(provider.isLoadingSurahs, isFalse);
    });

    test('loadSurahs populates surahs and juz', () async {
      await provider.loadSurahs();

      expect(provider.surahs, hasLength(2));
      expect(provider.juz, hasLength(1));
      expect(provider.surahsState, LoadingState.loaded);
      expect(provider.isLoadingSurahs, isFalse);
    });

    test('loadSurahs is idempotent once loaded', () async {
      await provider.loadSurahs();
      await provider.loadSurahs(); // second call should be no-op

      expect(provider.surahs, hasLength(2));
      expect(provider.surahsState, LoadingState.loaded);
    });

    test('getSurahByNumber returns correct surah', () async {
      await provider.loadSurahs();

      final surah = provider.getSurahByNumber(1);
      expect(surah, isNotNull);
      expect(surah!.englishName, 'Al-Fatihah');

      final missing = provider.getSurahByNumber(999);
      expect(missing, isNull);
    });

    test('searchSurahs filters by english name', () async {
      await provider.loadSurahs();

      final results = provider.searchSurahs('fatih');
      expect(results, hasLength(1));
      expect(results.first.number, 1);
    });

    test('searchSurahs filters by Arabic name', () async {
      await provider.loadSurahs();

      final results = provider.searchSurahs('البقرة');
      expect(results, hasLength(1));
      expect(results.first.number, 2);
    });

    test('searchSurahs with empty query returns all surahs', () async {
      await provider.loadSurahs();

      final results = provider.searchSurahs('');
      expect(results, hasLength(2));
    });

    test('loadSurahAyahs populates currentAyahs', () async {
      await provider.loadSurahAyahs(1);

      expect(provider.currentAyahs, hasLength(2));
      expect(provider.currentSurahNumber, 1);
      expect(provider.ayahsState, LoadingState.loaded);
    });

    test('loadSurahAyahs with translation adds translation', () async {
      await provider.loadSurahAyahs(1, withTranslation: true);

      expect(provider.currentAyahs.first.translation, isNotNull);
      expect(provider.currentAyahs.first.translation,
          contains('Translation'));
    });
  });
}
