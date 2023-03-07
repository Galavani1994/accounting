import 'dart:io';

import 'package:accounting/customer/Customer.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> init() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path =
        join(directory.path, "accounting.db"); //create path to database

    return await openDatabase(
        //open the database or create a database if there isn't any
        path,
        version: 7,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE CUSTOMER(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    phoneNumber TEXT,
    description TEXT,
    createDate TEXT,
    updateDate TEXT
    )
    ''');
    await db.execute("""
    CREATE TABLE PRODUCT(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    description TEXT,
    createDate TEXT,
    updateDate TEXT
    )
    """);
    await db.execute("""
    CREATE TABLE SALE(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    description TEXT,
    createDate TEXT,
    updateDate TEXT,
    productId INTEGER,
    customerId INTEGER,
    price INTEGER,
    quantity REAL,
    total TEXT,
    discount INTEGER,
    payment INTEGER,
    FOREIGN KEY (productId) REFERENCES PRODUCT (id),
    FOREIGN KEY (customerId) REFERENCES CUSTOMER (id)
    )
    """);
  }

  Future<int> addItem(Customer item) async {
    String itemId = item.id.toString();
    int id = itemId == "null" ? 0 : int.parse(itemId);
    if (id > 0) {
      return updateCustomer(id, item);
    } else {
      //returns number of items inserted as an integer
      final db = await init(); //open database
      Future<int> res = db.insert(
        "CUSTOMER", item.toMap(), //toMap() function from MemoModel
        conflictAlgorithm: ConflictAlgorithm
            .ignore, //ignores conflicts due to duplicate entries
      );
      return res;
    }
  }

  Future<List<Customer>> fetchCustomers() async {
    //returns the memos as a list (array)

    final db = await init();
    final maps = await db
        .query("CUSTOMER"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return Customer(
        id: maps[i]['id'] as int,
        fullName: maps[i]['fullName'] as String,
        phoneNumber: maps[i]['phoneNumber'] as String,
        description: maps[i]['description'] as String,
        createDate: maps[i]['createDate'] as String,
        updateDate: maps[i]['updateDate'] as String,
      );
    });
  }

  Future<int> deleteCustomer(String id) async {
    //returns number of items deleted
    final db = await init();
    int entityId = int.parse(id);
    int result = await db.delete("CUSTOMER", //table name
        where: "id = ?",
        whereArgs: [entityId] // use whereArgs to avoid SQL injection
        );

    return result;
  }

  Future<int> updateCustomer(int id, Customer item) async {
    // returns the number of rows updated

    final db = await init();

    int result = await db
        .update("CUSTOMER", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }

/*static final instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDataqbase();

  Future<Database> _initDataqbase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'accounting.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }*/
}
