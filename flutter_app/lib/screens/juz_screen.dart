import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quran_provider.dart';
import '../models/juz.dart';
import '../models/surah.dart';
import 'surah_reader_screen.dart';

class JuzScreen extends StatelessWidget {
  const JuzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingSurahs) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.juz.isEmpty) {
          return const Center(child: Text('No juz data available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.juz.length,
          itemBuilder: (context, index) {
            final juz = provider.juz[index];
            return _JuzCard(
              juz: juz,
              provider: provider,
            );
          },
        );
      },
    );
  }
}

class _JuzCard extends StatelessWidget {
  final Juz juz;
  final QuranProvider provider;

  const _JuzCard({required this.juz, required this.provider});

  @override
  Widget build(BuildContext context) {
    final startSurah = provider.getSurahByNumber(juz.surahStart);
    final endSurah = provider.getSurahByNumber(juz.surahEnd);

    final subtitle = startSurah != null && endSurah != null
        ? startSurah.number == endSurah.number
            ? startSurah.englishName
            : '${startSurah.englishName} – ${endSurah.englishName}'
        : '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Text(
            '${juz.number}',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          'Juz ${juz.number}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (startSurah != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SurahReaderScreen(surah: startSurah),
              ),
            );
          }
        },
      ),
    );
  }
}
