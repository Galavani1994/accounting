import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'CustomeList.dart';
import 'Customer.dart';

class CustomerEdit extends StatelessWidget {
  Customer? customer;

  CustomerEdit({this.customer});

  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
          context: context,
          title: "",
          text: "عملیات با موفقیت انجام شد",
          type: QuickAlertType.success);
    }

    DatabaseHelper dbHelper = DatabaseHelper();
    TextEditingController fullNameController = TextEditingController(
        text: customer?.first_name == null ? "" : "${customer?.first_name}"+" "+"${customer?.last_name}");
    TextEditingController phoneController = TextEditingController(
        text: customer?.phone_number == null ? "" : "${customer?.phone_number}");
    TextEditingController descriptionController = TextEditingController(
        text: customer?.description == null ? "" : "${customer?.description}");
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerList()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "مشتری",
            style: TextStyle(fontFamily: "Vazir"),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'نام کامل را وارد کنید',
                        labelText: 'نام کامل',
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(Icons.phone),
                        hintText: 'شماره تماس را وارد کنید',
                        labelText: 'شماره تماس',
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(Icons.description),
                        hintText: 'توضیحات خود را وارد کنید',
                        labelText: 'توضیحات',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Customer cu = Customer(
                            id: customer?.id,
                            first_name: fullNameController.text,
                            last_name: '',
                            phone_number: phoneController.text,
                            address: '',
                            description: descriptionController.text,
                            createDate: DateTime.now().toString(),
                            updateDate: DateTime.now().toString());
                        dbHelper.addItem(cu);
                        showAlert();
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        "ثبت",
                        style: TextStyle(fontFamily: "Vazir"),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    bool result = true;
    return true;
  }
}
