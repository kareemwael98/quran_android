import 'package:flutter_test/flutter_test.dart';
import 'package:quran_flutter/providers/settings_provider.dart';
import 'package:quran_flutter/repositories/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsProvider', () {
    late SettingsProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = SettingsProvider(SettingsRepository());
      await provider.loadSettings();
    });

    test('defaults are correct after loading', () {
      expect(provider.arabicFontSize, SettingsRepository.defaultFontSize);
      expect(provider.isDarkMode, isFalse);
      expect(provider.translationEdition, SettingsRepository.defaultTranslation);
      expect(provider.showTranslation, isTrue);
      expect(provider.isLoaded, isTrue);
    });

    test('setDarkMode persists change', () async {
      await provider.setDarkMode(true);
      expect(provider.isDarkMode, isTrue);
    });

    test('setArabicFontSize clamps to min/max', () async {
      await provider.setArabicFontSize(5.0);
      expect(provider.arabicFontSize, SettingsProvider.minFontSize);

      await provider.setArabicFontSize(100.0);
      expect(provider.arabicFontSize, SettingsProvider.maxFontSize);
    });

    test('setArabicFontSize sets valid value', () async {
      await provider.setArabicFontSize(32.0);
      expect(provider.arabicFontSize, 32.0);
    });

    test('setShowTranslation toggles value', () async {
      expect(provider.showTranslation, isTrue);
      await provider.setShowTranslation(false);
      expect(provider.showTranslation, isFalse);
    });

    test('setTranslationEdition updates edition', () async {
      await provider.setTranslationEdition('en.yusufali');
      expect(provider.translationEdition, 'en.yusufali');
    });

    test('availableTranslations contains at least 3 entries', () {
      expect(SettingsProvider.availableTranslations.length,
          greaterThanOrEqualTo(3));
    });

    test('loadSettings is idempotent', () async {
      await provider.setDarkMode(true);
      // Second call should not reset values
      await provider.loadSettings();
      expect(provider.isDarkMode, isTrue);
    });
  });
}
