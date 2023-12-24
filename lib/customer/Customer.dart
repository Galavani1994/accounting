class Customer {
  final int? id;
  String createDate;
  String updateDate;
  String first_name;
  String last_name;
  String phoneNumber;
  String address;
  String description;

  Customer(
      {this.id,
      required this.first_name,
      required this.last_name,
      required this.phoneNumber,
      required this.address,
      required this.description,
      required this.createDate,
      required this.updateDate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "phoneNumber": phoneNumber,
      "address": address,
      "description": description,
      "createDate": createDate,
      "updateDate": updateDate
    };
  }
}
