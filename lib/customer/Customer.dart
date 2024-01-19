class Customer {
  final int? id;
  String createDate;
  String updateDate;
  String first_name;
  String last_name;
  String phone_number;
  String address;
  String description;

  Customer(
      {this.id,
      required this.first_name,
      required this.last_name,
      required this.phone_number,
      required this.address,
      required this.description,
      required this.createDate,
      required this.updateDate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phone_number,
      "address": address,
      "description": description,
      "create_date": createDate,
      "update_date": updateDate
    };
  }
}
