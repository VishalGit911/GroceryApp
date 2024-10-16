import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
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
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Not order"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Total Price : ${snapshot.data![index].status}"),
                          Text(
                              "Total Price : ${snapshot.data![index].totalPrice}"),
                          Text(
                              "Payment id : ${snapshot.data![index].paymentId}"),
                          Text("Order id : ${snapshot.data![index].orderId}"),
                          Text(
                              "Address : \n${snapshot.data![index].shippingAddress!.buildingno}\n${snapshot.data![index].shippingAddress!.neararea}\n${snapshot.data![index].shippingAddress!.city}\n${snapshot.data![index].shippingAddress!.pincode}"),
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
