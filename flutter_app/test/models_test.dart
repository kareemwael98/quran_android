import 'package:flutter_test/flutter_test.dart';
import 'package:quran_flutter/models/surah.dart';
import 'package:quran_flutter/models/ayah.dart';
import 'package:quran_flutter/models/bookmark.dart';
import 'package:quran_flutter/models/juz.dart';

void main() {
  group('Surah model', () {
    test('fromJson creates a valid Surah', () {
      final json = {
        'number': 1,
        'name': 'الفاتحة',
        'englishName': 'Al-Fatihah',
        'englishMeaning': 'The Opening',
        'numberOfAyahs': 7,
        'revelationType': 'Meccan',
      };

      final surah = Surah.fromJson(json);

      expect(surah.number, 1);
      expect(surah.name, 'الفاتحة');
      expect(surah.englishName, 'Al-Fatihah');
      expect(surah.englishMeaning, 'The Opening');
      expect(surah.numberOfAyahs, 7);
      expect(surah.revelationType, 'Meccan');
      expect(surah.isMeccan, isTrue);
    });

    test('toJson round-trips correctly', () {
      const surah = Surah(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqarah',
        englishMeaning: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      );

      final json = surah.toJson();
      final restored = Surah.fromJson(json);

      expect(restored, surah);
      expect(restored.isMeccan, isFalse);
    });

    test('equality is based on surah number', () {
      const s1 = Surah(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatihah',
        englishMeaning: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      );
      const s2 = Surah(
        number: 1,
        name: 'الفاتحة',
        englishName: 'Al-Fatihah',
        englishMeaning: 'The Opening',
        numberOfAyahs: 7,
        revelationType: 'Meccan',
      );
      const s3 = Surah(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqarah',
        englishMeaning: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      );

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });

    test('isMeccan returns correct value for Medinan surah', () {
      const surah = Surah(
        number: 2,
        name: 'البقرة',
        englishName: 'Al-Baqarah',
        englishMeaning: 'The Cow',
        numberOfAyahs: 286,
        revelationType: 'Medinan',
      );
      expect(surah.isMeccan, isFalse);
    });
  });

  group('Ayah model', () {
    test('fromJson creates a valid Ayah', () {
      final json = {
        'number': 1,
        'numberInSurah': 1,
        'text': 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
      };

      final ayah = Ayah.fromJson(json, surahNumber: 1);

      expect(ayah.number, 1);
      expect(ayah.numberInSurah, 1);
      expect(ayah.surahNumber, 1);
      expect(ayah.text, 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ');
      expect(ayah.translation, isNull);
    });

    test('copyWith updates translation', () {
      final ayah = Ayah(
        number: 1,
        numberInSurah: 1,
        surahNumber: 1,
        text: 'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
      );

      final withTranslation = ayah.copyWith(
        translation: 'In the name of Allah, the Most Gracious, the Most Merciful',
      );

      expect(withTranslation.number, ayah.number);
      expect(withTranslation.translation,
          'In the name of Allah, the Most Gracious, the Most Merciful');
    });

    test('equality is based on ayah number', () {
      final a1 = Ayah(number: 1, numberInSurah: 1, surahNumber: 1, text: 'text');
      final a2 = Ayah(number: 1, numberInSurah: 1, surahNumber: 1, text: 'different');
      final a3 = Ayah(number: 2, numberInSurah: 2, surahNumber: 1, text: 'text');

      expect(a1, equals(a2));
      expect(a1, isNot(equals(a3)));
    });
  });

  group('Bookmark model', () {
    test('fromMap / toMap round-trips correctly', () {
      final now = DateTime(2024, 1, 1);
      final map = {
        'id': 1,
        'surah_number': 2,
        'ayah_number': 255,
        'surah_name': 'Al-Baqarah',
        'ayah_text': 'آية الكرسي',
        'created_at': now.millisecondsSinceEpoch,
      };

      final bookmark = Bookmark.fromMap(map);

      expect(bookmark.id, 1);
      expect(bookmark.surahNumber, 2);
      expect(bookmark.ayahNumber, 255);
      expect(bookmark.surahName, 'Al-Baqarah');
      expect(bookmark.ayahText, 'آية الكرسي');

      final restored = bookmark.toMap();
      expect(restored['surah_number'], 2);
      expect(restored['ayah_number'], 255);
    });

    test('copyWith preserves fields and updates id', () {
      final bookmark = Bookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'بِسۡمِ ٱللَّهِ',
        createdAt: DateTime(2024),
      );

      final withId = bookmark.copyWith(id: 42);

      expect(withId.id, 42);
      expect(withId.surahNumber, 1);
      expect(withId.ayahNumber, 1);
    });

    test('equality is based on surah and ayah numbers', () {
      final b1 = Bookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'text',
        createdAt: DateTime(2024),
      );
      final b2 = Bookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'text',
        createdAt: DateTime(2025),
      );
      final b3 = Bookmark(
        surahNumber: 2,
        ayahNumber: 1,
        surahName: 'Al-Baqarah',
        ayahText: 'text',
        createdAt: DateTime(2024),
      );

      expect(b1, equals(b2));
      expect(b1, isNot(equals(b3)));
    });
  });

  group('Juz model', () {
    test('fromJson creates a valid Juz', () {
      final json = {
        'number': 1,
        'surahStart': 1,
        'ayahStart': 1,
        'surahEnd': 2,
        'ayahEnd': 141,
      };

      final juz = Juz.fromJson(json);

      expect(juz.number, 1);
      expect(juz.surahStart, 1);
      expect(juz.ayahStart, 1);
      expect(juz.surahEnd, 2);
      expect(juz.ayahEnd, 141);
    });

    test('toString returns Juz N format', () {
      final juz = Juz(
        number: 1,
        surahStart: 1,
        ayahStart: 1,
        surahEnd: 2,
        ayahEnd: 141,
      );
      expect(juz.toString(), 'Juz 1');
    });

    test('equality is based on juz number', () {
      final j1 = Juz(number: 1, surahStart: 1, ayahStart: 1, surahEnd: 2, ayahEnd: 141);
      final j2 = Juz(number: 1, surahStart: 1, ayahStart: 1, surahEnd: 2, ayahEnd: 141);
      final j3 = Juz(number: 2, surahStart: 2, ayahStart: 142, surahEnd: 2, ayahEnd: 252);

      expect(j1, equals(j2));
      expect(j1, isNot(equals(j3)));
    });
  });
}
