import 'package:flutter/foundation.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../models/juz.dart';
import '../repositories/quran_repository.dart';

enum LoadingState { idle, loading, loaded, error }

class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository;

  List<Surah> _surahs = [];
  List<Juz> _juz = [];
  List<Ayah> _currentAyahs = [];
  int? _currentSurahNumber;
  LoadingState _surahsState = LoadingState.idle;
  LoadingState _ayahsState = LoadingState.idle;
  String? _errorMessage;

  QuranProvider(this._repository);

  List<Surah> get surahs => List.unmodifiable(_surahs);
  List<Juz> get juz => List.unmodifiable(_juz);
  List<Ayah> get currentAyahs => List.unmodifiable(_currentAyahs);
  int? get currentSurahNumber => _currentSurahNumber;
  LoadingState get surahsState => _surahsState;
  LoadingState get ayahsState => _ayahsState;
  String? get errorMessage => _errorMessage;
  bool get isLoadingSurahs => _surahsState == LoadingState.loading;
  bool get isLoadingAyahs => _ayahsState == LoadingState.loading;

  Future<void> loadSurahs() async {
    if (_surahsState == LoadingState.loaded) return;
    _surahsState = LoadingState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _surahs = await _repository.getSurahs();
      _juz = await _repository.getJuz();
      _surahsState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _surahsState = LoadingState.error;
    }
    notifyListeners();
  }

  Future<void> loadSurahAyahs(int surahNumber,
      {bool withTranslation = false,
      String translationEdition = 'en.sahih'}) async {
    _currentSurahNumber = surahNumber;
    _ayahsState = LoadingState.loading;
    _currentAyahs = [];
    notifyListeners();
    try {
      if (withTranslation) {
        _currentAyahs = await _repository.getSurahWithTranslation(
          surahNumber,
          translationEdition: translationEdition,
        );
      } else {
        _currentAyahs = await _repository.getSurahAyahs(surahNumber);
      }
      _ayahsState = LoadingState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _ayahsState = LoadingState.error;
    }
    notifyListeners();
  }

  Surah? getSurahByNumber(int number) {
    try {
      return _surahs.firstWhere((s) => s.number == number);
    } catch (_) {
      return null;
    }
  }

  List<Surah> searchSurahs(String query) {
    if (query.trim().isEmpty) return _surahs;
    final q = query.toLowerCase();
    return _surahs
        .where((s) =>
            s.englishName.toLowerCase().contains(q) ||
            s.name.contains(q) ||
            s.englishMeaning.toLowerCase().contains(q))
        .toList();
  }
}
