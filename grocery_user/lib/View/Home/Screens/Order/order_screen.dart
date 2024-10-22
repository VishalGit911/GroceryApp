import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';

import 'package:order_tracker_zen/order_tracker_zen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? orderPlaced;
  String? shipped;
  String? outOfOrder;
  String? delivred;
  String? orderId;

  // Fix: Make initState async
  @override
  void initState() {
    super.initState();
    _loadTrackerData(); // Moved Firebase call to a separate method
  }

  Future<void> _loadTrackerData() async {
    // List<OrderTracker> demo = await FirebaseServices().getTrackerDate();
    setState(() {
      // Update state if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseServices().orderStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return Center(
              child: Text("No orders"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final order = snapshot.data![index];
                final shippingAddress = order.shippingAddress;

                // Check if shippingAddress is null before accessing its fields
                if (shippingAddress == null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Shipping address not available"),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${shippingAddress.buildingno ?? 'N/A'}\n"
                              "${shippingAddress.neararea ?? 'N/A'}\n"
                              "${shippingAddress.city ?? 'N/A'}\n"
                              "${shippingAddress.pincode ?? 'N/A'}",
                            ),
                          ),
                          OrderTrackerZen(tracker_data: [
                            TrackerData(
                                title: "Order Placed",
                                date: "${snapshot.data![index].orderDate}",
                                tracker_details: []),
                            TrackerData(
                                title: "Shipped",
                                date: "${snapshot.data![index].orderDate}",
                                tracker_details: []),
                            TrackerData(
                                title: "Out of order",
                                date: "${snapshot.data![index].orderDate}",
                                tracker_details: []),
                            TrackerData(
                                title: "Delivered",
                                date: "${snapshot.data![index].orderDate}",
                                tracker_details: [])
                          ])
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
