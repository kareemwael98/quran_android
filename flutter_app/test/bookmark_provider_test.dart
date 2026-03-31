import 'package:flutter_test/flutter_test.dart';
import 'package:quran_flutter/providers/bookmark_provider.dart';
import 'package:quran_flutter/repositories/bookmark_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('BookmarkProvider', () {
    late BookmarkProvider provider;
    late BookmarkRepository repository;

    setUp(() async {
      // Use in-memory database per test for isolation
      repository = BookmarkRepository(dbPathOverride: inMemoryDatabasePath);
      provider = BookmarkProvider(repository);
      await provider.loadBookmarks();
    });

    tearDown(() async {
      await repository.close();
    });

    test('initial state has empty bookmarks', () {
      expect(provider.bookmarks, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('toggleBookmark adds a bookmark', () async {
      await provider.toggleBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'بِسۡمِ ٱللَّهِ',
      );

      expect(provider.bookmarks, hasLength(1));
      expect(provider.isBookmarked(1, 1), isTrue);
    });

    test('toggleBookmark removes an existing bookmark', () async {
      await provider.toggleBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'بِسۡمِ ٱللَّهِ',
      );
      expect(provider.isBookmarked(1, 1), isTrue);

      // Toggle again to remove
      await provider.toggleBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'بِسۡمِ ٱللَّهِ',
      );

      expect(provider.bookmarks, isEmpty);
      expect(provider.isBookmarked(1, 1), isFalse);
    });

    test('removeBookmark deletes by id', () async {
      await provider.toggleBookmark(
        surahNumber: 2,
        ayahNumber: 255,
        surahName: 'Al-Baqarah',
        ayahText: 'آية الكرسي',
      );
      expect(provider.bookmarks, hasLength(1));

      final id = provider.bookmarks.first.id!;
      await provider.removeBookmark(id);

      expect(provider.bookmarks, isEmpty);
    });

    test('isBookmarked returns false for non-existent bookmark', () {
      expect(provider.isBookmarked(99, 99), isFalse);
    });

    test('multiple bookmarks are tracked correctly', () async {
      await provider.toggleBookmark(
        surahNumber: 1,
        ayahNumber: 1,
        surahName: 'Al-Fatihah',
        ayahText: 'text1',
      );
      await provider.toggleBookmark(
        surahNumber: 2,
        ayahNumber: 1,
        surahName: 'Al-Baqarah',
        ayahText: 'text2',
      );

      expect(provider.bookmarks, hasLength(2));
      expect(provider.isBookmarked(1, 1), isTrue);
      expect(provider.isBookmarked(2, 1), isTrue);
      expect(provider.isBookmarked(3, 1), isFalse);
    });
  });
}
