import 'package:flutter/material.dart';
import '../models/ayah.dart';

class AyahWidget extends StatelessWidget {
  final Ayah ayah;
  final bool isBookmarked;
  final double fontSize;
  final bool showTranslation;
  final VoidCallback onBookmark;

  const AyahWidget({
    super.key,
    required this.ayah,
    required this.isBookmarked,
    required this.fontSize,
    required this.showTranslation,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isBookmarked
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBookmarked
              ? colorScheme.primary.withOpacity(0.4)
              : colorScheme.outlineVariant,
          width: isBookmarked ? 1.5 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AyahHeader(
            ayahNumber: ayah.numberInSurah,
            isBookmarked: isBookmarked,
            onBookmark: onBookmark,
            colorScheme: colorScheme,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              ayah.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: fontSize,
                height: 1.8,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          if (showTranslation && ayah.translation != null) ...[
            const Divider(indent: 16, endIndent: 16, height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                ayah.translation!,
                style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AyahHeader extends StatelessWidget {
  final int ayahNumber;
  final bool isBookmarked;
  final VoidCallback onBookmark;
  final ColorScheme colorScheme;

  const _AyahHeader({
    required this.ayahNumber,
    required this.isBookmarked,
    required this.onBookmark,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Ayah $ayahNumber',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: isBookmarked ? colorScheme.primary : colorScheme.outline,
            ),
            onPressed: onBookmark,
            iconSize: 20,
            tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
          ),
        ],
      ),
    );
  }
}
