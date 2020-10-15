import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dao/note_dao.dart';

class DBCore {
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    final String path = join(await getDatabasesPath(), 'notes.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute(NoteDao.tableSql);
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }
}
