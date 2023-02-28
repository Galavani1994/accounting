import 'dart:ffi';

class Sale {
  final Long? id;
  String? createDate;
  String? updateDate;
  Long? productId;
  String? productName;
  Long? customerId;
  String? customerName;
  int? price;
  int? quantity;
  Long? total;
  int? discount;
  String? description;

  /*Sale({
    this.id,
    required this.createDate,
    required this.updateDate,
    this.description,
    required this.productId,
    required this.productName,
    required this.customerId,
    required this.customerName,
    required this.price,
    required this.quantity,
    required this.total,
    this.discount,
  });*/
  Sale({
    this.id,
    this.createDate,
    this.updateDate,
    this.description,
    this.productId,
    this.productName,
    this.customerId,
    this.customerName,
    this.price,
    this.quantity,
    this.total,
    this.discount,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "productId": productId,
      "productName": productName,
      "customerId": customerId,
      "customerName": customerName,
      "price": price,
      "quantity": quantity,
      "total": total,
      "discount": discount,
      "description": description,
      "createDate": createDate,
      "updateDate": updateDate
    };
  }
}
