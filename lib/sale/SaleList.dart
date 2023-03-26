import 'package:accounting/product/Product.dart';
import 'package:accounting/sale/sale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import 'SaleEdit.dart';
import 'SaleService.dart';

class SaleList extends StatelessWidget {
  var customerId;
  var totalByCustomerId="";
  var formatter = NumberFormat('#,###,000');

  SaleList({required this.customerId});

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();

   /* saleService
        .getTotalByCustomerId(customerId)
        .then((value) => totalByCustomerId=formatter.format(int.parse(value!)));*/
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 270,
        child: Center(
          child: FutureBuilder<List<Sale>>(
            future: saleService.fetchSales(customerId!),
            builder:
                (BuildContext context, AsyncSnapshot<List<Sale>> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("مشکل دیتا بیسی"),
                );
              }
              return snapshot.data!.isEmpty
                  ? Center(
                      child: Text(
                        "دیتایی برای نمایش وجود ندارد",
                        style: TextStyle(fontFamily: "Vazir"),
                      ),
                    )
                  : ListView(
                      children: snapshot.data!.map((sale) {
                        return Center(
                          child: Card(
                            child: ListTile(
                              title: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                QuickAlert.show(
                                                    type:
                                                        QuickAlertType.confirm,
                                                    context: context,
                                                    title: "",
                                                    text:
                                                        "آیا از پاک کردن اطلاعات مطمئن هستید؟",
                                                    onConfirmBtnTap: () {
                                                      saleService.deleteSale(
                                                          sale.id.toString());
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    },
                                                    confirmBtnText: "بلی",
                                                    cancelBtnText: "خیر");
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                              )),
                                          IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SaleEdit(
                                                              sale: sale,
                                                            )));
                                              },
                                              icon: Icon(Icons.edit)),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            sale.createDate.toString(),
                                            style: TextStyle(
                                                fontFamily: "Vazir",
                                                fontSize: 14),
                                          ),
                                          Text(
                                            " تخفیف : " +
                                                (sale.discount == null
                                                        ? "0"
                                                        : formatter.format(sale.discount))
                                                    .toString() +
                                                " پرداختی : " +
                                                (sale.payment == null
                                                        ? "0"
                                                        : formatter.format(sale.payment))
                                                    .toString() +
                                                " مانده : " +
                                                (sale.total == null
                                                        ? "0"
                                                        :formatter.format(double.parse(sale.total.toString())))
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: "Vazir",
                                                fontSize: 10),
                                          ),
                                          SizedBox(
                                            height: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 50,
        width: 200,
        child: Text(totalByCustomerId),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }
}
