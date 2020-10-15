import 'dart:convert';

import 'package:notter/database/app_database.dart';
import 'package:notter/helpers/date_helper.dart';
import 'package:notter/models/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteDao {
  static const String tableSql = 'CREATE TABLE $_tableName(' +
      '$_id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      '$_title BLOB, ' +
      '$_content BLOB, ' +
      '$_createdIn INTEGER, ' +
      '$_updatedIn INTEGER)';

  static const String _tableName = 'notes';
  static const String _id = 'id';
  static const String _title = 'title';
  static const String _content = 'content';
  static const String _createdIn = 'createdIn';
  static const String _updatedIn = 'updatedIn';

  final DBCore dbCore = new DBCore();

  Future<int> insertNote(Note note, bool isNew) async {
    final Database db = await dbCore.database;

    return await db.insert(
        _tableName, isNew ? note.toMap(false) : note.toMap(true),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> deleteNote(Note note) async {
    if (note.id != -1) {
      final Database db = await dbCore.database;
      try {
        await db.delete(_tableName, where: "$_id = ?", whereArgs: [note.id]);
        return true;
      } catch (Error) {
        print("Error deleting ${note.id}: ${Error.toString()}");
        return false;
      }
    }
  }

  Future<List<Note>> getAllNotes() async {
    final Database db = await dbCore.database;
    var data = await db.query(_tableName, orderBy: "$_updatedIn desc");
    List<Note> notes = _toList(data);
    return notes;
  }

  List<Note> _toList(List<Map<String, dynamic>> result) {
    final List<Note> notes = List();
    for (Map<String, dynamic> row in result) {
      final Note note = _createNoteFromMap(row);
      notes.add(note);
    }
    return notes;
  }

  Note _createNoteFromMap(Map<String, dynamic> row) {
    return new Note(
      row[_id],
      utf8.decode(row[_title]),
      utf8.decode(row[_content]),
      Datehelper.dateFromepoch(row[_createdIn]),
      Datehelper.dateFromepoch(row[_updatedIn]),
    );
  }
}
