import 'package:cool_todo/models/task.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  static late Database _db;
  static const int dbVersion = 1;
  static const String dbName = "tasks";

  static const String createSQL = "CREATE TABLE $dbName("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "title STRING,note TEXT,date STRING,"
      "startTime STRING,endTime String,remind INTEGER,"
      "repeat STRING,color INTEGER,isCompleted INTEGER, isDeserted INTEGER);";

  static Future<void> initDB() async {
    try {
      String path = "${await getDatabasesPath()}$dbName.db";
      _db = await openDatabase(
        path,
        version: dbVersion,
        onCreate: (db, version) => db.execute(createSQL),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<void> dropTable() async {
    await _db.execute("DROP TABLE IF EXISTS $dbName");
  }

  static Future<void> clearTable() async {
    await _db.delete(dbName);
  }

  static Future<List<Map<String, dynamic>>> selectTasks() async =>
      await _db.query(dbName);

  static Future<List<Map<String, dynamic>>> selectTasksByDate(
          {required String date}) async =>
      await _db.query(dbName, where: "date=?", whereArgs: [date]);

  static Future<Map<String, dynamic>> selectTaskByID({required int id}) async {
    List<Map<String, dynamic>> tasks =
        await _db.query(dbName, where: "id=?", whereArgs: [id]);
    return tasks[0];
  }

  static Future<int> insertTask({required Task task}) async =>
      _db.insert(dbName, task.toMap());

  static Future<void> deleteTask({required Task task}) async {
    await _db.delete(dbName, where: "id=?", whereArgs: [task.id]);
  }

  static Future<void> setCompleted({required Task task}) async {
    task.setCompleted();
    await _db.update(dbName, task.toMap(), where: "id=?", whereArgs: [task.id]);
  }

  static Future<void> setDeserted({required Task task}) async {
    task.setDeserted();
    await _db.update(dbName, task.toMap(), where: "id=?", whereArgs: [task.id]);
  }
}
