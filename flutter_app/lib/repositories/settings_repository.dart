import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static const String _keyFontSize = 'arabic_font_size';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyTranslationEdition = 'translation_edition';
  static const String _keyShowTranslation = 'show_translation';
  static const String _keyLastReadSurah = 'last_read_surah';
  static const String _keyLastReadAyah = 'last_read_ayah';

  static const double defaultFontSize = 28.0;
  static const String defaultTranslation = 'en.sahih';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<double> getArabicFontSize() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keyFontSize) ?? defaultFontSize;
  }

  Future<void> setArabicFontSize(double size) async {
    final prefs = await _preferences;
    await prefs.setDouble(_keyFontSize, size);
  }

  Future<bool> isDarkMode() async {
    final prefs = await _preferences;
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<String> getTranslationEdition() async {
    final prefs = await _preferences;
    return prefs.getString(_keyTranslationEdition) ?? defaultTranslation;
  }

  Future<void> setTranslationEdition(String edition) async {
    final prefs = await _preferences;
    await prefs.setString(_keyTranslationEdition, edition);
  }

  Future<bool> getShowTranslation() async {
    final prefs = await _preferences;
    return prefs.getBool(_keyShowTranslation) ?? true;
  }

  Future<void> setShowTranslation(bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(_keyShowTranslation, value);
  }

  Future<({int surah, int ayah})?> getLastReadPosition() async {
    final prefs = await _preferences;
    final surah = prefs.getInt(_keyLastReadSurah);
    final ayah = prefs.getInt(_keyLastReadAyah);
    if (surah == null || ayah == null) return null;
    return (surah: surah, ayah: ayah);
  }

  Future<void> setLastReadPosition(int surah, int ayah) async {
    final prefs = await _preferences;
    await prefs.setInt(_keyLastReadSurah, surah);
    await prefs.setInt(_keyLastReadAyah, ayah);
  }
}
