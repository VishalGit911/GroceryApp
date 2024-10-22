import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/order.dart';
import 'package:grocery_user/Model/order_data.dart';
import 'package:grocery_user/Model/user.dart';
import 'package:grocery_user/View/Home/Screens/AdressManage/adress_manage.dart';
import 'package:grocery_user/View/Home/home_screen.dart';
import 'package:grocery_user/Widget/common_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class AdressListScreen extends StatefulWidget {
  OrderData orderData;

  AdressListScreen({super.key, required this.orderData});

  @override
  State<AdressListScreen> createState() => _AdressListScreenState();
}

class _AdressListScreenState extends State<AdressListScreen> {
  late Razorpay _razorpay;
  late UserData _userData;
  late BuildContext buildContext;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void opencheckOut() {
    FirebaseServices().getUserData().then(
      (user) {
        if (user != null) {
          _userData = user;

          var options = {
            'key':
                'rzp_test_zM4qU8Fjyzh49g', // Replace with your Razorpay API key
            'amount': widget.orderData.totalAmount! *
                100, // Razorpay takes the amount in the smallest currency unit (e.g., paise for INR)
            'name': 'Grocery Store',

            'contact': user.contact,
            'prefill': {'email': user.email ?? 'test@gmail.com'},
            'external': {
              'wallets': ['paytm']
            }
          };
          try {
            _razorpay.open(options);
          } catch (e) {}
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: FirebaseServices().getAdress(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Not Your adress"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final alladress = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.orderData.address = alladress;
                      opencheckOut();
                    },
                    child: Card(
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 10,
                      child: ListTile(
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(alladress.buildingno),
                            Text(alladress.neararea),
                            Text(alladress.city),
                            Text(alladress.pincode),
                            Text(alladress.state),
                          ],
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              FirebaseServices()
                                  .deleteAdress(adressId: alladress.adressId!);
                            },
                            icon: Icon(Icons.delete)),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdressManageScreen(),
              ));
        },
      ),
    );
  }

  _handlePaymentSuccess(PaymentSuccessResponse response) {
    final String paymentId = response.paymentId!;

    print("-------------Payment success----------------");

    print(paymentId);

    storeDataFirebase(paymentId, widget.orderData, buildContext);

    print("function callrcf--------------------");

    FirebaseServices().trackerdata(orderId: "${response.orderId}");
  }

  _handlePaymentError() {}

  _handleExternalWallet() {}

  void storeDataFirebase(
      String paymentId, OrderData orderData, BuildContext buildContext) {
    Order order = Order(
        items: orderData.cartItems,
        orderDate: DateTime(2024, DateTime.now().month, DateTime.now().day),
        paymentId: paymentId,
        shippingAddress: orderData.address,
        status: "Panding",
        totalPrice: orderData.totalAmount,
        userId: _userData.id);

    FirebaseServices().placeOrder(order).then((value) {
      // ScaffoldMessenger.of(_context).showSnackBar(
      //     const SnackBar(content: Text('Order placed successfully')));

      print(
          "--------------------------------------1---------------------------");

      log(value.toString());

      if (value) {
        showPaymentSuccessDialog(buildContext);

        print(
            "------------------------------2------------------------------------");
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const HomeScreen(),
        //     ),
        //         (route) => false);
      }
    });
  }

  Future showPaymentSuccessDialog(BuildContext buildContext) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              Icon(
                CupertinoIcons.star_fill, // Star icon for congratulatory feel
                color: Colors.orangeAccent,
                size: 50,
              ),
              SizedBox(height: 10),
              Text(
                "Congratulations!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "You have successfully achieved your goal.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("OK"),
              onPressed: () {
                // Close the dialog when the user taps "OK"
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/*

 */
