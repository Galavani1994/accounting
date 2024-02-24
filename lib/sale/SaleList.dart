import 'package:accounting/customer/Customer.dart';
import 'package:accounting/sale/Add.dart';
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
  var totalCreditorByCustomerId = "";
  var totalDebtorByCustomerId = "";
  int total = 0;
  late int creditor = 0;
  late int debtor = 0;
  var formatter = NumberFormat('#,###,000');

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();
    saleService.getDebtorTotalByPersonId(widget.customer.id).then((value) => {
          setState(() {
            debtor = value!;
          })
        });
    saleService.getCreditorTotalByPersonId(widget.customer.id).then((value) => {
          setState(() {
            creditor = value!;
          })
        });

    total = (debtor == null ? 0 : debtor) - (creditor == null ? 0 : creditor);
    if (creditor != null) {
      totalCreditorByCustomerId = formatter.format(creditor);
    } else {
      totalCreditorByCustomerId = "0";
    }
    if (debtor != null) {
      totalDebtorByCustomerId = formatter.format(debtor);
    } else {
      totalDebtorByCustomerId = "0";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('صورتحساب' +
            '  ' +
            widget.customer.first_name +
            ' ' +
            widget.customer.last_name),
        centerTitle: true,
        backgroundColor: Colors.blue,
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
                              onLongPress: (){
                                _showPopupMenu(context, sale);
                              },
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
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(sale.createDate.toString()+' - '+(sale.creditor != null && sale.creditor == true ? 'بس' : 'بد') ,
                                            style: TextStyle(fontFamily: "Vazir", fontSize: 14)),
                                          Text(
                                            " تعداد : " +
                                                (sale.quantity == null
                                                        ? "0"
                                                        : sale.quantity)
                                                    .toString() +
                                                " قیمت : " +
                                                (sale.price == null
                                                        ? "0"
                                                        : formatter
                                                            .format(sale.price))
                                                    .toString(),
                                            style: TextStyle(
                                                fontFamily: "Vazir",
                                                fontSize: 12),
                                          ),
                                          Text(
                                            " تخفیف : " +
                                                (sale.discount == null
                                                        ? "0"
                                                        : formatter.format(
                                                            sale.discount))
                                                    .toString() +
                                                " جمع : " +
                                                (sale.total == null
                                                        ? "0"
                                                        : formatter.format(
                                                            double.parse(sale
                                                                .total
                                                                .toString())))
                                                    .toString() +
                                                " پرداختی : " +
                                                (sale.payment == null
                                                        ? "0"
                                                        : formatter.format(
                                                            sale.payment))
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
        height: 70,
        width: MediaQuery.of(context).size.width,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "  مانده بستانکار : " + totalCreditorByCustomerId,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          " مانده بدهی : " + totalDebtorByCustomerId,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      "  مانده کل : " +
                          '  ' +
                          formatter.format(total.abs()) +
                          ' ' +
                          (total > 0 ? ' بدهکار ' : 'بستانکار'),
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, Sale sale) async {
    final RenderBox overlay =
    Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(10, MediaQuery.of(context).size.height),
        Offset(10, MediaQuery.of(context).size.height),
      ),
      Rect.fromLTRB(0, 0, overlay.size.width, overlay.size.height),
    );
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('ویرایش'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SaleEdit(entity: sale,),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}
