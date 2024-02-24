class SaleByType {
  int? person_id;
  String? fullName;
  String? creditor_amount;
  String? debtor_amount;
  String? total;

  SaleByType({
      this.person_id,
      this.fullName,
      this.creditor_amount,
      this.debtor_amount,
      this.total
  });

  @override
  String toString() {
    return 'SaleByType{person_id: $person_id, fullName: $fullName, creditor_amount: $creditor_amount, debtor_amount: $debtor_amount, total: $total}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": person_id,
      "product_id": fullName,
      "product_title": creditor_amount,
      "person_id": debtor_amount,
      "price": total
    };
  }
}
