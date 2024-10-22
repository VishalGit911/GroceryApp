class Cart {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  int quantity;
  double totalPrice;
  int createdAt;

  Cart(
      {required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.imageUrl,
        required this.quantity,
        required this.createdAt,
        required this.totalPrice});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price": price,
      "imageUrl": imageUrl,
      "quantity": quantity,
      "totalPrice": totalPrice,
      "createdAt": createdAt,
    };
  }

  factory Cart.fromJson(dynamic json) {
    return Cart(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      price: double.parse(json["price"].toString()),
      imageUrl: json["imageUrl"],
      quantity: int.parse(json["quantity"].toString()),
      totalPrice: double.parse(json["totalPrice"].toString()),
      createdAt: json["createdAt"],
    );
  }
//
}
