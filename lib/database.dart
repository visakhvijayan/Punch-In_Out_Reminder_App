import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static Database? _db;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = join(await getDatabasesPath(), 'punch_clock_app.db');
      _db = await openDatabase(_path, version: 1, onCreate: _onCreate);
    } catch (ex) {
      print(ex);
    }
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE activity (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,
          type TEXT
        )
      ''');
  }

  static Future<void> insert(String date, String type) async {
    try {
      await _db!.insert(
        'activity',
        {'date': date, 'type': type},
      );
    } catch (ex) {
      print(ex);
    }
  }

  static Future<List<Map<String, dynamic>>> queryAll() async {
    try {
      return await _db!.query('activity');
    } catch (ex) {
      print(ex);
      return [];
    }
  }
}
