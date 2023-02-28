import 'package:accounting/customer/CustomeList.dart';
import 'package:accounting/customer/Customer.dart';
import 'package:accounting/customer/CustomerMain.dart';
import 'package:accounting/product/ProductList.dart';
import 'package:accounting/product/ProductService.dart';
import 'package:accounting/sale/SaleList.dart';
import 'package:accounting/sale/SaleService.dart';
import 'package:accounting/sale/sale.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:quickalert/quickalert.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../product/Product.dart';
import '../util/thousandFormatter.dart';

class SaleEdit extends StatelessWidget {
  Sale? sale;
  TextEditingController quantityController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController totalController = TextEditingController(text: "0");
  TextEditingController dateTimeController = TextEditingController();
  String? _selectedCustomer = "";
  String? _selectedProduct = "";
  List<String> _customers = ["محمد", "مهدی"];
  List<String> _products = ["قارچ ارومیه", "قارچ خوی", "قارچ تبریز"];

  SaleEdit({this.sale}) {
    _selectedCustomer = _customers[1];
    _selectedProduct = _products[1];
  }

  @override
  Widget build(BuildContext context) {
    void showAlert() {
      QuickAlert.show(
          context: context,
          title: "",
          text: "عملیات با موفقیت انجام شد",
          type: QuickAlertType.success);
    }

    SaleService saleService = SaleService();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                TextField(
                  onTap: () => showDatePickerPersian(context),
                  controller: dateTimeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: "date time"),
                ),
                SizedBox(height: 15),
                f_customer(),
                SizedBox(height: 15),
                f_product(),
                SizedBox(height: 15),
                f_quantity(),
                SizedBox(height: 15),
                f_fee(),
                SizedBox(height: 15),
                f_total(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          "بازگشت",
                          style: TextStyle(fontFamily: "Vazir"),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Sale pr = Sale(
                              id: sale?.id,
                              description: "",
                              createDate: DateTime.now().toString(),
                              updateDate: DateTime.now().toString());
                          saleService.addItem(pr);
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
      ),
    );
  }

  Widget f_customer() {
    DatabaseHelper dbHelper = DatabaseHelper();
    var fetchCustomers = dbHelper.fetchCustomers();
    return DropdownSearch<Customer>(
      asyncItems: (String filter) => fetchCustomers,
      itemAsString: (Customer u) => u.fullName,
      onChanged: (Customer? data) => print(data),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "customer",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }

  Widget f_product() {
    ProductService service = ProductService();
    var fetchProducts = service.fetchProducts();
    return DropdownSearch<Product>(
      asyncItems: (String filter) => fetchProducts,
      itemAsString: (Product u) => u.fullName,
      onChanged: (Product? data) => print(data),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "product",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }

  Widget f_quantity() {
    return TextFormField(
      onChanged: (value) => {calculateTotal(value)},
      controller: quantityController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        prefixIcon: const Icon(Icons.description),
        hintText: 'Enter your quantity',
        labelText: 'quantity',
      ),
    );
  }

  Widget f_fee() {
    return TextFormField(
      onChanged: (value) => {calculateTotal(value)},
      controller: feeController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        prefixIcon: const Icon(Icons.description),
        hintText: 'Enter fee',
        labelText: 'fee',
      ),
      inputFormatters: [ThousandsSeparatorInputFormatter()],
    );
  }

  Widget f_total() {
    return TextFormField(
      controller: totalController,
      enabled: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: "total"),
      keyboardType: TextInputType.number,
      inputFormatters: [ThousandsSeparatorInputFormatter()],
    );
  }

  void calculateTotal(String value) {
    print(value);
    if (value.isEmpty ||
        quantityController.text.isEmpty ||
        feeController.text.isEmpty) {
      totalController.text = "0";
    } else {
      value.replaceAll(",", "");
      double quantity =
          double.parse(quantityController.text.replaceAll(",", ""));
      double fee = double.parse(feeController.text.replaceAll(",", ""));
      int total = (quantity * fee).toInt();
      totalController.text = formatAmount(total.toString());
    }
  }

  String formatAmount(String price) {
    String priceInText = "";
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String str = price[i];
      if ((counter % 3) != 0 && i != 0) {
        priceInText = "$str$priceInText";
      } else if (i == 0) {
        priceInText = "$str$priceInText";
      } else {
        priceInText = ",$str$priceInText";
      }
    }
    return priceInText.trim();
  }

  void showDatePickerPersian(BuildContext context) {
    showPersianDatePicker(
      context: context,
      initialDate: Jalali.fromDateTime(DateTime.now()),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 8),
    ).then((value) =>
        dateTimeController.text = value!.formatCompactDate().toString());
  }
}
