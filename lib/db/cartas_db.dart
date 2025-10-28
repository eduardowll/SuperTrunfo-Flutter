import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CartasDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cartas.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {

        await db.execute('''
          CREATE TABLE card_diario(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            heroId TEXT,
            name TEXT,
            image TEXT,
            powerstats TEXT,
            date TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE colecao(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            heroId TEXT,
            name TEXT,
            image TEXT,
            powerstats TEXT
          );
        ''');

      },
    );
  }
}
