import 'dart:ffi';

class Sale {
  int? id;
  String? createDate;
  String? updateDate;
  int? product_id;
  String? product_title;
  String? productName;
  int? customer_id;
  String? customerName;
  int? price;
  double? quantity;
  String? total;
  int? discount;
  int? payment;
  String? description;
  bool? creditor;

  Sale({
    this.id,
    this.createDate,
    this.updateDate,
    this.description,
    this.product_id,
    this.product_title,
    this.productName,
    this.customer_id,
    this.customerName,
    this.price,
    this.quantity,
    this.total,
    this.discount,
    this.payment,
    this.creditor
  });


  @override
  String toString() {
    return 'Sale{id: $id, createDate: $createDate, updateDate: $updateDate, productId: $product_id, productName: $productName, customerId: $customer_id, customerName: $customerName, price: $price, quantity: $quantity, total: $total, discount: $discount, payment: $payment, description: $description}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "product_id": product_id,
      "product_title": product_title,
      "person_id": customer_id,
      "price": price,
      "quantity": quantity,
      "total": total,
      "discount": discount,
      "description": description,
      "create_date": createDate,
      "update_date": updateDate,
      "payment": payment,
      "creditor":creditor
    };
  }
}
