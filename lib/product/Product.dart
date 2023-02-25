class Product {
  final int? id;
  String createDate;
  String updateDate;
  String fullName;
  String description;

  Product({ this.id,required  this.fullName,required  this.description,required this.createDate,required this.updateDate});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "fullName": fullName,
      "description": description,
      "createDate": createDate,
      "updateDate": updateDate
    };
  }
}
