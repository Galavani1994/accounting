import 'package:accounting/customer/Customer.dart';
import 'package:accounting/product/ProductService.dart';
import 'package:accounting/sale/SaleService.dart';
import 'package:accounting/sale/sale.dart';
import 'package:accounting/util/DatabaseHelper.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:quickalert/quickalert.dart';

import '../product/Product.dart';
import '../util/thousandFormatter.dart';

class SaleDetail extends StatefulWidget {
  Sale entity;

  SaleDetail({required this.entity});

  @override
  State<SaleDetail> createState() => _SaleDetailState();
}

class _SaleDetailState extends State<SaleDetail> {
  var customerFullName="";
  var productFullName="";

  @override
  Widget build(BuildContext context) {
    SaleService saleService = SaleService();
    saleService
        .getCustomerFullNameById(widget.entity.customerId)
        .then((value) => {
              setState(() {
                customerFullName = value!;
              })
            });
    saleService
        .getProductNameById(widget.entity.productId)
        .then((value) => {
      setState(() {
        productFullName = value!;
      })
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                f_date(widget.entity!.createDate),
                SizedBox(height: 15),
                f_customer(widget.entity.customerId),
                SizedBox(height: 15),
                f_product(widget.entity.productId),
                SizedBox(height: 15),
                f_quantity(widget.entity.quantity),
                SizedBox(height: 15),
                f_fee(widget.entity.price),
                SizedBox(height: 15),
                f_discount(widget.entity.discount),
                SizedBox(height: 20),
                f_payment(widget.entity.payment),
                SizedBox(height: 20),
                f_total(widget.entity.total),
                SizedBox(height: 20),
                f_description(widget.entity.description),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget f_date(String? date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          date!,
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "تاریخ",
          style: TextStyle(fontFamily: "Vazir"),
        ),
      ],
    );
  }

  Widget f_customer(int? customerId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          customerFullName,
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "نام",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_product(int? productId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          productFullName,
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "محصول",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_quantity(double? quantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          quantity.toString(),
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "تعداد",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_fee(int? price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatAmount(price.toString()),
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "قیمت",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_discount(int? discount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatAmount(discount.toString()),
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "تخفیف",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_payment(int? payment) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatAmount(payment.toString()),
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "پرداختی",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_total(String? total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formatAmount(total!),
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "مانده",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
  }

  Widget f_description(String? description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description!,
          style: TextStyle(fontFamily: "Vazir"),
        ),
        Text(
          "توضیحات",
          style: TextStyle(fontFamily: "Vazir"),
        )
      ],
    );
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
}
