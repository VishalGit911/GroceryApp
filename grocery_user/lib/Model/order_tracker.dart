
import 'dart:convert';

List<OrderTracker> orderTrackerFromJson(String str) => List<OrderTracker>.from(json.decode(str).map((x) => OrderTracker.fromJson(x)));

String orderTrackerToJson(List<OrderTracker> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderTracker {
  String orderPlaced;
  String shipped;
  String outOfDelivery;
  String delivery;
  String orderId;

  OrderTracker({
    required this.orderPlaced,
    required this.shipped,
    required this.outOfDelivery,
    required this.delivery,
    required this.orderId,
  });

  factory OrderTracker.fromJson(Map<String, dynamic> json) => OrderTracker(
    orderPlaced: json["order_placed"],
    shipped: json["shipped"],
    outOfDelivery: json["out_of_delivery"],
    delivery: json["delivery"],
    orderId: json["order_id"],
  );

  Map<String, dynamic> toJson() => {
    "order_placed": orderPlaced,
    "shipped": shipped,
    "out_of_delivery": outOfDelivery,
    "delivery": delivery,
    "order_id": orderId,
  };
}
