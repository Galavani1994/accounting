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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'Enter your full name',
                  labelText: 'FullName',
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: const Icon(Icons.phone),
                  hintText: 'Enter a phone number',
                  labelText: 'Phone',
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  prefixIcon: const Icon(Icons.description),
                  hintText: 'Enter your description',
                  labelText: 'Description',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerList()));
                      },
                      child: Text(
                        "بازگشت",
                        style: TextStyle(fontFamily: "Vazir"),
                      )),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
