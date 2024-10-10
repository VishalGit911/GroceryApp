import 'package:flutter/material.dart';
import 'package:grocery_user/Firebase/firebase_services.dart';
import 'package:grocery_user/Model/product.dart';
import 'package:grocery_user/Widget/common_button.dart';

class ShowDetailsProduct extends StatefulWidget {
  ProductModel productModel;
  ShowDetailsProduct({super.key, required this.productModel});

  @override
  State<ShowDetailsProduct> createState() => _ShowDetailsProductState();
}

class _ShowDetailsProductState extends State<ShowDetailsProduct> {
  int qauintity = 1;
  int price = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 350,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.productModel.imageUrl))),
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  style: IconButton.styleFrom(
                                      fixedSize: Size(50, 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      backgroundColor: Colors.yellow.shade400),
                                  onPressed: () {
                                    setState(() {
                                      if (qauintity > 1) {
                                        qauintity--;
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.black,
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "${qauintity}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              IconButton(
                                  style: IconButton.styleFrom(
                                      fixedSize: Size(50, 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      backgroundColor: Colors.yellow.shade400),
                                  onPressed: () {
                                    setState(() {
                                      qauintity++;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ))
                            ],
                          ),
                          Text(
                            "${qauintity * widget.productModel.price}",
                            style: TextStyle(fontSize: 25),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.favorite_border,
                                size: 35,
                              ))
                        ],
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "${widget.productModel.name}",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${widget.productModel.description}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    CommanButton(
                        onPressed: () {
                          FirebaseServices().addToCartProduct(
                              product: widget.productModel,
                              quantity: qauintity,
                              context: context);

                          Navigator.pop(context);
                        },
                        text: Text(
                          "Add To Cart",
                          style: TextStyle(fontSize: 18),
                        ),
                        backgroundColor: Colors.orange.shade500,
                        foregroundColor: Colors.white)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
