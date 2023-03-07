import 'dart:ffi';

class Sale {
  final Long? id;
  String? createDate;
  String? updateDate;
  int? productId;
  String? productName;
  int? customerId;
  String? customerName;
  int? price;
  double? quantity;
  String? total;
  int? discount;
  int? payment;
  String? description;

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
    this.payment,
  });


  @override
  String toString() {
    return 'Sale{id: $id, createDate: $createDate, updateDate: $updateDate, productId: $productId, productName: $productName, customerId: $customerId, customerName: $customerName, price: $price, quantity: $quantity, total: $total, discount: $discount, payment: $payment, description: $description}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "productId": productId,
      "customerId": customerId,
      "price": price,
      "quantity": quantity,
      "total": total,
      "discount": discount,
      "description": description,
      "createDate": createDate,
      "updateDate": updateDate,
      "payment": payment
    };
  }
}
