class AdressModel {
  String buildingno;
  String neararea;
  String city;
  String pincode;
  String state;
  String? adressId;

  AdressModel(
      {required this.buildingno,
      required this.neararea,
      required this.city,
      required this.pincode,
      required this.state,
      required this.adressId});

  Map<String, dynamic> toJson() {
    return {
      "id": buildingno,
      "name": neararea,
      "description": city,
      "imageUrl": pincode,
      "createdAt": state,
      "adressId": adressId,
    };
  }

  factory AdressModel.fromJson(dynamic json) {
    return AdressModel(
      adressId: json["adressId"],
      buildingno: json["id"],
      neararea: json["name"],
      city: json["description"],
      pincode: json["imageUrl"],
      state: json["createdAt"],
    );
  }
//
}
