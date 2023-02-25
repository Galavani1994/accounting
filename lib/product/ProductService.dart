import 'dart:io';

import 'package:accounting/product/Product.dart';
import 'package:accounting/util/AppConstant.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../util/db.dart';

class  ProductService{
  Future<Database> init() async {
    Directory directory =
    await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path =
    join(directory.path, AppConstant.DB_NAME); //create path to database

    return await openDatabase(
      //open the database or create a database if there isn't any
        path,
        version: 2,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE PRODUCT(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    description TEXT,
    createDate TEXT,
    updateDate TEXT
    )
    ''');
  }


  Future<Future<int>> addItem(Product item) async {
    String itemId = item.id.toString();
    int id = itemId == "null" ? 0 : int.parse(itemId);
    if (id > 0) {
      return updateCustomer(id, item);
    } else {
      //returns number of items inserted as an integer
      DatabaseHelper helper= DatabaseHelper();
      final db = await helper.init(); //open database
      Future<int> res = db.insert(
        "PRODUCT", item.toMap(), //toMap() function from MemoModel
        conflictAlgorithm: ConflictAlgorithm
            .ignore, //ignores conflicts due to duplicate entries
      );
      return res;
    }
  }

  Future<List<Product>> fetchProducts() async {
    //returns the memos as a list (array)
    DatabaseHelper helper= DatabaseHelper();
    final db = await helper.init();
    final maps = await db
        .query("PRODUCT"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return Product(
        id: maps[i]['id'] as int,
        fullName: maps[i]['fullName'] as String,
        description: maps[i]['description'] as String,
        createDate: maps[i]['createDate'] as String,
        updateDate: maps[i]['updateDate'] as String,
      );
    });
  }

  Future<int> deleteCustomer(String id) async {
    //returns number of items deleted
    DatabaseHelper helper= DatabaseHelper();
    final db = await helper.init();
    int entityId = int.parse(id);
    int result = await db.delete("PRODUCT", //table name
        where: "id = ?",
        whereArgs: [entityId] // use whereArgs to avoid SQL injection
    );

    return result;
  }

  Future<int> updateCustomer(int id, Product item) async {
    // returns the number of rows updated
    DatabaseHelper helper= DatabaseHelper();
    final db = await helper.init();

    int result = await db!
        .update("PRODUCT", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}