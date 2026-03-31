import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/bookmark_provider.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
    _init();
  }

  Future<void> _init() async {
    final quranProvider = context.read<QuranProvider>();
    final settingsProvider = context.read<SettingsProvider>();
    final bookmarkProvider = context.read<BookmarkProvider>();
    await Future.wait([
      quranProvider.loadSurahs(),
      settingsProvider.loadSettings(),
      bookmarkProvider.loadBookmarks(),
    ]);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A5276),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'القرآن',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Quran',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'The Holy Quran',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 64),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
