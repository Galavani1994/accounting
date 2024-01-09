import 'dart:io';

import 'package:accounting/customer/Customer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
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
        version: 11,
        onCreate: _onCreate);
  }

  Future<bool> backupDatabase() async {
    try {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        Directory directory = await getApplicationDocumentsDirectory();
        final path = join(directory.path, "accounting.db");
        Database database = await openDatabase(path, version: 11, onCreate: _onCreate);

        String folderName = 'acc_back';
        Directory customFolder = Directory("storage/emulated/0/$folderName");
        await customFolder.create(recursive: true);

        String backupPath = join(customFolder.path, 'backup_accounting.db');

        await File(database.path).copy(backupPath);

        // Close the database to release resources
        await database.close();

        print("Backup successful. Path: $backupPath");
        return true;
      } else {
        // Display a toast message for permission not granted
        Fluttertoast.showToast(msg: "Storage permission not granted.",timeInSecForIosWeb: 5);
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Backup failed: $e");
      print("Backup failed: $e");
      return false;
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE PERSON(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT,
    last_name TEXT,
    phoneNumber TEXT,
    address TEXT,
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
    productTitle TEXT,
    personId INTEGER,
    price INTEGER,
    quantity REAL,
    total TEXT,
    discount INTEGER,
    payment INTEGER,
    creditor INTEGER,
    FOREIGN KEY (productId) REFERENCES PRODUCT (id),
    FOREIGN KEY (personId) REFERENCES PERSON (id)
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
        "PERSON", item.toMap(), //toMap() function from MemoModel
        conflictAlgorithm: ConflictAlgorithm
            .ignore, //ignores conflicts due to duplicate entries
      );
      return res;
    }
  }

  Future<List<Customer>> fetchCustomers() async {
    //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("PERSON",
        orderBy:
            "createDate DESC"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of memos
      return Customer(
        id: maps[i]['id'] as int,
        first_name: maps[i]['first_name'] as String,
        last_name: maps[i]['last_name'] as String,
        phoneNumber: maps[i]['phoneNumber'] as String,
        address: maps[i]['address'] as String,
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
    int result = await db.delete("PERSON", //table name
        where: "id = ?",
        whereArgs: [entityId] // use whereArgs to avoid SQL injection
        );

    return result;
  }

  Future<int> updateCustomer(int id, Customer item) async {
    // returns the number of rows updated

    final db = await init();

    int result = await db
        .update("PERSON", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}
