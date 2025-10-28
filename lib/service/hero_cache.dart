import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/hero.dart';

class HeroCache {
  static const String _table = 'heroes';

  static Future<Database> _openDb() async {
    final path = join(await getDatabasesPath(), 'heroes.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_table(id TEXT PRIMARY KEY, json TEXT)',
        );
      },
      version: 1,
    );
  }

  static Future<void> saveHeroes(List<HeroModel> heroes) async {
    final db = await _openDb();
    final batch = db.batch();
    for (final hero in heroes) {
      batch.insert(
        _table,
        {'id': hero.id, 'json': jsonEncode(hero.toJson())},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  static Future<List<HeroModel>> loadHeroes() async {
    final db = await _openDb();
    final maps = await db.query(_table);
    return maps.map((m) {
      final json = jsonDecode(m['json'] as String);
      return HeroModel.fromJson(json);
    }).toList();
  }
}
