class Customer {
  final int? id;
  String createDate;
  String updateDate;
  String fullName;
  String phoneNumber;
  String description;

  Customer({ this.id,required  this.fullName,required  this.phoneNumber,required  this.description,required this.createDate,required this.updateDate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "phoneNumber": phoneNumber,
      "description": description,
      "createDate": createDate,
      "updateDate": updateDate
    };
  }
}
