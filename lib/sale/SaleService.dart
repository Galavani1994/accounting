import 'package:accounting/sale/sale.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SaleService {
  Future<int?> addItem(Sale item) async {
    String itemId = item.id.toString();
    int id = itemId == "null" ? 0 : int.parse(itemId);
    if (id > 0) {
      return updateSale(id, item);
    } else {
      Future<int> res;
      try {
        DatabaseHelper helper = DatabaseHelper();
        final db = await helper.init(); //open database
        res = db.insert("SALE", item.toMap(),);
      } catch (e) {
        Fluttertoast.showToast(msg: "Backup failed: $e");
        throw Exception();
      }
      return res;
    }
  }

  Future<List<Sale>> fetchSales(int? personId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    final maps;
    List<Sale> list = [Sale()];
    if (personId != null && personId > 0) {
      try {
        maps = await db.query("Sale",
            where: "person_id=?",
            whereArgs: [personId],
            orderBy: "id DESC");
        list = generateList(maps);
      } catch (ex) {
        print(ex.toString());
      }
    } else {
      try {
        maps = await db.query("Sale", orderBy: "create_date DESC,id DESC");
        list = generateList(maps);
      } catch (ex) {
        print(ex.toString());
      }
    }
    return list;
  }

  List<Sale> generateList(maps) => List.generate(maps.length, (i) {
        //create a list of memos
        return Sale(
          id: maps[i]['id'] as int,
          description: maps[i]['description'] as String? ?? '',
          createDate: maps[i]['create_date'] as String? ?? '',
          updateDate: maps[i]['update_date'] as String? ?? '',
          product_id: (maps[i]['product_id'] == null ? 0 : maps[i]['product_id']) as int,
          product_title: maps[i]['product_title'] as String? ?? '',
          customer_id: (maps[i]['person_id'] == null ? 0 : maps[i]['person_id']) as int,
          price: maps[i]['price'] as int,
          quantity: maps[i]['quantity'] as double,
          total: (maps[i]['total'] as Object).toString(),
          discount: maps[i]['discount'] as int,
          payment: maps[i]['payment'] as int,
          creditor: (maps[i]['creditor'] == 1),
        );
      });

  Future<int?> getDebtorTotalByPersonId(int? personId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = """
    select (sum(total)-sum(discount)-sum(payment)) as balance from SALE where person_id=? and creditor=0
    """;

    var res = await db.rawQuery(query, [personId.toString()]);
    int? result = 0;
    List.generate(res.length, (i) {
      if (res[i]["balance"] != null) {
        result = res[i]["balance"] as int;
      }
    });
    return result;
  }
  Future<int?> getCreditorTotalByPersonId(int? personId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = """
    select (sum(total)-sum(discount)-sum(payment)) as balance from SALE where person_id=? and creditor=1
    """;

    var res = await db.rawQuery(query, [personId.toString()]);
    int? result = 0;
    List.generate(res.length, (i) {
      if (res[i]["balance"] != null) {
        result = res[i]["balance"] as int;
      }
    });
    return result;
  }
  Future<int?> getDebtorTotal() async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = """ SELECT SUM(tbl2.total) AS total_amount
                                FROM (
                                    SELECT
                                        tbl.creditor_amount,
                                        tbl.debtor_amount,
                                        ABS(tbl.debtor_amount - tbl.creditor_amount) AS total
                                    FROM (
                                        SELECT
                                            SUM(CASE WHEN s.creditor = 1 THEN (s.total - s.discount - s.payment) ELSE 0 END) AS creditor_amount,
                                            SUM(CASE WHEN s.creditor = 0 THEN (s.total - s.discount - s.payment) ELSE 0 END) AS debtor_amount
                                        FROM
                                            sale s
                                        JOIN
                                            person p ON s.person_id = p.id
                                        GROUP BY
                                            s.person_id
                                    ) tbl
                                    WHERE (tbl.debtor_amount - tbl.creditor_amount) > 0
                                ) tbl2
                              """;

    var res = await db.rawQuery(query);
    int? result = 0;
    List.generate(res.length, (i) {
      if (res[i]["total_amount"] != null) {
        result = res[i]["total_amount"] as int;
      }
    });
    return result;
  }
  Future<int?> getCreditorTotal() async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = """ SELECT SUM(tbl2.total) AS total_amount
                                FROM (
                                    SELECT
                                        tbl.creditor_amount,
                                        tbl.debtor_amount,
                                        ABS(tbl.debtor_amount - tbl.creditor_amount) AS total
                                    FROM (
                                        SELECT
                                            SUM(CASE WHEN s.creditor = 1 THEN (s.total - s.discount - s.payment) ELSE 0 END) AS creditor_amount,
                                            SUM(CASE WHEN s.creditor = 0 THEN (s.total - s.discount - s.payment) ELSE 0 END) AS debtor_amount
                                        FROM
                                            sale s
                                        JOIN
                                            person p ON s.person_id = p.id
                                        GROUP BY
                                            s.person_id
                                    ) tbl
                                    WHERE (tbl.debtor_amount - tbl.creditor_amount) < 0
                                ) tbl2
                              """;

    var res = await db.rawQuery(query);
    int? result = 0;
    List.generate(res.length, (i) {
      if (res[i]["total_amount"] != null) {
        result = res[i]["total_amount"] as int;
      }
    });
    return result;
  }

  Future<String?> getCustomerFullNameById(int? personId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = "select first_name,last_name from PERSON where id=?";

    var res = await db.rawQuery(query, [personId.toString()]);
    String? result = "";
    List.generate(res.length, (i) {
      String firstName = '';
      String lastName = '';
      if (res[i]["first_name"] != null) {
        firstName = res[i]["first_name"].toString();
      }
      if (res[i]["last_name"] != null) {
        lastName = res[i]["last_name"].toString();
      }
      result = firstName + " " + lastName;
    });
    return result;
  }

  Future<String?> getProductNameById(int? productId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = "select title from PRODUCT where id=?";

    var res = await db.rawQuery(query, [productId.toString()]);
    String? result = "";
    List.generate(res.length, (i) {
      if (res[i]["title"] != null) {
        result = res[i]["title"].toString();
      }
    });
    return result;
  }

  Future<String?> getPaymentByPersonId(int? personId) async {
    DatabaseHelper helper = DatabaseHelper();
    final db = await helper.init();
    String query = "select sum(payment) as payment from sale where person_id=?";

    var res = await db.rawQuery(query, [personId.toString()]);
    String? result = "0";
    List.generate(res.length, (i) {
      if (res[i]["payment"] != null) {
        result = (res[i]["payment"] as int).toString();
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
