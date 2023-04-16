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

  @override
  Widget build(BuildContext context) {
    ProductService productService = ProductService();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              "لیست محصولات",
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
                          return GestureDetector(
                            onLongPress: () {
                              _showPopupMenu(context, product, productService);
                            },
                            child: Center(
                              child: Card(
                                child: ListTile(
                                  title: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
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
      BuildContext context, Product product, ProductService productService) async {
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
                leading: Icon(Icons.edit),
                title: Text('ویرایش'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductEdit(
                            product: product,
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
                          productService.deleteCustomer(product.id.toString());
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
