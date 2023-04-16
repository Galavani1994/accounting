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
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProductList()));
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "محصول",
              style: TextStyle(fontFamily: "Vazir"),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: fullNameController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(Icons.person),
                        hintText: 'عنوان محصول خود را وارد کنید',
                        labelText: 'نام محصول',
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: descriptionController,
                      textDirection: TextDirection.rtl,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.description),
                        hintText: 'شرح محصول',
                        labelText: 'توضیحات',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text(
                      "ثبت",
                      style: TextStyle(fontFamily: "Vazir"),
                    ),
                    onPressed: () {
                      Product pr = Product(
                          id: product?.id,
                          fullName: fullNameController.text,
                          description: descriptionController.text,
                          createDate: DateTime.now().toString(),
                          updateDate: DateTime.now().toString());
                      productService.addItem(pr);
                      showAlert();
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
