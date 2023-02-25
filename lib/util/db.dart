import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DB  {

  static final DB _db = new DB._internal();
  DB._internal();
  static DB get instance => _db;
  static late Database _database;

  Future<Database> get database async {
    if(_database != null)
      return _database;
    _database = await _init();
    return _database;

  }

  Future<Database> _init() async{
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, "accounting.db");
    return await openDatabase(

      path,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE CUSTOMER(id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, phoneNumber Text, description TEXT, createDate TEXT, updateDate TEXT);",
        );
        db.execute(
          "CREATE TABLE PRODUCT(id INTEGER PRIMARY KEY AUTOINCREMENT, fullName TEXT, description TEXT, createDate TEXT, updateDate TEXT);",
        );
        // more create statements....

      },

      version: 3,
    );
  }
}