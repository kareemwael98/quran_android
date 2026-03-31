import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../models/surah.dart';
import '../models/ayah.dart';
import '../models/juz.dart';

class QuranRepository {
  static const String _baseUrl = 'https://api.alquran.cloud/v1';

  List<Surah>? _cachedSurahs;
  List<Juz>? _cachedJuz;
  final Map<int, List<Ayah>> _surahCache = {};

  Future<List<Surah>> getSurahs() async {
    if (_cachedSurahs != null) return _cachedSurahs!;
    final jsonString = await rootBundle.loadString('assets/data/surahs.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cachedSurahs = jsonList
        .map((e) => Surah.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedSurahs!;
  }

  Future<List<Juz>> getJuz() async {
    if (_cachedJuz != null) return _cachedJuz!;
    final jsonString = await rootBundle.loadString('assets/data/juz.json');
    final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
    _cachedJuz = jsonList
        .map((e) => Juz.fromJson(e as Map<String, dynamic>))
        .toList();
    return _cachedJuz!;
  }

  Future<List<Ayah>> getSurahAyahs(int surahNumber,
      {String edition = 'quran-uthmani'}) async {
    if (_surahCache.containsKey(surahNumber)) {
      return _surahCache[surahNumber]!;
    }
    final uri = Uri.parse('$_baseUrl/surah/$surahNumber/$edition');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception(
          'Failed to load surah $surahNumber: HTTP ${response.statusCode}');
    }
    final Map<String, dynamic> body =
        json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final ayahsJson = data['ayahs'] as List<dynamic>;
    final ayahs = ayahsJson
        .map((e) =>
            Ayah.fromJson(e as Map<String, dynamic>, surahNumber: surahNumber))
        .toList();
    _surahCache[surahNumber] = ayahs;
    return ayahs;
  }

  Future<List<Ayah>> getSurahWithTranslation(int surahNumber,
      {String translationEdition = 'en.sahih'}) async {
    final results = await Future.wait([
      getSurahAyahs(surahNumber),
      _fetchTranslation(surahNumber, translationEdition),
    ]);
    final arabicAyahs = results[0];
    final translations = results[1];
    return List.generate(arabicAyahs.length, (i) {
      return arabicAyahs[i].copyWith(
        translation: i < translations.length ? translations[i] : null,
      );
    });
  }

  Future<List<String>> _fetchTranslation(
      int surahNumber, String edition) async {
    try {
      final uri = Uri.parse('$_baseUrl/surah/$surahNumber/$edition');
      final response = await http.get(uri);
      if (response.statusCode != 200) return [];
      final Map<String, dynamic> body =
          json.decode(response.body) as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>;
      final ayahsJson = data['ayahs'] as List<dynamic>;
      return ayahsJson
          .map((e) => (e as Map<String, dynamic>)['text'] as String)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Ayah>> searchAyahs(String query,
      {String edition = 'en.sahih'}) async {
    if (query.trim().isEmpty) return [];
    final encodedQuery = Uri.encodeComponent(query.trim());
    final uri = Uri.parse('$_baseUrl/search/$encodedQuery/all/$edition');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Search failed: HTTP ${response.statusCode}');
    }
    final Map<String, dynamic> body =
        json.decode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final matchesJson = data['matches'] as List<dynamic>;
    return matchesJson.map((e) {
      final map = e as Map<String, dynamic>;
      final surahInfo = map['surah'] as Map<String, dynamic>;
      return Ayah(
        number: map['number'] as int,
        numberInSurah: map['numberInSurah'] as int,
        surahNumber: surahInfo['number'] as int,
        text: map['text'] as String,
      );
    }).toList();
  }

  void clearCache() {
    _cachedSurahs = null;
    _cachedJuz = null;
    _surahCache.clear();
  }
}
