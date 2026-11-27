import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Manages the local SQLite database for the application.
class DatabaseHelper {
  static const _databaseName = 'movie_discovery.db';
  static const _databaseVersion = 2;
  static const remindersTable = 'reminders';
  static const accountProfilesTable = 'account_profiles';

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $remindersTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            movie_id INTEGER NOT NULL UNIQUE,
            title TEXT NOT NULL,
            poster_path TEXT,
            release_date TEXT NOT NULL,
            scheduled_time TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $accountProfilesTable (
            user_id TEXT PRIMARY KEY NOT NULL,
            display_name TEXT NOT NULL,
            email TEXT NOT NULL,
            photo_url TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE $accountProfilesTable (
              user_id TEXT PRIMARY KEY NOT NULL,
              display_name TEXT NOT NULL,
              email TEXT NOT NULL,
              photo_url TEXT
            )
          ''');
        }
      },
    );
  }
}
