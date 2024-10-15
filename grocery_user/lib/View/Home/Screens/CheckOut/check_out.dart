import 'package:flutter/material.dart';
import 'package:grocery_user/View/Home/Screens/AdressList/adress_list.dart';
import 'package:grocery_user/Widget/common_button.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Checkout"),
      ),
      backgroundColor: Colors.white,
      bottomSheet: Container(
        color: Colors.white,
        height: 80,
        child: CommanButton(
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => AdressListScreen(),
              //     ));
            },
            text: Text("Your Total bill : 2000"),
            backgroundColor: Colors.orange.shade300,
            foregroundColor: Colors.white),
      ),
    );
  }
}
