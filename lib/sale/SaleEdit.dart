import 'package:accounting/sale/sale.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../product/Product.dart';
import '../product/ProductService.dart';
import '../util/thousandFormatter.dart';
import 'SaleService.dart';

class SaleEdit extends StatefulWidget {
  Sale entity;

  SaleEdit({required this.entity});

  @override
  State<SaleEdit> createState() => _SaleEditState();
}

class _SaleEditState extends State<SaleEdit> {
  TextEditingController customerFullNameController = TextEditingController();
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
  bool isCreditor = false;

  SaleService saleService = SaleService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCustomer = widget.entity.customer_id;
    SaleService saleService = SaleService();
    saleService
        .getCustomerFullNameById(widget.entity.customer_id)
        .then((value) => {
              setState(() {
                customerFullNameController.text = value!;
              })
            });
    if (widget.entity.product_id! > 0) {
      isChecked = false;
      saleService.getProductNameById(widget.entity.product_id).then((value) => {
        setState(() {
          selectedProduct = widget.entity.product_id.toString()+"-"+value!;
        })
      });

    } else {
      isChecked = true;
      productTitleController.text = widget.entity.product_title!;
    }
    isCreditor = widget.entity.creditor!;
    quantityController.text = widget.entity.quantity.toString();
    feeController.text = widget.entity.price.toString();
    discountController.text = widget.entity.discount.toString();
    paymentController.text = widget.entity.payment.toString();
    totalController.text = widget.entity.total.toString();
    descriptionController.text = widget.entity.description.toString();

    dateTimeController.text=widget.entity.createDate!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ویرایش صورتحساب",
          style: TextStyle(fontFamily: "Vazir"),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
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
                        f_creditor_checkBox(),
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
                        Row(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget f_customer() {
    return TextFormField(
      enabled: false,
      controller: customerFullNameController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: 'نام مشتری',
          constraints: BoxConstraints.tightFor(height: 50)),
    );
  }

  Widget f_product() {
    ProductService service = ProductService();
    var fetchProducts = service.fetchProducts();
    List<Product>? items = [];
    return Visibility(
      visible: !isChecked,
      child: FutureBuilder<List<Product>>(
        future: fetchProducts,
        builder: (context, snapshot) {
          items = snapshot.data;

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
              items: items
                  ?.map((item) => DropdownMenuItem(
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

  Widget f_creditor_checkBox() {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isCreditor,
          onChanged: (bool? value) {
            setState(() {
              isCreditor = value!;
            });
          },
        ),
        Text('بستانکار'),
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

      int total = (quantity * fee).toInt();
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

  Future<void> save(BuildContext context) async {
    Sale sl = Sale(
        id: widget.entity.id,
        description: descriptionController.text,
        createDate: dateTimeController.text,
        updateDate: DateTime.now().toString(),
        product_id: selectedProduct == null
            ? null
            : int.parse(selectedProduct.split('-')[0]),
        product_title: productTitleController.text,
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
        creditor: isCreditor);
    if (selectedCustomer != null && selectedCustomer > 0) {
      sl.customer_id = selectedCustomer;
    } else if (selectedCustomer == null ||
        selectedCustomer == "" ||
        selectedCustomer == "null") {
      selectedCustomer = null;
    } else {
      selectedCustomer = int.parse(selectedCustomer.split('-')[0]);
    }
    try {
      if (selectedCustomer != null) {
        int? res = await saleService.addItem(sl);
        clearForm();
        showAlert(context);
      } else {
        Fluttertoast.showToast(
            msg: "مشتری جهت ثبت انتخاب نشده است", timeInSecForIosWeb: 5);
      }
    } catch (e) {
      print(e.toString());
    }
    FocusScope.of(context).unfocus();
  }

  void clearForm() {
    isChecked = false;
    productTitleController.clear();
    selectedProduct = null;
    quantityController.clear();
    feeController.clear();
    discountController.clear();
    paymentController.clear();
    totalController.clear();
    descriptionController.clear();
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
