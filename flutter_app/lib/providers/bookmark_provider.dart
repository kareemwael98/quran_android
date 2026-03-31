import 'package:flutter/foundation.dart';
import '../models/bookmark.dart';
import '../repositories/bookmark_repository.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkRepository _repository;

  List<Bookmark> _bookmarks = [];
  bool _isLoading = false;

  BookmarkProvider(this._repository);

  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);
  bool get isLoading => _isLoading;

  Future<void> loadBookmarks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _bookmarks = await _repository.getAll();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
    required String ayahText,
  }) async {
    final bookmark = Bookmark(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      surahName: surahName,
      ayahText: ayahText,
      createdAt: DateTime.now(),
    );
    await _repository.toggleBookmark(bookmark);
    await loadBookmarks();
  }

  Future<void> removeBookmark(int id) async {
    await _repository.delete(id);
    _bookmarks.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  bool isBookmarked(int surahNumber, int ayahNumber) {
    return _bookmarks.any(
      (b) => b.surahNumber == surahNumber && b.ayahNumber == ayahNumber,
    );
  }
}
