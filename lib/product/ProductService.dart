import 'package:accounting/product/Product.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class  ProductService{


  Future<Future<int>> addItem(Product item) async {
    String itemId = item.id.toString();
    int id = itemId == "null" ? 0 : int.parse(itemId);
    if (id > 0) {
      return updateProduct(id, item);
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
        fullName: maps[i]['title'] as String,
        description: maps[i]['description'] as String,
        createDate: maps[i]['create_date'] as String,
        updateDate: maps[i]['update_date'] as String,
      );
    });
  }

  Future<int> deleteProduct(String id) async {
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

  Future<int> updateProduct(int id, Product item) async {
    // returns the number of rows updated
    DatabaseHelper helper= DatabaseHelper();
    final db = await helper.init();

    int result = await db!
        .update("PRODUCT", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}