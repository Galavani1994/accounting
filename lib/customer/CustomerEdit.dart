import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'Customer.dart';

/*class CustomerEdit extends StatefulWidget {

  Customer? customer;
  CustomerEdit({this.customer});

  @override
  State<CustomerEdit> createState() => _CustomerEditState();
}

class _CustomerEditState extends State<CustomerEdit> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  void showAlert() {
    QuickAlert.show(
        context: context,
        title: "",
        text: "عملیات با موفقیت انجام شد",
        type: QuickAlertType.success);
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ثبت مشتری",
          style: TextStyle(fontFamily: "Vazir"),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        "انصراف",
                        style: TextStyle(fontFamily: "Vazir"),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Customer cu = Customer(
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
}*/

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ثبت مشتری",
          style: TextStyle(fontFamily: "Vazir"),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
