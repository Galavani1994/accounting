import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

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
        text: customer?.fullName == null ? "" : "${customer?.fullName}");
    TextEditingController phoneController = TextEditingController(
        text: customer?.phoneNumber == null ? "" : "${customer?.phoneNumber}");
    TextEditingController descriptionController = TextEditingController(
        text: customer?.description == null ? "" : "${customer?.description}");
    return Padding(
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                        fullName: fullNameController.text,
                        phoneNumber: phoneController.text,
                        description: descriptionController.text,
                        createDate: DateTime.now().toString(),
                        updateDate: DateTime.now().toString());
                    dbHelper.addItem(cu);
                    showAlert();
                  },
                  child: Text(
                    "ثبت",
                    style: TextStyle(fontFamily: "Vazir"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
