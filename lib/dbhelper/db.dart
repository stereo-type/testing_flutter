import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_app_test/dbhelper/upgrade_db.dart';

class DatabaseHelper {
  static final _databaseName = "AcademCity.db";
  static final _databaseVersion = 1;

  static final TABLE_TOKEN = 'token';
  static final TABLE_USER = 'user';

  static final columnId = '_id';
  static final columnToken = 'token';
  static final columnUserid = 'userid';
  static final columnFirstname = 'firstname';
  static final columnLastname = 'lastname';
  static final columnEmail = 'email';
  static final columnPhone = 'phone';
  static final columnAvatar = 'avatar';
  static final columnDescription = 'description';

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate, onUpgrade: onUpgrade);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $TABLE_TOKEN (
            $columnId INTEGER PRIMARY KEY,
            $columnToken TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $TABLE_USER (
            $columnId INTEGER PRIMARY KEY,
            $columnFirstname TEXT NOT NULL,
            $columnLastname TEXT NOT NULL,
            $columnEmail TEXT,
            $columnPhone TEXT,
            $columnAvatar TEXT,
            $columnDescription TEXT
          )
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert_record(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> get_records(String table,
      {String where, List whereArgs, String groupBy, String orderBy}) async {
    Database db = await instance.database;
    return await db.query(table,
        where: where, whereArgs: whereArgs, groupBy: groupBy, orderBy: orderBy);
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> get_count(String table) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update_records(String table, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete_record(String table, int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> delete_datebase() async {
    print('deleting');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    _database = null;
    return await deleteDatabase(path);
  }


}
