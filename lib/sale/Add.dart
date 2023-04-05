import 'package:accounting/sale/sale.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../customer/Customer.dart';
import '../product/Product.dart';
import '../product/ProductService.dart';
import '../util/DatabaseHelper.dart';
import '../util/thousandFormatter.dart';
import 'SaleService.dart';

class Add extends StatefulWidget {
  Sale? sale;

  Add({Key? key, Sale? sale}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController quantityController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController totalController = TextEditingController(text: "0");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController();
  var selectedCustomer;
  var selectedProduct;

  SaleService saleService = SaleService();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15),
              TextField(
                keyboardType: TextInputType.none,
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
              f_discount(),
              SizedBox(height: 20),
              f_payment(),
              SizedBox(height: 20),
              f_total(),
              SizedBox(height: 20),
              f_description(),
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
                        save(context);
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

  Widget f_customer() {
    DatabaseHelper dbHelper = DatabaseHelper();
    var fetchCustomers = dbHelper.fetchCustomers();
    return DropdownSearch<Customer>(
      asyncItems: (String filter) => fetchCustomers,
      itemAsString: (Customer u) => u.fullName,
      onChanged: (Customer? data) => selectedCustomer = data?.id,
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
      onChanged: (Product? data) => selectedProduct = data?.id,
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
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: 'Enter your quantity',
        labelText: 'quantity',
      ),
    );
  }

  Widget f_fee() {
    return TextFormField(
      onChanged: (value) => {calculateTotal(value)},
      controller: feeController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: 'Enter fee',
        labelText: 'fee',
      ),
      inputFormatters: [ThousandsSeparatorInputFormatter()],
    );
  }

  Widget f_discount() {
    return TextFormField(
      onChanged: (value) => {calculateTotal(value)},
      controller: discountController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: 'Enter discount',
        labelText: 'discount',
      ),
      inputFormatters: [ThousandsSeparatorInputFormatter()],
    );
  }

  Widget f_payment() {
    return TextFormField(
      onChanged: (value) => {calculateTotal(value)},
      controller: paymentController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        hintText: 'Enter payment',
        labelText: 'payment',
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

  Widget f_description() {
    return TextFormField(
      controller: descriptionController,
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: "description"),
    );
  }

  void calculateTotal(String value) {
    if (quantityController.text.isEmpty || feeController.text.isEmpty) {
      totalController.text = "0";
    } else {
      value.replaceAll(",", "");
      double quantity =
          double.parse(quantityController.text.replaceAll(",", ""));
      double fee = double.parse(feeController.text.replaceAll(",", ""));
      int discount = discountController.text.isEmpty
          ? 0
          : int.parse(discountController.text.replaceAll(",", ""));
      int payment = paymentController.text.isEmpty
          ? 0
          : int.parse(paymentController.text.replaceAll(",", ""));
      int total = (quantity * fee).toInt() - discount - payment;
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

  void save(BuildContext context) {
    Sale sl = Sale(
      id: widget.sale?.id,
      description: descriptionController.text,
      createDate: dateTimeController.text,
      updateDate: DateTime.now().toString(),
      productId: selectedProduct,
      customerId: selectedCustomer,
      quantity: quantityController.text.isEmpty
          ? 0
          : double.parse(quantityController.text),
      price: feeController.text.isEmpty
          ? 0
          : int.parse(feeController.text.replaceAll(",", "")),
      discount: discountController.text.isEmpty
          ? 0
          : int.parse(discountController.text.replaceAll(",", "")),
      payment: paymentController.text.isEmpty
          ? 0
          : int.parse(paymentController.text.replaceAll(",", "")),
      total: totalController.text.isEmpty
          ? "0"
          : totalController.text.replaceAll(",", ""),
    );
    saleService.addItem(sl);
    showAlert(context);
    FocusScope.of(context).unfocus();
  }
  void showAlert(BuildContext context) {
    QuickAlert.show(
        context: context,
        title: "",
        text: "عملیات با موفقیت انجام شد",
        type: QuickAlertType.success);
  }
}
