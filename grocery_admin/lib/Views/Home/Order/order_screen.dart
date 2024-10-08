import 'package:flutter/material.dart';

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
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)),
            borderSide: BorderSide.none),
        title: Text("Order"),
        backgroundColor: Colors.pink.shade200,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          "Not Found",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
