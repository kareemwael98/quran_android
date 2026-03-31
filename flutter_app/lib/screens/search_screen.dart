import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/ayah.dart';
import '../models/surah.dart';
import '../repositories/quran_repository.dart';
import 'surah_reader_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final QuranRepository _repository = QuranRepository();

  List<Ayah> _results = [];
  bool _isSearching = false;
  String? _error;
  String _lastQuery = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty || query == _lastQuery) return;
    _lastQuery = query.trim();
    setState(() {
      _isSearching = true;
      _error = null;
      _results = [];
    });
    try {
      final results = await _repository.searchAyahs(query.trim());
      if (mounted) {
        setState(() {
          _results = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: SearchBar(
            controller: _controller,
            hintText: 'Search Quran translations…',
            leading: const Icon(Icons.search),
            trailing: _controller.text.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {
                          _results = [];
                          _lastQuery = '';
                          _error = null;
                        });
                      },
                    )
                  ]
                : null,
            onSubmitted: _search,
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Search failed'),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
          ],
        ),
      );
    }

    if (_controller.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Search Quran',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter a word or phrase to search',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 56),
            const SizedBox(height: 16),
            Text('No results for "${_controller.text}"'),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final ayah = _results[index];
        return _SearchResultCard(ayah: ayah);
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final Ayah ayah;

  const _SearchResultCard({required this.ayah});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuranProvider>();
    final surah = provider.getSurahByNumber(ayah.surahNumber);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Text(
            '${ayah.surahNumber}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          surah != null
              ? '${surah.englishName} · ${ayah.numberInSurah}'
              : 'Surah ${ayah.surahNumber} · ${ayah.numberInSurah}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              ayah.text,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (surah != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurahReaderScreen(surah: surah),
              ),
            );
          }
        },
      ),
    );
  }
}
