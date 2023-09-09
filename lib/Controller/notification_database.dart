import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; 

class NotificationDatabase {
  static const String NotificationDB = "notification";
  Database? _database;

  Future<void> initialize(String dbname) async {
    String path = join(await getDatabasesPath(), dbname); 
    print("db part $path");
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Create your tables if they don't exist
      await db.execute('''
      CREATE TABLE IF NOT EXISTS notification  (id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT, 
            body TEXT, 
            data TEXT) 
          ''');
    });
  }

  Future<List<Map<String, dynamic>>> getData(String tableName) async {
    if (_database == null) {
      throw Exception("Database not initialized. Call initialize() first.");
    }

    return await _database!.query(tableName);
  }

  Future<void> deleteData(String tableName, int id) async {
    if (_database == null) {
      throw Exception("Database not initialized. Call initialize() first.");
    }

    await _database!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    if (_database == null) {
      return;
    }
    await _database!.close();
  }
}
