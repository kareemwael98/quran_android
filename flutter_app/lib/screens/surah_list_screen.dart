import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/surah.dart';
import '../widgets/surah_card.dart';
import 'surah_reader_screen.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openSurah(BuildContext context, Surah surah) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SurahReaderScreen(surah: surah),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingSurahs) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.surahsState == LoadingState.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 56, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Failed to load surahs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(provider.errorMessage ?? ''),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => provider.loadSurahs(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final surahs = _searchQuery.isEmpty
            ? provider.surahs
            : provider.searchSurahs(_searchQuery);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search surahs…',
                leading: const Icon(Icons.search),
                trailing: _searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      ]
                    : null,
                onChanged: (value) =>
                    setState(() => _searchQuery = value),
              ),
            ),
            Expanded(
              child: surahs.isEmpty
                  ? const Center(child: Text('No surahs found'))
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: surahs.length,
                      itemBuilder: (context, index) {
                        final surah = surahs[index];
                        return SurahCard(
                          surah: surah,
                          onTap: () => _openSurah(context, surah),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
