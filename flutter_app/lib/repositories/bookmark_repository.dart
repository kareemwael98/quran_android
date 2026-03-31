import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bookmark.dart';

class BookmarkRepository {
  static const String _dbName = 'quran_bookmarks.db';
  static const String _tableName = 'bookmarks';
  static const int _dbVersion = 1;

  final String? _dbPathOverride;
  Database? _db;

  BookmarkRepository({String? dbPathOverride}) : _dbPathOverride = dbPathOverride;

  Future<Database> get _database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final String path;
    if (_dbPathOverride != null) {
      path = _dbPathOverride!;
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, _dbName);
    }
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            surah_number INTEGER NOT NULL,
            ayah_number INTEGER NOT NULL,
            surah_name TEXT NOT NULL,
            ayah_text TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            UNIQUE(surah_number, ayah_number)
          )
        ''');
      },
    );
  }

  Future<List<Bookmark>> getAll() async {
    final db = await _database;
    final maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return maps.map(Bookmark.fromMap).toList();
  }

  Future<Bookmark> insert(Bookmark bookmark) async {
    final db = await _database;
    final id = await db.insert(
      _tableName,
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return bookmark.copyWith(id: id);
  }

  Future<void> delete(int id) async {
    final db = await _database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isBookmarked(int surahNumber, int ayahNumber) async {
    final db = await _database;
    final result = await db.query(
      _tableName,
      where: 'surah_number = ? AND ayah_number = ?',
      whereArgs: [surahNumber, ayahNumber],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  Future<void> toggleBookmark(Bookmark bookmark) async {
    final db = await _database;
    final existing = await db.query(
      _tableName,
      where: 'surah_number = ? AND ayah_number = ?',
      whereArgs: [bookmark.surahNumber, bookmark.ayahNumber],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      await db.delete(
        _tableName,
        where: 'surah_number = ? AND ayah_number = ?',
        whereArgs: [bookmark.surahNumber, bookmark.ayahNumber],
      );
    } else {
      await insert(bookmark);
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
