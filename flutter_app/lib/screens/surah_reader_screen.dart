import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/surah.dart';
import '../models/ayah.dart';
import '../providers/quran_provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/ayah_widget.dart';

class SurahReaderScreen extends StatefulWidget {
  final Surah surah;

  const SurahReaderScreen({super.key, required this.surah});

  @override
  State<SurahReaderScreen> createState() => _SurahReaderScreenState();
}

class _SurahReaderScreenState extends State<SurahReaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAyahs());
  }

  void _loadAyahs() {
    final settings = context.read<SettingsProvider>();
    context.read<QuranProvider>().loadSurahAyahs(
          widget.surah.number,
          withTranslation: settings.showTranslation,
          translationEdition: settings.translationEdition,
        );
  }

  Future<void> _toggleBookmark(BuildContext context, Ayah ayah) async {
    final bookmarkProvider = context.read<BookmarkProvider>();
    await bookmarkProvider.toggleBookmark(
          surahNumber: widget.surah.number,
          ayahNumber: ayah.numberInSurah,
          surahName: widget.surah.englishName,
          ayahText: ayah.text,
        );
    if (!context.mounted) return;
    final isNowBookmarked = bookmarkProvider
        .isBookmarked(widget.surah.number, ayah.numberInSurah);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowBookmarked
              ? 'Ayah ${ayah.numberInSurah} bookmarked'
              : 'Bookmark removed',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah.englishName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              widget.surah.englishMeaning,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context)
                    .appBarTheme
                    .foregroundColor
                    ?.withOpacity(0.7),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              settings.showTranslation
                  ? Icons.translate
                  : Icons.translate_outlined,
            ),
            tooltip: settings.showTranslation
                ? 'Hide translation'
                : 'Show translation',
            onPressed: () {
              settings.setShowTranslation(!settings.showTranslation);
              _loadAyahs();
            },
          ),
        ],
      ),
      body: Consumer<QuranProvider>(
        builder: (context, provider, _) {
          if (provider.isLoadingAyahs) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.ayahsState == LoadingState.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 56, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Failed to load ayahs'),
                  const SizedBox(height: 8),
                  Text(provider.errorMessage ?? ''),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _loadAyahs,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.currentAyahs.isEmpty) {
            return const SizedBox.shrink();
          }

          return Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _SurahHeader(surah: widget.surah),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final ayah = provider.currentAyahs[index];
                        final bookmarked = bookmarkProvider.isBookmarked(
                          widget.surah.number,
                          ayah.numberInSurah,
                        );
                        return AyahWidget(
                          ayah: ayah,
                          isBookmarked: bookmarked,
                          fontSize: settings.arabicFontSize,
                          showTranslation: settings.showTranslation,
                          onBookmark: () => _toggleBookmark(context, ayah),
                        );
                      },
                      childCount: provider.currentAyahs.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SurahHeader extends StatelessWidget {
  final Surah surah;

  const _SurahHeader({required this.surah});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            surah.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 8),
          Text(
            surah.englishName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.numberOfAyahs} Ayahs · ${surah.revelationType}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 14,
            ),
          ),
          if (surah.number != 9) ...[
            const SizedBox(height: 16),
            Text(
              'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 20,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ],
      ),
    );
  }
}
