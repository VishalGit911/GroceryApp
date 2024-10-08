import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/cart.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int quantity = 1;

  Cart? cart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  cart = snapshot.data![index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          NetworkImage(snapshot.data![index].imageUrl),
                    ),
                    title: Text("${snapshot.data![index].name}"),
                    trailing:
                        IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
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
                                  updateCartContity(
                                      value: false, userData: cart);
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
                                  updateCartContity(
                                      value: true, userData: cart);
                                },
                                icon: Icon(Icons.add))
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "Not your cart",
                  style: TextStyle(color: Colors.black),
                ),
              );
            }
          },
        ));
  }

  void updateCartContity({required bool value, required userData}) {
    if (value) {
      cart!.quantity++;
    } else {
      if (cart!.quantity > 1) {
        cart!.quantity--;
      }
    }

    setState(() {
      cart!.totalPrice = (cart!.price * cart!.quantity).toDouble();
    });
    FirebaseServices().updataCartProduct(cart: cart!, cartID: cart!.id);
  }
}
