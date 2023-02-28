import 'package:accounting/product/Product.dart';
import 'package:accounting/sale/sale.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'SaleEdit.dart';
import 'SaleService.dart';

class SaleList extends StatefulWidget {
  const SaleList({Key? key}) : super(key: key);

  @override
  State<SaleList> createState() => _SaleListState();
}

class _SaleListState extends State<SaleList> {
  final _formKey = GlobalKey<FormState>();
  double height=300.0;

  void showAlert() {}

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Sale>>(
          future: saleService.fetchSales(),
          builder: (BuildContext context, AsyncSnapshot<List<Sale>> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(""),
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
                                                  type: QuickAlertType.confirm,
                                                  context: context,
                                                  title: "",
                                                  text:
                                                      "آیا از پاک کردن اطلاعات مطمئن هستید؟",
                                                  onConfirmBtnTap: () {
                                                    setState(() {
                                                      saleService.deleteSale(
                                                          sale.id.toString());
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                    });
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
                                  /*Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          sale.customerName,
                                          style: TextStyle(
                                              fontFamily: "Vazir",
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          sale?.productId,
                                          style: TextStyle(
                                              fontFamily: "Vazir",
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),*/
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[900],
        onPressed: () {
          /*Navigator.push(
              context, MaterialPageRoute(builder: (context) => SaleEdit()));*/
          height=(MediaQuery.of(context).size.height-50) as double;
          showDialog(context: context, builder: (BuildContext context)=> errorDialog);
        },
        child: Icon(Icons.add),
      ),
    );


  }
  Dialog errorDialog = Dialog(

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
    child: Container(
        height: 500,
        width: 400.0,
        child: SaleEdit()
    ),
  );


}
