import 'package:accounting/customer/Customer.dart';
import 'package:accounting/product/Product.dart';
import 'package:accounting/sale/SaleDetail.dart';
import 'package:accounting/sale/sale.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import 'SaleEdit.dart';
import 'SaleService.dart';

class SaleList extends StatefulWidget {
  Customer customer;

  SaleList(this.customer);

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  var totalByCustomerId = "";
  var paymentByCustomerId = "";
  var formatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();

    saleService.getTotalByCustomerId(widget.customer.id).then((value) => {
          setState(() {
            totalByCustomerId = formatter.format(int.parse(value!));
          })
        });
    saleService.getPaymentByCustomerId(widget.customer.id).then((value) => {
          setState(() {
            paymentByCustomerId = formatter.format(int.parse(value!));
          })
        });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'صورتحساب' + '  ' + widget.customer.fullName),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 270,
        child: Center(
          child: FutureBuilder<List<Sale>>(
            future: saleService.fetchSales(widget.customer.id),
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
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          //this right here
                                          child: Container(
                                              height: 300,
                                              width: 300.0,
                                              child: SaleDetail(
                                                entity: sale,
                                              )),
                                        ));
                              },
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
                                          /*IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SaleEdit(
                                                              sale: sale,
                                                            )));
                                              },
                                              icon: Icon(Icons.edit)),*/
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
                                                        : formatter.format(
                                                            sale.discount))
                                                    .toString() +
                                                " پرداختی : " +
                                                (sale.payment == null
                                                        ? "0"
                                                        : formatter.format(
                                                            sale.payment))
                                                    .toString() +
                                                " مانده : " +
                                                (sale.total == null
                                                        ? "0"
                                                        : formatter.format(
                                                            double.parse(sale
                                                                .total
                                                                .toString())))
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: "Vazir",
                                                fontSize: 12),
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
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  " مانده کل  : " + totalByCustomerId,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  " پرداختی : " + paymentByCustomerId,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            )),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
