import 'package:accounting/sale/sale.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';

class SaleService {
  Future<int?> addItem(Sale item) async {
    String itemId = item.id.toString();
    int id = itemId == "null" ? 0 : int.parse(itemId);
    if (id > 0) {
      return updateSale(id, item);
    } else {
      Future<int> res;
      try{
        DatabaseHelper helper = DatabaseHelper();
        final db = await helper.init(); //open database
         res= db.insert("SALE", item.toMap(),);
      }catch(e){
        print(e.toString());
        throw Exception();
      }
      return res;
    }
  }

  Future<List<Sale>> fetchSales(int customerId) async {
    //returns the memos as a list (array)
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    final maps;
    if (customerId != null && customerId > 0) {
      maps = await db
          .query("Sale", where: "customerId=?", whereArgs: [customerId]);
    } else {
      //query all the rows in a table as an array of maps
      maps = await db.query("Sale");
    }
    List<Sale> list = List.generate(maps.length, (i) {
      //create a list of memos
      return Sale(
        id: maps[i]['id'] as int,
        description: maps[i]['description'] as String,
        createDate: maps[i]['createDate'] as String,
        updateDate: maps[i]['updateDate'] as String,
        productId: maps[i]['productId'] as int,
        customerId: maps[i]['customerId'] as int,
        price: maps[i]['price'] as int,
        quantity: maps[i]['quantity'] as double,
        total: maps[i]['total'] as String,
        discount: maps[i]['discount'] as int,
        payment: maps[i]['payment'] as int,
      );
    });
    return list;
  }

  Future<String?> getTotalByCustomerId(int customerId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = "SELECT sum(total) as total FROM SALE WHERE customerId = ?";

    var res = await db.rawQuery(query, [customerId.toString()]);
    String? result = "0";
    List.generate(res.length, (i) {
      if (res[i]["total"] != null) {
        result = (res[i]["total"] as int).toString();
      }
    });
    return result;
  }

  Future<int> deleteSale(String id) async {
    //returns number of items deleted
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    int entityId = int.parse(id);
    int result = await db.delete("SALE", //table name
        where: "id = ?",
        whereArgs: [entityId] // use whereArgs to avoid SQL injection
        );

    return result;
  }

  Future<int> updateSale(int id, Sale item) async {
    // returns the number of rows updated
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();

    int result = await db!
        .update("SALE", item.toMap(), where: "id = ?", whereArgs: [id]);
    return result;
  }
}
