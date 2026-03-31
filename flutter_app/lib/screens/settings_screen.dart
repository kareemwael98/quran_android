import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            children: [
              const _SectionHeader(title: 'Display'),
              SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: settings.isDarkMode,
                onChanged: settings.setDarkMode,
              ),
              SwitchListTile(
                title: const Text('Show Translation'),
                subtitle: const Text('Display English translation'),
                secondary: const Icon(Icons.translate_outlined),
                value: settings.showTranslation,
                onChanged: settings.setShowTranslation,
              ),
              const Divider(),
              const _SectionHeader(title: 'Arabic Text'),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Font Size'),
                subtitle: Text(
                  '${settings.arabicFontSize.toStringAsFixed(0)}pt',
                ),
                trailing: SizedBox(
                  width: 180,
                  child: Slider(
                    min: SettingsProvider.minFontSize,
                    max: SettingsProvider.maxFontSize,
                    value: settings.arabicFontSize,
                    divisions: 12,
                    label:
                        settings.arabicFontSize.toStringAsFixed(0),
                    onChanged: settings.setArabicFontSize,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: settings.arabicFontSize,
                    height: 1.8,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const _SectionHeader(title: 'Translation'),
              ...SettingsProvider.availableTranslations.map(
                (t) => RadioListTile<String>(
                  title: Text(t['name']!),
                  value: t['id']!,
                  groupValue: settings.translationEdition,
                  onChanged: (v) {
                    if (v != null) settings.setTranslationEdition(v);
                  },
                ),
              ),
              const Divider(),
              const _SectionHeader(title: 'About'),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Quran Flutter'),
                subtitle: const Text('Version 1.0.0'),
              ),
              ListTile(
                leading: const Icon(Icons.code),
                title: const Text('Open Source'),
                subtitle: const Text(
                  'Based on the Quran for Android project (GPL-3.0)',
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
