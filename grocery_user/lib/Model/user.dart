class UserData {
  String id;
  String contact;
  String name;
  String email;
  int createdAt;

  UserData(
      {required this.id,
      required this.contact,
      required this.name,
      required this.email,
      required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "contact": contact,
      "name": name,
      "email": email,
      "createdAt": createdAt,
    };
  }

  factory UserData.fromJson(dynamic json) {
    return UserData(
      id: json["id"],
      contact: json["contact"],
      name: json["name"],
      email: json["email"],
      createdAt: json["createdAt"],
    );
  }
//
}
