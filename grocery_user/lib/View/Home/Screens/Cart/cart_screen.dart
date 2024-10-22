import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/cart.dart';
import 'package:grocery_user/View/Home/Screens/CheckOut/check_out.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Cart"),
        centerTitle: true,
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
                      backgroundColor: Colors.white,
                      backgroundImage:
                          NetworkImage(snapshot.data![index].imageUrl),
                    ),
                    title: Text("${snapshot.data![index].name}"),
                    trailing: IconButton(
                        onPressed: () {
                          FirebaseServices().deleteCartProduct(
                              cart: cart!, cartID: snapshot.data![index].id);
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
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: (Colors.orange.shade300)),
                                onPressed: () {
                                  setState(() {
                                    updateCartContity(
                                        value: false,
                                        userData: snapshot.data![index]);
                                  });
                                },
                                icon: Icon(Icons.remove)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${snapshot.data![index].quantity}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            IconButton(
                                style: IconButton.styleFrom(
                                    backgroundColor: (Colors.orange.shade300)),
                                onPressed: () {
                                  setState(() {
                                    updateCartContity(
                                        value: true,
                                        userData: snapshot.data![index]);
                                  });
                                },
                                icon: Icon(Icons.add))
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange.shade300,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CheckOutScreen(),
              ));
        },
        label: Text("Check Out"),
        icon: Icon(Icons.shopping_cart_checkout),
      ),
    );
  }

  void updateCartContity({required bool value, required Cart userData}) {
    if (value) {
      userData.quantity++;
    } else {
      if (userData.quantity > 1) {
        userData.quantity--;
      }
    }

    setState(() {
      userData.totalPrice = (userData.price * userData.quantity).toDouble();
    });
    FirebaseServices().updataCartProduct(cart: userData, cartID: userData.id);
  }
}
