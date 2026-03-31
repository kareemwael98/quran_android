import 'package:flutter/material.dart';
import '../models/surah.dart';

class SurahCard extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahCard({super.key, required this.surah, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _SurahNumber(number: surah.number, colorScheme: colorScheme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      surah.englishName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      surah.englishMeaning,
                      style: TextStyle(
                        color: colorScheme.outline,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _Chip(
                          label: '${surah.numberOfAyahs} Ayahs',
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(width: 6),
                        _Chip(
                          label: surah.revelationType,
                          colorScheme: colorScheme,
                          isMeccan: surah.isMeccan,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.name,
                style: TextStyle(
                  fontSize: 22,
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SurahNumber extends StatelessWidget {
  final int number;
  final ColorScheme colorScheme;

  const _SurahNumber({required this.number, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final ColorScheme colorScheme;
  final bool isMeccan;

  const _Chip({
    required this.label,
    required this.colorScheme,
    this.isMeccan = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isMeccan
            ? colorScheme.tertiaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: isMeccan
              ? colorScheme.onTertiaryContainer
              : colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }
}
