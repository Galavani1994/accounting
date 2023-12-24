import 'package:accounting/customer/Customer.dart';
import 'package:accounting/customer/CustomerEdit.dart';
import 'package:accounting/sale/SaleList.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add_box_outlined,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => CustomerEdit()));
                    },
                  ),
                ],
              ),
              preferredSize: Size.fromHeight(30.0),
            ),
            title: Text(
              "لیست مشتریان",
              style: TextStyle(fontFamily: "Vazir"),
            ),
            centerTitle: true,
          ),
          body: Center(
            child: FutureBuilder<List<Customer>>(
              future: dbHelper.fetchCustomers(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Customer>> snapshot) {
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
                        children: snapshot.data!.map((customer) {
                          return GestureDetector(
                            onLongPress: () {
                              _showPopupMenu(context, customer, dbHelper);
                            },
                            child: Center(
                              child: Card(
                                child: ListTile(
                                  title: Container(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          customer.first_name,
                                          style: TextStyle(
                                              fontFamily: "Vazir", fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          customer.phoneNumber,
                                          style: TextStyle(
                                              fontFamily: "Vazir", fontSize: 14),
                                        ),
                                      ],
                                    ),
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
    );
  }

  void _showPopupMenu(
      BuildContext context, Customer customer, DatabaseHelper dbHelper) async {
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('صورتحساب'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaleList(customer)));
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('ویرایش'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomerEdit(
                                customer: customer,
                              )));
                  //Navigator.pop(context);
                },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('پاک کردن'),
                onTap: () {
                  QuickAlert.show(
                      type: QuickAlertType.confirm,
                      context: context,
                      title: "",
                      text: "آیا از پاک کردن اطلاعات مطمئن هستید؟",
                      onConfirmBtnTap: () {
                        setState(() {
                          dbHelper.deleteCustomer(customer.id.toString());
                          Navigator.of(context, rootNavigator: true).pop();
                          Navigator.pop(context);
                        });
                      },
                      confirmBtnText: "بلی",
                      cancelBtnText: "خیر");

                },
              ),
            )
          ],
        );
      },
    );
  }
}
