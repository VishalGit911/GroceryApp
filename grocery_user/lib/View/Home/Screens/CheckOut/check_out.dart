import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/cart.dart';
import 'package:grocery_user/Model/order_data.dart';
import 'package:grocery_user/Widget/common_button.dart';

import '../AdressList/adress_list.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  double totalPrice = 0.00;

  List<Cart> cartList = [];
  List<Cart> totalPriceList = [];

  @override
  void initState() {
    calculateTotalPrice();
    // TODO: implement initState
    super.initState();
  }

  Future<void> calculateTotalPrice() async {
    List<Cart> cartTotalPricList =
        await FirebaseServices().getTotalPriceForCheckOut();

    totalPriceList = cartTotalPricList;

    calculateTotalSum();
  }

  void calculateTotalSum() {
    setState(() {
      totalPrice = totalPriceList.fold(
        0,
        (previousValue, element) => previousValue + element.totalPrice,
      );
    });
  }

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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdressListScreen(
                      orderData: OrderData(
                          cartItems: cartList, totalAmount: totalPrice),
                    ),
                  ));
            },
            text: Text("Your Total bill : $totalPrice"),
            backgroundColor: Colors.orange.shade300,
            foregroundColor: Colors.white),
      ),
      body: StreamBuilder(
          stream: FirebaseServices().getCartProduct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No data found",
                    style: TextStyle(color: Colors.black)),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final cart = snapshot.data![index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage(snapshot.data![index].imageUrl),
                    ),
                    title: Text("${snapshot.data![index].name}"),
                    trailing: IconButton(
                        onPressed: () {
                          FirebaseServices()
                              .deleteCartProduct(cart: cart, cartID: cart.id);
                        },
                        icon: Icon(Icons.delete)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${snapshot.data![index].description}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text("Price : ${snapshot.data![index].totalPrice}"),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${snapshot.data![index].quantity}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
