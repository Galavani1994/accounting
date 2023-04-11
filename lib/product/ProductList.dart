import 'package:accounting/product/Product.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

import 'ProductEdit.dart';
import 'ProductService.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final _formKey = GlobalKey<FormState>();

  void showAlert() {}

  @override
  Widget build(BuildContext context) {
    ProductService productService = ProductService();
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.add_box_outlined,size: 30,),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ProductEdit()));
                },
              ),
            ],
          ),
          preferredSize: Size.fromHeight(30.0),
        ),
        title: Text(
          "لیست کالا",
          style: TextStyle(fontFamily: "Vazir"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<Product>>(
          future: productService.fetchProducts(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Product>> snapshot) {
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
                    children: snapshot.data!.map((product) {
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
                                                    productService.deleteCustomer(
                                                        product.id.toString());
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
                                                          ProductEdit(
                                                            product: product,
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
                                          product.fullName,
                                          style: TextStyle(
                                              fontFamily: "Vazir",
                                              fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Text(
                                          product.description,
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
    );
  }
}
