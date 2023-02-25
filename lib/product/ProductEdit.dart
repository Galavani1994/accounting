import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/product/ProductList.dart';
import 'package:accounting/product/ProductService.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'Product.dart';

class ProductEdit extends StatelessWidget {
  Product? product;

  ProductEdit({this.product});

  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
          context: context,
          title: "",
          text: "عملیات با موفقیت انجام شد",
          type: QuickAlertType.success);
    }

    ProductService productService = ProductService();
    TextEditingController fullNameController = TextEditingController(
        text: product?.fullName == null ? "" : "${product?.fullName}");
    TextEditingController descriptionController = TextEditingController(
        text: product?.description == null ? "" : "${product?.description}");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ثبت کالا",
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
                  hintText: 'Enter your product name',
                  labelText: 'ProductName',
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
                                builder: (context) => const ProductList()));
                      },
                      child: Text(
                        "بازگشت",
                        style: TextStyle(fontFamily: "Vazir"),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        Product pr = Product(
                            id: product?.id,
                            fullName: fullNameController.text,
                            description: descriptionController.text,
                            createDate: DateTime.now().toString(),
                            updateDate: DateTime.now().toString());
                        productService.addItem(pr);
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
