import 'package:accounting/sale/sale.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
  TextEditingController productTitleController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController feeController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController paymentController = TextEditingController();
  TextEditingController totalController = TextEditingController(text: "0");
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateTimeController = TextEditingController(
      text: Jalali.fromDateTime(DateTime.now()).formatCompactDate().toString());

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController textProductController = TextEditingController();

  var selectedValue;

  var selectedCustomer;
  var selectedProduct;
  bool isChecked = false;

  SaleService saleService = SaleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 350,
                child: SingleChildScrollView(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              labelText: "تاریخ",
                              constraints: BoxConstraints.tightFor(height: 50)),
                        ),
                        SizedBox(height: 15),
                        f_customer(),
                        SizedBox(height: 15),
                        f_product(),
                        f_checkBox(),
                        SizedBox(height: 15),
                        f_product_title(),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            f_quantity(),
                            f_fee(),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            f_discount(),
                            f_payment(),
                          ],
                        ),
                        SizedBox(height: 20),
                        f_total(),
                        SizedBox(height: 20),
                        f_description(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          save(context);
                        },
                        child: Text(
                          "ثبت",
                          style: TextStyle(fontFamily: "Vazir"),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        child: Text(
                          "انصراف",
                          style: TextStyle(fontFamily: "Vazir"),
                        )),
                  ],
                ),
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

    return FutureBuilder<List<Customer>>(
      future: fetchCustomers,
      builder: (context, snapshot) {
        List<Customer>? items = snapshot.data;

        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'انتخاب مشتری',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).hintColor,
              ),
            ),
            items: items!
                .map((item) => DropdownMenuItem(
                      value: item.id.toString() +
                          "-" +
                          item.first_name +
                          "-" +
                          item.last_name,
                      child: Text(
                        item.first_name,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ))
                .toList(),
            value: selectedCustomer,
            onChanged: (value) {
              setState(() {
                selectedCustomer = value;
              });
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                color: Colors.black12,
              ),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: 'Search for an item...',
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ),
            // This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        );
      },
    );
  }

  Widget f_product() {
    ProductService service = ProductService();
    var fetchProducts = service.fetchProducts();
    return Visibility(
      visible: !isChecked,
      child: FutureBuilder<List<Product>>(
        future: fetchProducts,
        builder: (context, snapshot) {
          List<Product>? items = snapshot.data;

          return DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Text(
                'انتخاب محصول',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                ),
              ),
              items: items!
                  .map((item) => DropdownMenuItem(
                        value: item.id.toString() + "-" + item.fullName,
                        child: Text(
                          item.fullName,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                  .toList(),
              value: selectedProduct,
              onChanged: (value) {
                setState(() {
                  selectedProduct = value;
                });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  color: Colors.black12,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(
                maxHeight: 200,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: textProductController,
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
                  height: 50,
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 4,
                    right: 8,
                    left: 8,
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    controller: textProductController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      hintText: 'Search for an item...',
                      hintStyle: const TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                searchMatchFn: (item, searchValue) {
                  return item.value.toString().contains(searchValue);
                },
              ),
              // This to clear the search value when you close the menu
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textProductController.clear();
                }
              },
            ),
          );
        },
      ),
    );
  }

  Widget f_checkBox() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });
          },
        ),
        Text('محصول یافت نشد'),
      ],
    );
  }

  Widget f_product_title() {
    return Visibility(
      visible: isChecked,
      child: TextFormField(
        controller: productTitleController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            labelText: 'عنوان محصول'),
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
          labelText: 'اندازه',
          constraints: BoxConstraints.tightFor(width: 120, height: 50)),
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
          labelText: 'قیمت',
          constraints: BoxConstraints.tightFor(width: 120, height: 50)),
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
          labelText: 'تخفیف',
          constraints: BoxConstraints.tightFor(width: 120, height: 50)),
      inputFormatters: [ThousandsSeparatorInputFormatter()],
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget f_payment() {
    return TextFormField(
      controller: paymentController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: 'پرداختی',
          constraints: BoxConstraints.tightFor(width: 120, height: 50)),
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
          labelText: "جمع",
          constraints: BoxConstraints.tightFor(height: 50)),
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
          labelText: "توضیحات"),
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

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
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
      productId: selectedProduct == null
          ? null
          : int.parse(selectedProduct.split('-')[0]),
      productTitle: productTitleController.text,
      customerId: selectedCustomer == null
          ? null
          : int.parse(selectedCustomer.split('-')[0]),
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
    try {
      if (selectedCustomer != null) {
        saleService.addItem(sl);
        showAlert(context);
      } else {
        QuickAlert.show(
            context: context,
            title: "!...اخطار",
            text: "مشتری جهت ثبت انتخاب نشده است",
            type: QuickAlertType.error,
            confirmBtnText: 'تایید',
            borderRadius: 12,
            width: 60);
      }
    } catch (e) {
      print(e.toString());
    }
    FocusScope.of(context).unfocus();
  }

  void showAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      title: "",
      text: "عملیات با موفقیت انجام شد",
      type: QuickAlertType.success,
    );
  }
}
