import 'package:flutter/foundation.dart';
import '../repositories/settings_repository.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository;

  double _arabicFontSize = SettingsRepository.defaultFontSize;
  bool _isDarkMode = false;
  String _translationEdition = SettingsRepository.defaultTranslation;
  bool _showTranslation = true;
  bool _isLoaded = false;

  SettingsProvider(this._repository);

  double get arabicFontSize => _arabicFontSize;
  bool get isDarkMode => _isDarkMode;
  String get translationEdition => _translationEdition;
  bool get showTranslation => _showTranslation;
  bool get isLoaded => _isLoaded;

  static const double minFontSize = 18.0;
  static const double maxFontSize = 48.0;

  static const List<Map<String, String>> availableTranslations = [
    {'id': 'en.sahih', 'name': 'Saheeh International (English)'},
    {'id': 'en.pickthall', 'name': 'Pickthall (English)'},
    {'id': 'en.yusufali', 'name': 'Yusuf Ali (English)'},
    {'id': 'fr.hamidullah', 'name': 'Hamidullah (French)'},
    {'id': 'de.aburida', 'name': 'Abu Rida (German)'},
    {'id': 'tr.ates', 'name': 'Suleyman Ates (Turkish)'},
    {'id': 'ur.ahmedali', 'name': 'Ahmed Ali (Urdu)'},
  ];

  Future<void> loadSettings() async {
    if (_isLoaded) return;
    _arabicFontSize = await _repository.getArabicFontSize();
    _isDarkMode = await _repository.isDarkMode();
    _translationEdition = await _repository.getTranslationEdition();
    _showTranslation = await _repository.getShowTranslation();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> setArabicFontSize(double size) async {
    final clamped = size.clamp(minFontSize, maxFontSize);
    _arabicFontSize = clamped;
    await _repository.setArabicFontSize(clamped);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _repository.setDarkMode(value);
    notifyListeners();
  }

  Future<void> setTranslationEdition(String edition) async {
    _translationEdition = edition;
    await _repository.setTranslationEdition(edition);
    notifyListeners();
  }

  Future<void> setShowTranslation(bool value) async {
    _showTranslation = value;
    await _repository.setShowTranslation(value);
    notifyListeners();
  }
}
