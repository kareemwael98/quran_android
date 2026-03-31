import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmark_provider.dart';
import '../providers/quran_provider.dart';
import '../models/bookmark.dart';
import 'surah_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.bookmarks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No bookmarks yet',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Long-press any ayah to bookmark it',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: provider.bookmarks.length,
          itemBuilder: (context, index) {
            final bookmark = provider.bookmarks[index];
            return _BookmarkCard(bookmark: bookmark);
          },
        );
      },
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final Bookmark bookmark;

  const _BookmarkCard({required this.bookmark});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(bookmark.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        if (bookmark.id != null) {
          context.read<BookmarkProvider>().removeBookmark(bookmark.id!);
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor:
                Theme.of(context).colorScheme.secondaryContainer,
            child: Text(
              '${bookmark.surahNumber}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            '${bookmark.surahName} · Ayah ${bookmark.ayahNumber}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            bookmark.ayahText,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textDirection: TextDirection.rtl,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            final provider = context.read<QuranProvider>();
            final surah =
                provider.getSurahByNumber(bookmark.surahNumber);
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
      ),
    );
  }
}
