# Quran Flutter App

A Flutter mobile application that replicates the core features of the [Quran for Android](https://github.com/quran/quran_android) app.

## Features

- 📖 **Surah List** — Browse all 114 Surahs with Arabic names, English names, meanings, verse counts, and revelation type
- 📜 **Surah Reader** — Read Arabic text of any Surah fetched from the [AlQuran Cloud API](https://api.alquran.cloud)
- 🌐 **Translation** — Side-by-side English translation (Saheeh International default; 7 translations available)
- 🗂️ **Juz Browser** — Navigate the Quran by its 30 Juz (para)
- 🔖 **Bookmarks** — Bookmark individual Ayahs; stored locally via SQLite
- 🔍 **Search** — Full-text search across Quran translations via the AlQuran Cloud API
- ⚙️ **Settings** — Adjustable Arabic font size, dark/light mode, translation selection

## Architecture

```
flutter_app/
├── lib/
│   ├── main.dart              # App entry point & theme setup
│   ├── models/                # Data models (Surah, Ayah, Bookmark, Juz)
│   ├── repositories/          # Data layer (API, SQLite, SharedPreferences)
│   ├── providers/             # State management (Provider pattern)
│   ├── screens/               # UI screens
│   └── widgets/               # Reusable widgets
├── assets/data/               # Bundled JSON (surah metadata, juz boundaries)
├── test/                      # Unit tests
├── android/                   # Android platform files
└── ios/                       # iOS platform files
```

**State Management:** Provider  
**Local Storage:** sqflite (bookmarks), SharedPreferences (settings)  
**Networking:** http package → [api.alquran.cloud](https://api.alquran.cloud)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.10
- Android Studio / Xcode

### Run

```bash
cd flutter_app
flutter pub get
flutter run
```

### Test

```bash
cd flutter_app
flutter test
```

### Build

```bash
# Android APK
flutter build apk --release

# iOS (macOS only)
flutter build ios --release
```

## Data Sources

- **Surah metadata** — bundled in `assets/data/surahs.json` (114 entries)
- **Juz boundaries** — bundled in `assets/data/juz.json` (30 entries)
- **Ayah text & translations** — fetched from [AlQuran Cloud API](https://api.alquran.cloud/v1/) (free, no key required)

## Screens

| Screen | Description |
|--------|-------------|
| Splash | Loads assets and navigates to Home |
| Home | Bottom-nav container (Surahs / Juz / Bookmarks / Search) |
| Surah List | Searchable list of all 114 surahs |
| Surah Reader | Arabic text with optional translation; bookmark individual ayahs |
| Juz | List of 30 Juz with surah range |
| Bookmarks | Swipe-to-delete saved ayahs; tap to navigate to surah |
| Search | Full-text search via API |
| Settings | Font size slider, dark mode toggle, translation selector |
