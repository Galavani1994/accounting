import 'package:accounting/customer/Customer.dart';
import 'package:accounting/customer/CustomerMain.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'CustomerEdit.dart';

class CustomerList extends StatefulWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  State<CustomerList> createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  final _formKey = GlobalKey<FormState>();

  void showAlert() {}

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();
    return Scaffold(
      appBar: AppBar(
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
                                                    dbHelper.deleteCustomer(
                                                        customer.id.toString());
                                                    Navigator.of(context, rootNavigator: true).pop();
                                                  });
                                                },
                                                confirmBtnText: "بلی",
                                                cancelBtnText: "خیر"
                                              );
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
                                                          CustomerMain(
                                                            customer: customer,
                                                          )));
                                            },
                                            icon: Icon(Icons.edit)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Text(
                                          customer.fullName,
                                          style: TextStyle(
                                              fontFamily: "Vazir",
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          customer.phoneNumber,
                                          style: TextStyle(
                                              fontFamily: "Vazir",
                                              fontSize: 14),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[900],
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CustomerMain()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
