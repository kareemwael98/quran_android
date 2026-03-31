import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/quran_provider.dart';
import 'providers/bookmark_provider.dart';
import 'providers/settings_provider.dart';
import 'repositories/quran_repository.dart';
import 'repositories/bookmark_repository.dart';
import 'repositories/settings_repository.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const QuranApp());
}

class QuranApp extends StatelessWidget {
  const QuranApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => QuranProvider(QuranRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => BookmarkProvider(BookmarkRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(SettingsRepository()),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'Quran',
            debugShowCheckedModeBanner: false,
            themeMode:
                settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }

  ThemeData _buildLightTheme() {
    const seedColor = Color(0xFF1A5276);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      cardTheme: const CardTheme(elevation: 1),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  ThemeData _buildDarkTheme() {
    const seedColor = Color(0xFF1A5276);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      cardTheme: const CardTheme(elevation: 1),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
